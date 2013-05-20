package mgl;
class R { // Random
	public function ni(v:Int):R { return newInstance(v); }
	public function n(v:Float = 1, s:Float = 0):Float { return get() * v + s; }
	public function i(v:Int, s:Int = 0):Int { return Std.int(n(v, s)); }
	public function p():Int { return i(2) * 2 - 1; }
	public function pn(v:Float = 1):Float { return n(v) * p(); }
	public function s(v:Int = -0x7fffffff):R { return setSeed(v); }

	var x = 0;
	var y = 0;
	var z = 0;
	var w = 0;
	public function new(v:Int = -0x7fffffff) {
		setSeed(v);
	}
	function newInstance(v:Int = -0x7fffffff):R {
		return new R(v);
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
		return cast(w, Float) / 0x7fffffff;
	}
}