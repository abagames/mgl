package mgl;
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
using Math;
class S { // SoundEffect
	public var i(newInstance, null):S;
	public function bmj(l:Int = 64, v:Int = 16):S { return beginMarjor(l, v); }
	public function bmn(l:Int = 64, v:Int = 16):S { return beginMinor(l, v); }
	public function bn(l:Int = 64, v:Int = 16):S { return beginNoise(l, v); }
	public function bns(l:Int = 64, v:Int = 16):S { return beginNoiseScale(l, v); }
	public function w(width:Float = 0, interval:Float = 0):S { return setWave(width, interval); }
	public function t(from:Float, time:Int = 1, to:Float = 0):S { 
		return addTone(from, time, to);
	}
	public function r(v:Int = 1):S { return addRest(v); }
	public function l(v:Int = 64):S { return setLength(v); }
	public function v(v:Int = 16):S { return setVolume(v); }
	public var e(end, null):S;
	public var p(play, null):S;

	public static var s:Array<S>;
	static var g:G;
	static var tones:Array<Array<String>>;
	static var driver:SiONDriver;
	static var isStarting = false;
	static var u:U;
	public static function initialize(game:G):Void {
		g = game;
		s = new Array<S>();
		tones = [
		["c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b"],
		["c", "d", "e", "g", "a"],
		["c", "d-", "e-", "g-", "a-"]];
		driver = new SiONDriver();
		u = new U();
	}
	public static function updateAll():Void {
		for (se in s) se.update();
	}
	var data:SiONData;
	var isPlaying = false;
	var mml:String;
	var type:SeType;
	var waveWidth = 0.0;
	var waveInterval = 0.0;
	var toneIndex = 0;
	var lastPlayTicks = 0;
	public function new() { }
	function newInstance():S {
		return new S();
	}
	function beginMarjor(l:Int = 64, v:Int = 16):S {
		type = Major;
		begin(l, v);
		return this;
	}
	function beginMinor(l:Int = 64, v:Int = 16):S {
		type = Minor;
		begin(l, v);
		return this;
	}
	function beginNoise(l:Int = 64, v:Int = 16):S {
		type = Noise;
		begin(l, v);
		return this;
	}
	function beginNoiseScale(l:Int = 64, v:Int = 16):S {
		type = NoiseScale;
		begin(l, v);
		return this;
	}
	function setWave(width:Float, interval:Float):S {
		waveWidth = width;
		waveInterval = (interval == 0 ? 0 : Math.PI / 2 / interval);
		return this;
	}
	function addTone(from:Float, time:Int = 1, to:Float = 0):S {
		var tone = from;
		var step = (time > 1 ? (to - from) / (time - 1) : 0.0);
		var wa = 0.0;
		for (i in 0...time) {
			tone = u.c(tone, 0, 1);
			var tv = u.c(tone + wa.sin() * (waveWidth / 2), 0, 1);
			wa += waveInterval;
			switch (type) {
			case Major, Minor:
				var ti = Std.int(tv * 39);
				var o = Std.int(ti / 5 + 2);
				mml += "o" + o + tones[toneIndex][ti % 5];
			case Noise, NoiseScale:
				var ti = Std.int(tv * 14);
				if (ti < 4) mml += "o5" + tones[0][3 - ti];
				else mml += "o4" + tones[0][15 - ti];
			}
			tone += step;
		}
		return this;
	}
	function addRest(v:Int = 1):S {
		for (i in 0...v) mml += "r";
		return this;
	}
	function setLength(v:Int = 64):S {
		mml += "l" + l;
		return this;
	}
	function setVolume(v:Int = 16):S {
		mml += "v" + v;
		return this;
	}
	function end():S {
		isStarting = false;
		data = driver.compile(mml);
		driver.volume = 0;
		driver.play();
		s.push(this);
		return this;
	}
	function play():S {
		if (!g.ig || lastPlayTicks > 0) return this;
		isPlaying = true;
		return this;
	}

	function begin(l:Int, v:Int):Void {
		if (mml == null) mml = "";
		else mml += ";";
		var voice:Int;
		switch (type) {
			case Major: voice = 1; toneIndex = 1;
			case Minor: voice = 1; toneIndex = 2;
			case Noise: voice = 9;
			case NoiseScale: voice = 10;
		}
		mml += "%1@" + voice + "l" + l + "v" + v;
	}
	public function update():Void {
		lastPlayTicks--;
		if (!isPlaying) return;
		if (!isStarting) {
			driver.volume = 0.9;
			isStarting = true;
		}
		driver.sequenceOn(data, null, 0, 0, 0);
		isPlaying = false;
		lastPlayTicks = 5;
	}
}
enum SeType {
	Major;
	Minor;
	Noise;
	NoiseScale;
}