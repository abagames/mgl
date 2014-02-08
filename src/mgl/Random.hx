package mgl;
class Random { // Random
	static public var i(get, null):Random; // instance
	public inline function next(v:Float = 1, s:Float = 0):Float {
		return get() * v + s;
	}
	public inline function n(v:Float = 1, s:Float = 0):Float {
		return get() * v + s;
	}
	public inline function nextInt(v:Int, s:Int = 0):Int {
		return Std.int(get() * (v + 0.999) + s);
	}
	public inline function ni(v:Int, s:Int = 0):Int {
		return Std.int(get() * (v + 0.999) + s);
	}
	public inline function nextFromTo(from:Float, to:Float):Float {
		return get() * (to - from) + from;
	}
	public inline function f(from:Float, to:Float):Float {
		return get() * (to - from) + from;
	}
	public inline function nextFromToInt(from:Int, to:Int):Int {
		return Std.int(get() * (to - from + 0.999)) + from;
	}
	public inline function fi(from:Int, to:Int):Int {
		return Std.int(get() * (to - from + 0.999)) + from;
	}
	public inline function nextPlusOrMinus():Int {
		return get_pm();
	} 
	public var pm(get, null):Int; // plus or minus
	public inline function nextPlusMinus(v:Float = 1):Float {
		return f(-v, v);
	}
	public inline function p(v:Float = 1):Float {
		return f(-v, v);
	}
	public inline function nextPlusMinusInt(v:Int):Int {
		return fi(-v, v);
	}
	public inline function pi(v:Int):Int {
		return fi(-v, v);
	}
	public function s(v:Int = -0x7fffffff):Random {
		return setSeed(v);
	}
	public function setDifficultyBasisStage(stage:Int):Random {
		return bst(stage);
	}
	public function bst(stage:Int):Random {
		difficultyBasisStage = stage;
		return this;
	}
	public function setStage(stage:Int, seedOffset:Int = 0):Random {
		return st(stage, seedOffset);
	}
	public function st(stage:Int, seedOffset:Int = 0):Random {
		this.stage = stage;
		return setSeed(stage + seedOffset);
	}
	public inline function nextDifficultyCorrected():Float {
		return get_dc();
	}
	public var dc(get, null):Float; // next difficulty corrected

	var x = 0;
	var y = 0;
	var z = 0;
	var w = 0;
	var stage = 0;
	var difficultyBasisStage = 100;
	public function new() {
		setSeed();
	}
	static function get_i():Random {
		return new Random();
	}
	inline function get_pm():Int {
		return ni(1) * 2 - 1;
	}
	inline function get_dc():Float {
		return Math.pow(n(), difficultyBasisStage / (stage + 1));
	}

	public function setSeed(v:Int = -0x7fffffff):Random {
		var sv:Int;
		if (v == -0x7fffffff) sv = Std.int(Math.random() * 0x7fffffff);
		else sv = v;
		x = sv = 1812433253 * (sv ^ (sv >> 30));
		y = sv = 1812433253 * (sv ^ (sv >> 30)) + 1;
		z = sv = 1812433253 * (sv ^ (sv >> 30)) + 2;
		w = sv = 1812433253 * (sv ^ (sv >> 30)) + 3;
		return this;
	}
	inline function get():Float {
		var t:Int = x ^ (x << 11);
		x = y;
		y = z;
		z = w;
		w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
		var fw:Float = w;
		return fw / 0x7fffffff;
	}
}