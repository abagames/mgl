package mgl;
using Math;
class Vector {
	static public var i(get, null):Vector; // instance
	public var x = 0.0;
	public var y = 0.0;
	public inline function xy(x:Float = 0, y:Float = 0):Vector { return setXy(x, y); }
	public inline function n(n:Float = 0):Vector { return setNumber(n); }
	public inline function v(v:Vector):Vector { return setValue(v); }
	public var length(get, null):Float;
	public var l(get, null):Float; // length
	public var way(get, null):Float;
	public var w(get, null):Float; // way
	public var xInt(get, null):Int;
	public var xi(get, null):Int; // x int
	public var yInt(get, null):Int;
	public var yi(get, null):Int; // y int
	public inline function dt(pos:Vector):Float { return distanceTo(pos); }
	public inline function dtd(pos:Vector, pixelWHRatio:Float = -1):Float {
		return distanceToDistorted(pos, pixelWHRatio);
	}
	public inline function wt(pos:Vector):Float { return wayTo(pos); }
	public inline function wtd(pos:Vector, pixelWHRatio:Float = -1):Float {
		return wayToDistorted(pos, pixelWHRatio);
	}
	public inline function a(v:Vector):Vector { return add(v); }
	public inline function s(v:Vector):Vector { return sub(v); }
	public inline function m(v:Float):Vector { return multiply(v); }
	public inline function d(v:Float):Vector { return divide(v); }
	public inline function aw(angle:Float, speed:Float):Vector { return addWay(angle, speed); }
	public inline function rt(angle:Float):Vector { return rotate(angle); }
	public inline function ii(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool {
		return isIn(spacing, minX, maxX, minY, maxY);
	}

	public function new() {	}
	static function get_i():Vector {
		return new Vector();
	}
	public inline function setXy(x:Float = 0, y:Float = 0):Vector {
		this.x = x;
		this.y = y;
		return this;
	}
	public inline function setNumber(n:Float = 0):Vector {
		x = y = n;
		return this;
	}
	public inline function setValue(v:Vector):Vector {
		x = v.x;
		y = v.y;
		return this;
	}
	inline function get_length():Float {
		return (x * x + y * y).sqrt();
	}
	inline function get_l():Float {
		return (x * x + y * y).sqrt();
	}
	inline function get_way():Float {
		return x.atan2(-y) * 180 / Math.PI;
	}
	inline function get_w():Float {
		return x.atan2(-y) * 180 / Math.PI;
	}
	inline function get_xInt():Int {
		return Std.int(x);
	}
	inline function get_xi():Int {
		return Std.int(x);
	}
	inline function get_yInt():Int {
		return Std.int(y);
	}
	inline function get_yi():Int {
		return Std.int(y);
	}
	public inline function distanceTo(pos:Vector):Float {
		var ox = pos.x - x;
		var oy = pos.y - y;
		return (ox * ox + oy * oy).sqrt();
	}
	public inline function distanceToDistorted(pos:Vector, pixelWHRatio:Float = -1):Float {
		if (pixelWHRatio < 0) pixelWHRatio = Game.pixelWHRatio;
		var ox = pos.x - x;
		var oy = pos.y - y;
		if (pixelWHRatio < 1) oy /= pixelWHRatio;
		else if (pixelWHRatio > 1) ox *= pixelWHRatio;
		return (ox * ox + oy * oy).sqrt();
	}
	public inline function wayTo(pos:Vector):Float {
		return (pos.x - x).atan2(y - pos.y) * 180 / Math.PI;
	}
	public inline function wayToDistorted(pos:Vector, pixelWHRatio:Float = -1):Float {
		if (pixelWHRatio < 0) pixelWHRatio = Game.pixelWHRatio;
		var ox = pos.x - x;
		var oy = y - pos.y;
		if (pixelWHRatio < 1) oy /= pixelWHRatio;
		else if (pixelWHRatio > 1) ox *= pixelWHRatio;
		return ox.atan2(oy) * 180 / Math.PI;
	}
	public inline function add(v:Vector):Vector {
		x += v.x;
		y += v.y;
		return this;
	}
	public inline function sub(v:Vector):Vector {
		x -= v.x;
		y -= v.y;
		return this;
	}
	public inline function multiply(v:Float):Vector {
		x *= v;
		y *= v;
		return this;
	}
	public inline function divide(v:Float):Vector {
		x /= v;
		y /= v;
		return this;
	}
	public inline function addWay(angle:Float, speed:Float):Vector {
		var a = angle * Math.PI / 180;
		x += a.sin() * speed;
		y -= a.cos() * speed;
		return this;
	}
	public inline function rotate(angle:Float):Vector {
		var a = angle * Math.PI / 180;
		var px = x;
		x = x * a.cos() - y * a.sin();
		y = px * a.sin() + y * a.cos();
		return this;
	}
	public inline function isIn(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool {
		return x >= minX - spacing && x <= maxX + spacing &&
			y >= minY - spacing && y <= maxY + spacing;
	}
}