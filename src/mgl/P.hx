package mgl;
import mgl.G.Screen;
class P { // Particle
	static public var i(get, null):P; // instance
	static public function sc(vx:Float, vy:Float = 0,
	minX:Float = -9999999, maxX:Float = 9999999, minY:Float = -9999999, maxY:Float = 9999999):Void {
		A.sc("mgl.PActor", vx, vy, minX, maxX, minY, maxY);
	}
	public function p(pos:V):P { return setPos(pos); }
	public function xy(x:Float, y:Float):P { return setXy(x, y); }
	public function z(z:Float = 0):P { return setZ(z); }
	public function c(color:C):P { return setColor(color); }
	public function cn(count:Int):P { return setCount(count); }
	public function sz(size:Float):P { return setSize(size); }
	public function s(speed:Float):P { return setSpeed(speed); }
	public function t(ticks:Float):P { return setTicks(ticks); }
	public function w(angle:Float, angleWidth:Float = 0.0):P { return setWay(angle, angleWidth); }
	public var a(get, null):P; // add

	static var random:R;
	public static function initialize():Void {
		random = new R();
	}
	var aPos:V;
	var aZ = 0.0;
	var aColor:C;
	var aCount = 1;
	var aSize = 0.02;
	var aSpeed = 0.02;
	var aTicks = 60;
	var aAngle = 0.0;
	var aAngleWidth = 360.0;
	public function new() {
		aPos = new V();
		aColor = C.wi;
	}
	static function get_i():P {
		return new P();
	}
	function setPos(pos:V):P {
		aPos.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):P {
		aPos.xy(x, y);
		return this;
	}
	function setZ(z:Float):P {
		aZ = z;
		return this;
	}
	function setColor(color:C):P {
		aColor = color;
		return this;
	}
	function setCount(count:Int):P {
		aCount = count;
		return this;
	}
	function setSize(size:Float):P {
		aSize = size;
		return this;
	}
	function setSpeed(speed:Float):P {
		aSpeed = speed;
		return this;
	}
	function setTicks(ticks:Float):P {
		aTicks = Std.int(ticks);
		return this;
	}
	function setWay(angle:Float, angleWidth:Float):P {
		aAngle = angle;
		aAngleWidth = angleWidth;
		return this;
	}
	function get_a():P {
		for (i in 0...aCount) {
			var pa = new PActor();
			pa.color = aColor;
			pa.targetSize = aSize;
			pa.p.v(aPos);
			pa.z = aZ;
			pa.v.aw(aAngle + random.p(aAngleWidth / 2), random.n(aSpeed));
			pa.removeTicks = Std.int(aTicks * random.f(0.5, 1.5));
		}
		return this;
	}
}
class PActor extends A {
	static var pixelSize:V;
	static var pixelSizeL:Float;
	override public function i() {
		pixelSize = G.pixelSize;
		pixelSizeL = G.pixelWHRatio < 1 ? pixelSize.x : pixelSize.y;
		dp(0);
	}
	public var removeTicks = 60;
	public var color:C;
	public var targetSize:Float;
	var size = 0.01;
	var isExpand = true;
	override public function u() {
		p.a(v);
		v.m(0.98);
		if (isExpand) {
			size *= 1.5;
			if (size > targetSize) isExpand = false;
		} else {
			size *= 0.95;
		}
		var s = size * pixelSizeL;
		var px:Int;
		var py:Int;
		var ps:Int;
		if (z == 0) {
			px = Std.int(p.x * pixelSize.x - s / 2);
			py = Std.int(p.y * pixelSize.y - s / 2);
			ps = Std.int(s);
		} else {
			var zs = 1.0 / (z + 1);
			var szs = s * zs;
			px = Std.int(((p.x - 0.5) * zs + 0.5) * pixelSize.x - szs / 2);
			py = Std.int(((p.y - 0.5) * zs + 0.5) * pixelSize.y - szs / 2);
			ps = Std.int(szs);
		}
		Screen.pixelFillRect(px, py, ps, ps, color.getBlinkColor());
		if (ticks >= removeTicks) get_r();
	}
}