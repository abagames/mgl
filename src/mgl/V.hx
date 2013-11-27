package mgl;
using Math;
class V { // Vector
	static public var i(get, null):V; // instance
	public var x = 0.0;
	public var y = 0.0;
	public function xy(x:Float = 0, y:Float = 0):V { return setXy(x, y); }
	public function n(n:Float = 0):V { return setNumber(n); }
	public function v(v:V):V { return setValue(v); }
	public var l(get, null):Float; // length
	public var w(get, null):Float; // way
	public var xi(get, null):Int; // x int
	public var yi(get, null):Int; // y int
	public function dt(pos:V):Float { return distanceTo(pos); }
	public function dtd(pos:V, pixelWHRatio:Float = -1):Float {
		return distanceToDistorted(pos, pixelWHRatio);
	}
	public function wt(pos:V):Float { return wayTo(pos); }
	public function a(v:V):V { return add(v); }
	public function s(v:V):V { return sub(v); }
	public function m(v:Float):V { return multiply(v); }
	public function d(v:Float):V { return divide(v); }
	public function aw(angle:Float, speed:Float):V { return addWay(angle, speed); }
	public function rt(angle:Float):V { return rotate(angle); }
	public function ii(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool {
		return isIn(spacing, minX, maxX, minY, maxY);
	}

	public function new() {	}
	static function get_i():V {
		return new V();
	}
	function setXy(x:Float, y:Float):V {
		this.x = x;
		this.y = y;
		return this;
	}
	function setNumber(n:Float):V {
		x = y = n;
		return this;
	}
	function setValue(v:V):V {
		x = v.x;
		y = v.y;
		return this;
	}
	function get_l():Float {
		return (x * x + y * y).sqrt();
	}
	function get_w():Float {
		return x.atan2(-y) * 180 / Math.PI;
	}
	function get_xi():Int {
		return Std.int(x);
	}
	function get_yi():Int {
		return Std.int(y);
	}
	function distanceTo(pos:V):Float {
		var ox = pos.x - x;
		var oy = pos.y - y;
		return (ox * ox + oy * oy).sqrt();
	}
	function distanceToDistorted(pos:V, pixelWHRatio:Float):Float {
		if (pixelWHRatio < 0) pixelWHRatio = G.pixelWHRatio;
		var ox = pos.x - x;
		var oy = pos.y - y;
		if (pixelWHRatio < 1) oy /= pixelWHRatio;
		else if (pixelWHRatio > 1) ox *= pixelWHRatio;
		return (ox * ox + oy * oy).sqrt();
	}
	function wayTo(pos:V):Float {
		return (pos.x - x).atan2(y - pos.y) * 180 / Math.PI;
	}
	function add(v:V):V {
		x += v.x;
		y += v.y;
		return this;
	}
	function sub(v:V):V {
		x -= v.x;
		y -= v.y;
		return this;
	}
	function multiply(v:Float):V {
		x *= v;
		y *= v;
		return this;
	}
	function divide(v:Float):V {
		x /= v;
		y /= v;
		return this;
	}
	function addWay(angle:Float, speed:Float):V {
		var a = angle * Math.PI / 180;
		x += a.sin() * speed;
		y -= a.cos() * speed;
		return this;
	}
	function rotate(angle:Float):V {
		var a = angle * Math.PI / 180;
		var px = x;
		x = x * a.cos() - y * a.sin();
		y = px * a.sin() + y * a.cos();
		return this;
	}
	function isIn(spacing:Float, minX:Float, maxX:Float, minY:Float, maxY:Float):Bool {
		return x >= minX - spacing && x <= maxX + spacing &&
			y >= minY - spacing && y <= maxY + spacing;
	}
}