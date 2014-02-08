package mgl;
import haxe.crypto.Md5;
class Util {
	static public inline function clamp(v:Float, min:Float = 0.0, max:Float = 1.0):Float {
		return c(v, min, max);
	}
	static public inline function c(v:Float, min:Float = 0.0, max:Float = 1.0):Float { // clamp
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	static public inline function clampInt(v:Int, min:Int, max:Int):Int {
		return ci(v, min, max);
	}
	static public inline function ci(v:Int, min:Int, max:Int):Int { // clamp int
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	static public inline function normalizeWay(v:Float):Float {
		return nw(v);
	}
	static public inline function nw(v:Float):Float { // normalizeWay
		var r = v % 360;
		if (r < -180) r += 360;
		else if (r > 180) r -= 360;
		return r;
	}
	static public inline function aimWay(v:Float, targetAngle:Float, angleVel:Float):Float {
		return aw(v, targetAngle, angleVel);
	}
	static public inline function aw(v:Float, targetAngle:Float, angleVel:Float):Float { // aimWay
		var oa = nw(targetAngle - v);
		var r:Float;
		if (oa > angleVel) r = v + angleVel;
		else if (oa < -angleVel) r = v - angleVel;
		else r = targetAngle;
		return nw(r);
	}
	static public inline function loopRange(v:Float, min:Float, max:Float):Float {
		return lr(v, min, max);
	}
	static public inline function lr(v:Float, min:Float, max:Float):Float { // loopRange
		var w = max - min;
		v -= min;
		var r:Float;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
	static public inline function loopRangeInt(v:Int, min:Int, max:Int):Int {
		return lri(v, min, max);
	}
	static public inline function lri(v:Int, min:Int, max:Int):Int { // loopRange int
		var w = max - min + 1;
		v -= min;
		var r:Int;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
	static public inline function random(v:Float = 1, s:Float = 0):Float {
		return Game.rn.n(v, s);
	}
	static public inline function rn(v:Float = 1, s:Float = 0):Float {
		return Game.rn.n(v, s);
	}
	static public inline function randomInt(v:Int, s:Int = 0):Int {
		return Game.rn.ni(v, s);
	}
	static public inline function rni(v:Int, s:Int = 0):Int {
		return Game.rn.ni(v, s);
	}
	static public inline function randomFromTo(from:Float, to:Float):Float {
		return Game.rn.f(from, to);
	}
	static public inline function rf(from:Float, to:Float):Float {
		return Game.rn.f(from, to);
	}
	static public inline function randomFromToInt(from:Int, to:Int):Int {
		return Game.rn.fi(from, to);
	}
	static public inline function rfi(from:Int, to:Int):Int {
		return Game.rn.fi(from, to);
	}
	static public inline function randomPlusMinus(v:Float = 1):Float {
		return Game.rn.p(v);
	}
	static public inline function rp(v:Float = 1):Float {
		return Game.rn.p(v);
	}
	static public inline function randomPlusMinusInt(v:Int):Int {
		return Game.rn.pi(v);
	}
	static public inline function rpi(v:Int):Int {
		return Game.rn.pi(v);
	}
	static public inline function randomPlusOrMinus():Int {
		return Game.rn.pm;
	}
	static public inline function rpm():Int {
		return Game.rn.pm;
	}
	static public function getClassHash(o:Dynamic):Int {
		return ch(o);
	}
	static public function ch(o:Dynamic):Int { // get class hash
		var c = Type.getClass(o);
		var s = Type.getClassName(c);
		var cfs = Type.getClassFields(c);
		cfs.sort(compareString);
		for (fieldName in cfs) s += "/" + fieldName;
		var ifs = Type.getInstanceFields(c);
		ifs.sort(compareString);
		for (fieldName in ifs) s += "/" + fieldName;
		return Std.parseInt("0x" + Md5.encode(s)) % 0xffffff;
	}
	static function compareString(x:String, y:String):Int {
		return if (x < y) -1 else if (x > y) 1 else 0;
	}
}