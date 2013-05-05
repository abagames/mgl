package mgl;
class U {
	public function new() { }
	public inline function c(v:Float, min:Float, max:Float):Float { // clamp
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	public inline function ci(v:Int, min:Int, max:Int):Int { // clamp int
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	public inline function na(v:Float):Float { // normalizeAngle
		var r = v % (Math.PI * 2);
		if (r < -Math.PI) r += Math.PI * 2;
		else if (r > Math.PI) r -= Math.PI * 2;
		return r;
	}
	public inline function aa(v:Float, targetAngle:Float, angleVel:Float):Float { // aimAngle
		var oa = na(targetAngle - v);
		var r:Float;
		if (oa > angleVel) r = v + angleVel;
		else if (oa < -angleVel) r = v - angleVel;
		else r = targetAngle;
		return na(r);
	}
	public inline function cr(v:Float, max:Float, min:Float = 0):Float { // circleRange
		var w = max - min;
		v -= min;
		var r:Float;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
}