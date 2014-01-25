package mgl;
#if flash
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
import org.si.sound.DrumMachine;
#end
using Math;
using mgl.U;
class S { // Sound
	static public var i(get, null):S; // instance
	static public function fi(second:Float = 1):Void { fadeIn(second); }
	static public function fo(second:Float = 1):Void { fadeOut(second); }
	static public var s(get, null):Bool; // stop
	static public function dq(v:Int = 0):Void { setDefaultQuant(v); }
	public var mj(get, null):S; // major
	public var mn(get, null):S; // minor
	public var n(get, null):S; // noise
	public var ns(get, null):S; // noise scale
	public function t(from:Float, time:Int = 1, to:Float = 0):S {
		return addTone(from, time, to);
	}
	public function w(width:Float = 0, interval:Float = 1):S { return setWave(width, interval); }
	public function m(maxLength:Int = 3, step:Int = 1, seed:Int = -1):S {
		return setMelody(maxLength, step, seed);
	}
	public function mm(min:Float = -1, max:Float = 1):S { return setMinMax(min, max); }
	public function r(v:Int = 0):S { return addRest(v); }
	public function rp(v:Int = 1):S { return setRepeat(v); }
	public function rr(v:Int = 0):S { return setRepeatRest(v); }
	public function l(v:Int = 64):S { return setLength(v); }
	public function v(v:Float = 1):S { return setVolume(v); }
	public function q(v:Int = 0):S { return setQuant(v); }
	public var lp(get, null):S; // loop
	public var e(get, null):S; // end
	public function dm(seed:Int = -1,
	bassPattern:Int = -1, snarePattern:Int = -1, hihatPattern:Int = -1,
	bassVoice:Int = -1, snareVoice:Int = -1, hihatVoice:Int = -1):S {
		return setDrumMachine(seed, bassPattern, snarePattern, hihatPattern,
			bassVoice, snareVoice, hihatVoice);
	}
	public var p(get, null):S; // play

	static inline var BASE_VOLUME:Int = 5;
	static public var ss:Array<S>;
	static var baseRandomSeed = 0;
	static var tones:Array<Array<String>>;
	#if flash
	static var driver:SiONDriver;
	#end
	static var isStarting = false;
	static var defaultQuant = 0;
	public static function initialize(main:Dynamic):Void {
		baseRandomSeed = U.ch(main);
		ss = new Array<S>();
		tones = [
		["c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b"],
		["c", "d", "e", "g", "a"],
		["c", "d-", "e-", "g-", "a-"]];
		#if flash
		driver = new SiONDriver();
		#end
	}
	#if flash
	var data:SiONData;
	var drumMachine:DrumMachine;
	#end
	var isPlaying = false;
	var mml:String;
	var type:SeType;
	var length = 64;
	var volume = BASE_VOLUME;
	var quant = 0;
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
	public function new() {
		quant = defaultQuant;
	}
	static function get_i():S {
		return new S();
	}
	static function fadeIn(second:Float):Void {
		#if flash
		driver.fadeIn(second);
		#end
	}
	static function fadeOut(second:Float):Void {
		#if flash
		driver.fadeOut(second);
		#end
	}
	static function get_s():Bool {
		isStarting = false;
		#if flash
		driver.stop();
		driver.volume = 0;
		fadeIn(0.5);
		driver.play();
		#end
		return true;
	}
	static function setDefaultQuant(v:Int):Void {
		defaultQuant = v;
	}
	function get_mj():S {
		begin(Major);
		return this;
	}
	function get_mn():S {
		begin(Minor);
		return this;
	}
	function get_n():S {
		begin(Noise);
		return this;
	}
	function get_ns():S {
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
	function setMelody(maxLength:Int, step:Int, seed:Int):S {
		if (seed < 0) seed = baseRandomSeed++;
		melodyRandomSeed = seed;
		melodyMaxLength = maxLength.ci(1, 3);
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
	function setVolume(v:Float):S {
		volume = Std.int(v * BASE_VOLUME);
		mml += "v" + volume;
		return this;
	}
	function setQuant(v:Int):S {
		quant = v;
		return this;
	}
	function get_lp():S {
		mml += "$";
		return this;
	}
	function get_e():S {
		isStarting = false;
		#if flash
		data = driver.compile(mml);
		driver.volume = 0;
		driver.play();
		#end
		ss.push(this);
		return this;
	}
	function setDrumMachine(seed:Int,
	bassPattern:Int, snarePattern:Int, hihatPattern:Int,
	bassVoice:Int, snareVoice:Int, hihatVoice:Int):S {
		if (seed < 0) seed = baseRandomSeed++;
		var r = R.i.s(seed);
		if (bassPattern < 0) bassPattern = r.fi(1, 31);
		if (snarePattern < 0) snarePattern = r.fi(1, 18);
		if (hihatPattern < 0) hihatPattern = r.fi(1, 17);
		if (bassVoice < 0) bassVoice = r.fi(1, 6);
		if (snareVoice < 0) snareVoice = r.fi(1, 6);
		if (hihatVoice < 0) hihatVoice = r.fi(1, 4);
		isStarting = false;
		#if flash
		drumMachine = new DrumMachine(bassPattern, snarePattern, hihatPattern,
			bassVoice, snareVoice, hihatVoice);
		drumMachine.bassVolume = 1;
		drumMachine.snareVolume = .7;
		drumMachine.hihatVolume = .5;
		driver.volume = 0;
		driver.play();
		#end
		ss.push(this);
		return this;
	}
	function get_p():S {
		if (!G.ig || lastPlayTicks > 0) return this;
		isPlaying = true;
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
		var tMin = (tone + min * tiMax).c(0, tiMax);
		var tMax = (tone + max * tiMax).c(0, tiMax);
		var step = (time > 1 ? (to - from) * tiMax / (time - 1) : 0.0);
		var wa = 0.0;
		var t = time;
		while (t > 0) {
			tone = tone.c(tMin, tMax);
			var tv = (tone + wa.sin() * (waveWidth / 2) * tiMax).c(tMin, tMax);
			wa += waveInterval;
			if (random == null) {
				mml += getToneMml(Std.int(tv));
				t--;
			} else {
				if (random.ni(7) == 0) {
					mml += "r";
				} else {
					mml += getToneMml(Std.int(tv));
					tone += random.fi(-2, 2) * melodyStep;
				}
				var l = random.fi(1, melodyMaxLength.ci(1, t));
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
	public function u():Void {
		lastPlayTicks--;
		if (!isPlaying) return;
		if (!isStarting) {
			#if flash
			driver.volume = 1;
			#end
			isStarting = true;
		}
		#if flash
		if (data != null) driver.sequenceOn(data, null, 0, 0, quant);
		if (drumMachine != null) drumMachine.play();
		#end
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