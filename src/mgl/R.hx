package mgl;
class R { // Random
	static public var i(get, null):R; // instance
	public function n(v:Float = 1, s:Float = 0):Float { return get() * v + s; }	
	public function ni(v:Int, s:Int = 0):Int { return Std.int(get() * (v + 0.999) + s); }	
	public function f(from:Float, to:Float):Float { return get() * (to - from) + from; }
	public function fi(from:Int, to:Int):Int { return Std.int(get() * (to - from + 0.999)) + from; }
	public var pm(get, null):Int; // plus minus
	public function p(v:Float = 1):Float { return f(-v, v); }
	public function pi(v:Int):Int { return fi(-v, v); }
	public function s(v:Int = -0x7fffffff):R { return setSeed(v); }
	public function bst(stage:Int):R { difficultyBasisStage = stage; return this; }
	public function st(stage:Int, seedOffset:Int = 0):R {
		this.stage = stage;
		return setSeed(stage + seedOffset);
	}
	public var dc(get, null):Float; // difficulty corrected random

	var x = 0;
	var y = 0;
	var z = 0;
	var w = 0;
	var stage = 0;
	var difficultyBasisStage = 100;
	public function new() {
		setSeed();
	}
	static function get_i():R {
		return new R();
	}
	function get_pm():Int {
		return ni(1) * 2 - 1;
	}
	function get_dc():Float {
		return Math.pow(n(), difficultyBasisStage / (stage + 1));
	}

	function setSeed(v:Int = -0x7fffffff):R {
		var sv:Int;
		if (v == -0x7fffffff) sv = Std.int(Math.random() * 0x7fffffff);
		else sv = v;
		x = sv = 1812433253 * (sv ^ (sv >> 30));
		y = sv = 1812433253 * (sv ^ (sv >> 30)) + 1;
		z = sv = 1812433253 * (sv ^ (sv >> 30)) + 2;
		w = sv = 1812433253 * (sv ^ (sv >> 30)) + 3;
		return this;
	}
	function get():Float {
		var t:Int = x ^ (x << 11);
		x = y;
		y = z;
		z = w;
		w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
		var fw:Float = w;
		return fw / 0x7fffffff;
	}
}