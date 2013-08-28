package mgl;
class U { // Utility
	static public inline function c(v:Float, min:Float = 0.0, max:Float = 1.0):Float { // clamp
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	static public inline function ci(v:Int, min:Int, max:Int):Int { // clamp int
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	static public inline function na(v:Float):Float { // normalizeAngle
		var r = v % 360;
		if (r < -180) r += 360;
		else if (r > 180) r -= 360;
		return r;
	}
	static public inline function aa(v:Float, targetAngle:Float, angleVel:Float):Float { // aimAngle
		var oa = na(targetAngle - v);
		var r:Float;
		if (oa > angleVel) r = v + angleVel;
		else if (oa < -angleVel) r = v - angleVel;
		else r = targetAngle;
		return na(r);
	}
	static public inline function lr(v:Float, min:Float, max:Float):Float { // loopRange
		var w = max - min;
		v -= min;
		var r:Float;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
	static public inline function lri(v:Int, min:Int, max:Int):Int { // loopRange int
		var w = max - min;
		v -= min;
		var r:Int;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
	static public inline function rn(v:Float = 1, s:Float = 0):Float {
		return G.r.n(v, s);
	}
	static public inline function rni(v:Int, s:Int = 0):Int {
		return G.r.ni(v, s);
	}
	static public inline function rf(from:Float, to:Float):Float {
		return G.r.f(from, to);
	}
	static public inline function rfi(from:Int, to:Int):Int {
		return G.r.fi(from, to);
	}
	static public inline function rp(v:Float = 1):Float {
		return G.r.p(v);
	}
	static public inline function rpi(v:Int):Int {
		return G.r.pi(v);
	}
}