package mgl;
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
using Math;
class S { // SoundEffect
	public var i(newInstance, null):S;
	public var mj(beginMajor, null):S;
	public var mn(beginMinor, null):S;
	public var n(beginNoise, null):S;
	public var ns(beginNoiseScale, null):S;
	public function t(from:Float, time:Int = 1, to:Float = 0):S {
		return addTone(from, time, to);
	}
	public function w(width:Float = 0, interval:Float = 0):S { return setWave(width, interval); }
	public function m(randomSeed:Int = 0, maxLength:Int = 3, step:Int = 1):S {
		return setMelody(randomSeed, maxLength, step);
	}
	public function mm(min:Float = -1, max:Float = 1):S { return setMinMax(min, max); }
	public function r(v:Int = 0):S { return addRest(v); }
	public function rp(v:Int = 1):S { return setRepeat(v); }
	public function rr(v:Int = 0):S { return setRepeatRest(v); }
	public function l(v:Int = 64):S { return setLength(v); }
	public function v(v:Int = 16):S { return setVolume(v); }
	public var lp(setLoopStart, null):S;
	public var e(end, null):S;
	public var p(play, null):S;
	public function fi(second:Float = 1):S { return fadeIn(second); }
	public function fo(second:Float = 1):S { return fadeOut(second); }
	public var s(stopAll, null):S;

	public static var ss:Array<S>;
	static var g:G;
	static var tones:Array<Array<String>>;
	static var driver:SiONDriver;
	static var isStarting = false;
	static var _u:U;
	public static function initialize(game:G):Void {
		g = game;
		ss = new Array<S>();
		tones = [
		["c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b"],
		["c", "d", "e", "g", "a"],
		["c", "d-", "e-", "g-", "a-"]];
		driver = new SiONDriver();
		_u = new U();
	}
	var data:SiONData;
	var isPlaying = false;
	var mml:String;
	var type:SeType;
	var length = 64;
	var volume = 16;
	var min = -1.0;
	var max = 1.0;
	var waveWidth = 0.0;
	var waveInterval = 0.0;
	var melodyRandomSeed = 0;
	var melodyMaxLength = 3;
	var melodyStep = 1;
	var repeat = 1;
	var repeatRest = 0;
	var toneIndex = 0;
	var lastPlayTicks = 0;
	public function new() { }
	function newInstance():S {
		return new S();
	}
	function beginMajor():S {
		begin(Major);
		return this;
	}
	function beginMinor():S {
		begin(Minor);
		return this;
	}
	function beginNoise():S {
		begin(Noise);
		return this;
	}
	function beginNoiseScale():S {
		begin(NoiseScale);
		return this;
	}
	function addTone(from:Float, time:Int = 1, to:Float = 0):S {
		for (i in 0...repeat) addToneOnce(from, time, to);
		return this;
	}
	function setWave(width:Float, interval:Float):S {
		waveWidth = width;
		waveInterval = (interval == 0 ? 0 : Math.PI / 2 / interval);
		return this;
	}
	function setMelody(randomSeed:Int, maxLength:Int, step:Int):S {
		melodyRandomSeed = randomSeed;
		melodyMaxLength = _u.ci(maxLength, 1, 3);
		melodyStep = step;
		return this;
	}
	function setMinMax(min:Float, max:Float):S {
		this.min = min;
		this.max = max;
		return this;
	}
	function addRest(v:Int):S {
		mml += "r";
		if (v > 0) mml += v;
		return this;
	}
	function setRepeat(v:Int):S {
		repeat = v;
		return this;
	}
	function setRepeatRest(v:Int):S {
		repeatRest = v;
		return this;
	}
	function setLength(v:Int):S {
		length = v;
		mml += "l" + v;
		return this;
	}
	function setVolume(v:Int):S {
		volume = v;
		mml += "v" + v;
		return this;
	}
	function setLoopStart():S {
		mml += "$";
		return this;
	}
	function end():S {
		isStarting = false;
		data = driver.compile(mml);
		driver.volume = 0;
		driver.play();
		ss.push(this);
		return this;
	}
	function play():S {
		if (!g.ig || lastPlayTicks > 0) return this;
		isPlaying = true;
		return this;
	}
	function fadeIn(second:Float):S {
		driver.fadeIn(second);
		return this;
	}
	function fadeOut(second:Float):S {
		driver.fadeOut(second);
		return this;
	}
	function stopAll():S {
		isStarting = false;
		driver.stop();
		driver.volume = 0;
		driver.play();
		fadeIn(0);
		return this;
	}

	function begin(type:SeType):Void {
		this.type = type;
		if (mml == null) mml = "";
		else mml += ";";
		var voice:Int;
		switch (type) {
			case Major: voice = 1; toneIndex = 1;
			case Minor: voice = 1; toneIndex = 2;
			case Noise: voice = 9; toneIndex = 0;
			case NoiseScale: voice = 10; toneIndex = 0;
		}
		mml += "%1@" + voice + "l" + length + "v" + volume;
	}
	function addToneOnce(from:Float, time:Int = 1, to:Float = 0):S {
		var tiMax = ((type == Noise || type == NoiseScale) ? 14 : 39);
		var random:R = null;
		if (melodyRandomSeed != 0) random = new R().s(melodyRandomSeed);
		var tone = from * tiMax;
		if (to == 0) to = from;
		var tMin = _u.c(tone + min * tiMax, 0, tiMax);
		var tMax = _u.c(tone + max * tiMax, 0, tiMax);
		var step = (time > 1 ? (to - from) * tiMax / (time - 1) : 0.0);
		var wa = 0.0;
		var t = time;
		while (t > 0) {
			tone = _u.c(tone, tMin, tMax);
			var tv = _u.c(tone + wa.sin() * (waveWidth / 2) * tiMax, tMin, tMax);
			wa += waveInterval;
			if (random == null) {
				mml += getToneMml(Std.int(tv));
				t--;
			} else {
				if (random.i(7) == 0) {
					mml += "r";
				} else {
					mml += getToneMml(Std.int(tv));
					tone += random.i(5, -2) * melodyStep;
				}
				var l = random.i(_u.ci(melodyMaxLength, 1, t), 1);
				if (l >= 2) mml += length / 2;
				if (l == 3) mml += ".";
				t -= l;
			}
			for (j in 0...repeatRest) mml += "r";
			tone += step;
		}
		return this;
	}
	function getToneMml(ti:Int):String {
		switch (type) {
		case Major, Minor:
			return "o" + Std.int(ti / 5 + 2) + tones[toneIndex][ti % 5];
		case Noise, NoiseScale:
			return (ti < 4 ? "o5" + tones[0][3 - ti] : "o4" + tones[0][15 - ti]);
		}
	}
	public function u():Bool {
		lastPlayTicks--;
		if (!isPlaying) return true;
		if (!isStarting) {
			driver.volume = 0.9;
			isStarting = true;
		}
		driver.sequenceOn(data, null, 0, 0, 0);
		isPlaying = false;
		lastPlayTicks = 5;
		return true;
	}
}
enum SeType {
	Major;
	Minor;
	Noise;
	NoiseScale;
}