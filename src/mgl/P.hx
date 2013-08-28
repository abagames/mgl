package mgl;
class P { // Particle
	static public var i(get, null):P; // instance
	public function p(pos:V):P { return setPos(pos); }
	public function xy(x:Float, y:Float):P { return setXy(x, y); }
	public function c(color:C):P { return setColor(color); }
	public function cn(count:Int):P { return setCount(count); }
	public function sz(size:Float):P { return setSize(size); }
	public function s(speed:Float):P { return setSpeed(speed); }
	public function t(ticks:Float):P { return setTicks(ticks); }
	public function an(angle:Float, angleWidth:Float):P { return setAngle(angle, angleWidth); }
	public var a(get, null):P; // add

	static var random:R;
	public static function initialize():Void {
		random = new R();
	}
	public var actor:PActor;
	var aPos:V;
	var aColor:C;
	var aCount = 1;
	var aSize = 0.02;
	var aSpeed = 0.02;
	var aTicks = 60;
	var aAngle = 0.0;
	var aAngleWidth = 360.0;
	public function new(createActor:Bool = false) {
		if (createActor) actor = new PActor();
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
	function setAngle(angle:Float, angleWidth:Float):P {
		aAngle = angle;
		aAngleWidth = angleWidth;
		return this;
	}
	function get_a():P {
		for (i in 0...aCount) {
			var p = new P(true);
			p.actor.color = aColor;
			p.actor.targetSize = aSize;
			p.actor.p.v(aPos);
			p.actor.v.aa(aAngle + random.p(aAngleWidth / 2), random.n(aSpeed));
			p.actor.removeTicks = Std.int(aTicks * random.f(0.5, 1.5));
		}
		return this;
	}
}
class PActor extends A {
	static var pixelSize:V;
	override public function i() {
		pixelSize = B.pixelSize;
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
		var s = size * pixelSize.x;
		var px = Std.int(p.x * pixelSize.x) - Std.int(s / 2);
		var py = Std.int(p.y * pixelSize.y) - Std.int(s / 2);
		var ps = Std.int(s);
		B.pixelFillRect(px, py, ps, ps, color.getBlinkColor());
		if (ticks > removeTicks) r;
	}
}