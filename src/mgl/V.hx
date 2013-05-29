package mgl;
using Math;
class V { // Vector
	public var i(get, null):V; // instance
	public var x = 0.0;
	public var y = 0.0;
	public function xy(x:Float = 0, y:Float = 0):V { return setXy(x, y); }
	public function n(n:Float = 0):V { return setNumber(n); }
	public function v(v:V):V { return setValue(v); }
	public var l(get, null):Float; // length
	public var an(get, null):Float; // angle
	public var xi(get, null):Int; // x int
	public var yi(get, null):Int; // y int
	public function dt(pos:V):Float { return distanceTo(pos); }
	public function wt(pos:V):Float { return wayTo(pos); }
	public function a(v:V):V { return add(v); }
	public function s(v:V):V { return sub(v); }
	public function m(v:Float):V { return multiply(v); }
	public function d(v:Float):V { return divide(v); }
	public function aa(angle:Float, speed:Float):V { return addAngle(angle, speed); }
	public function r(angle:Float):V { return rotate(angle); }
	public function ii(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool {
		return isIn(spacing, minX, maxX, minY, maxY);
	}

	public function new() {	}
	function get_i():V {
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
	function get_an():Float {
		return y.atan2(x);
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
	function wayTo(pos:V):Float {
		return (pos.y - y).atan2(pos.x - x);
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
	function addAngle(angle:Float, speed:Float):V {
		x += angle.cos() * speed;
		y += angle.sin() * speed;
		return this;
	}
	function rotate(angle:Float):V {
		var px = x;
		x = x * angle.cos() - y * angle.sin();
		y = px * angle.sin() + y * angle.cos();
		return this;
	}
	function isIn(spacing:Float, minX:Float, maxX:Float, minY:Float, maxY:Float):Bool {
		return x >= minX - spacing && x <= maxX + spacing &&
			y >= minY - spacing && y <= maxY + spacing;
	}
}