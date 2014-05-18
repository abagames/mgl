package mgl;
#if flash
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
import org.si.sound.DrumMachine;
#end
using Math;
using mgl.Util;
class Sound {
	static public var i(get, null):Sound; // instance
	static public function fi(second:Float = 1):Void { fadeIn(second); }
	static public function fo(second:Float = 1):Void { fadeOut(second); }
	static public function stop():Bool { return get_s(); }
	static public var s(get, null):Bool; // stop
	static public function dq(v:Int = 0):Void { setDefaultQuant(v); }
	static public function b(v:Float = 120):Void { setBpm(v); }
	public function major():Sound { return get_mj(); }
	public var mj(get, null):Sound; // major
	public function minor():Sound { return get_mn(); }
	public var mn(get, null):Sound; // minor
	public function noise():Sound { return get_n(); }
	public var n(get, null):Sound; // noise
	public function noiseScale():Sound { return get_ns(); }
	public var ns(get, null):Sound; // noise scale
	public function t(from:Float, time:Int = 1, to:Float = 0):Sound {
		return addTone(from, time, to);
	}
	public function w(width:Float = 0, interval:Float = 1):Sound { return setWave(width, interval); }
	public function m(maxLength:Int = 3, step:Int = 1, seed:Int = -1):Sound {
		return setMelody(maxLength, step, seed);
	}
	public function mm(min:Float = -1, max:Float = 1):Sound { return setMinMax(min, max); }
	public function r(v:Int = 0):Sound { return addRest(v); }
	public function rp(v:Int = 1):Sound { return setRepeat(v); }
	public function rr(v:Int = 0):Sound { return setRepeatRest(v); }
	public function l(v:Int = 64):Sound { return setLength(v); }
	public function v(v:Float = 1):Sound { return setVolume(v); }
	public function q(v:Int = 0):Sound { return setQuant(v); }
	public function setLoop():Sound { return get_lp(); }
	public var lp(get, null):Sound; // set loop
	public function end():Sound { return get_e(); }
	public var e(get, null):Sound; // end
	public function dm(seed:Int = -1,
	bassPattern:Int = -1, snarePattern:Int = -1, hihatPattern:Int = -1,
	bassVoice:Int = -1, snareVoice:Int = -1, hihatVoice:Int = -1):Sound {
		return setDrumMachine(seed, bassPattern, snarePattern, hihatPattern,
			bassVoice, snareVoice, hihatVoice);
	}
	public function play():Sound { return get_p(); }
	public var p(get, null):Sound; // play

	static inline var BASE_VOLUME:Int = 4;
	static public var ss:Array<Sound>;
	static var baseRandomSeed = 0;
	static var tones:Array<Array<String>>;
	#if flash
	static var driver:SiONDriver;
	#end
	static var isStarting = false;
	static var defaultQuant = 0;
	static public function initialize(main:Dynamic):Void {
		baseRandomSeed = Util.ch(main);
		ss = new Array<Sound>();
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
	static function get_i():Sound {
		return new Sound();
	}
	static public function fadeIn(second:Float = 1):Void {
		#if flash
		driver.fadeIn(second);
		#end
	}
	static public function fadeOut(second:Float = 1):Void {
		#if flash
		driver.fadeOut(second);
		#end
	}
	static function get_s():Bool {
		isStarting = false;
		#if flash
		driver.stop();
		driver.volume = 0;
		driver.play();
		#end
		return true;
	}
	static public function setDefaultQuant(v:Int = 0):Void {
		defaultQuant = v;
	}
	static public function setBpm(v:Float = 120):Void {
		#if flash
		driver.bpm = v;
		#end
	}
	function get_mj():Sound {
		begin(Major);
		return this;
	}
	function get_mn():Sound {
		begin(Minor);
		return this;
	}
	function get_n():Sound {
		begin(Noise);
		return this;
	}
	function get_ns():Sound {
		begin(NoiseScale);
		return this;
	}
	public function addTone(from:Float, time:Int = 1, to:Float = 0):Sound {
		for (i in 0...repeat) addToneOnce(from, time, to);
		return this;
	}
	public function setWave(width:Float = 0, interval:Float = 1):Sound {
		waveWidth = width;
		waveInterval = (interval == 0 ? 0 : Math.PI / 2 / interval);
		return this;
	}
	public function setMelody(maxLength:Int = 3, step:Int = 1, seed:Int = -1):Sound {
		if (seed < 0) seed = baseRandomSeed++;
		melodyRandomSeed = seed;
		melodyMaxLength = maxLength.clampInt(1, 3);
		melodyStep = step;
		return this;
	}
	public function setMinMax(min:Float = -1, max:Float = 1):Sound {
		this.min = min;
		this.max = max;
		return this;
	}
	public function addRest(v:Int = 0):Sound {
		mml += "r";
		if (v > 0) mml += v;
		return this;
	}
	public function setRepeat(v:Int = 1):Sound {
		repeat = v;
		return this;
	}
	public function setRepeatRest(v:Int = 0):Sound {
		repeatRest = v;
		return this;
	}
	public function setLength(v:Int = 64):Sound {
		length = v;
		mml += "l" + v;
		return this;
	}
	public function setVolume(v:Float = 1):Sound {
		volume = Std.int(v * BASE_VOLUME);
		mml += "v" + volume;
		return this;
	}
	public function setQuant(v:Int = 0):Sound {
		quant = v;
		return this;
	}
	function get_lp():Sound {
		mml += "$";
		return this;
	}
	function get_e():Sound {
		isStarting = false;
		#if flash
		data = driver.compile(mml);
		driver.volume = 0;
		driver.play();
		#end
		ss.push(this);
		return this;
	}
	public function setDrumMachine(seed:Int = -1,
	bassPattern:Int = -1, snarePattern:Int = -1, hihatPattern:Int = -1,
	bassVoice:Int = -1, snareVoice:Int = -1, hihatVoice:Int = -1):Sound {
		if (seed < 0) seed = baseRandomSeed++;
		var r = new Random().setSeed(seed);
		if (bassPattern < 0) bassPattern = r.nextFromToInt(1, 31);
		if (snarePattern < 0) snarePattern = r.nextFromToInt(1, 18);
		if (hihatPattern < 0) hihatPattern = r.nextFromToInt(1, 17);
		if (bassVoice < 0) bassVoice = r.nextFromToInt(1, 6);
		if (snareVoice < 0) snareVoice = r.nextFromToInt(1, 6);
		if (hihatVoice < 0) hihatVoice = r.nextFromToInt(1, 4);
		isStarting = false;
		#if flash
		drumMachine = new DrumMachine(bassPattern, snarePattern, hihatPattern,
			bassVoice, snareVoice, hihatVoice);
		drumMachine.bassVolume = .95;
		drumMachine.snareVolume = .9;
		drumMachine.hihatVolume = .85;
		driver.volume = 0;
		driver.play();
		#end
		ss.push(this);
		return this;
	}
	function get_p():Sound {
		if (!Game.ig || lastPlayTicks > 0) return this;
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
	function addToneOnce(from:Float, time:Int = 1, to:Float = 0):Sound {
		var tiMax = ((type == Noise || type == NoiseScale) ? 14 : 39);
		var random:Random = null;
		if (melodyRandomSeed != 0) random = new Random().setSeed(melodyRandomSeed);
		var tone = from * tiMax;
		if (to == 0) to = from;
		var tMin = (tone + min * tiMax).clamp(0, tiMax);
		var tMax = (tone + max * tiMax).clamp(0, tiMax);
		var step = (time > 1 ? (to - from) * tiMax / (time - 1) : 0.0);
		var wa = 0.0;
		var t = time;
		while (t > 0) {
			tone = tone.clamp(tMin, tMax);
			var tv = (tone + wa.sin() * (waveWidth / 2) * tiMax).clamp(tMin, tMax);
			wa += waveInterval;
			if (random == null) {
				mml += getToneMml(Std.int(tv));
				t--;
			} else {
				if (random.ni(7) == 0) {
					mml += "r";
				} else {
					mml += getToneMml(Std.int(tv));
					tone += random.nextPlusMinusInt(2) * melodyStep;
				}
				var l = random.fi(1, melodyMaxLength.clampInt(1, t));
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
	public function update():Void {
		lastPlayTicks--;
		if (!isPlaying) return;
		if (!isStarting) {
			#if flash
			fadeIn(1);
			driver.volume = .95;
			#end
			isStarting = true;
		}
		#if flash
		if (data != null) driver.sequenceOn(data, null, 0, 0, quant);
		if (drumMachine != null) {
			drumMachine.quantize = quant;
			drumMachine.play();
		}
		#end
		isPlaying = false;
		lastPlayTicks = 10;
	}
}
enum SeType {
	Major;
	Minor;
	Noise;
	NoiseScale;
}