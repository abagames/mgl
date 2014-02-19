package mgl;
import mgl.Game.Screen;
class Particle {
	static public var i(get, null):Particle; // instance
	static public function scroll(vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		Actor.sc("mgl.PActor", vx, vy, minX, maxX, minY, maxY);
	}
	static public function sc(vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		Actor.sc("mgl.PActor", vx, vy, minX, maxX, minY, maxY);
	}
	public function p(pos:Vector):Particle { return setPosition(pos); }
	public function xy(x:Float, y:Float):Particle { return setXy(x, y); }
	public function z(z:Float = 0):Particle { return setZ(z); }
	public function c(color:Color):Particle { return setColor(color); }
	public function cn(count:Int):Particle { return setCount(count); }
	public function sz(size:Float):Particle { return setSize(size); }
	public function s(speed:Float):Particle { return setSpeed(speed); }
	public function t(ticks:Float):Particle { return setTicks(ticks); }
	public function w(angle:Float, angleWidth:Float = 0):Particle { return setWay(angle, angleWidth); }
	public function add():Particle { return get_a(); }
	public var a(get, null):Particle; // add

	static var random:Random;
	static public function initialize():Void {
		random = new Random();
	}
	var aPos:Vector;
	var aZ = 0.0;
	var aColor:Color;
	var aCount = 1;
	var aSize = 0.02;
	var aSpeed = 0.02;
	var aTicks = 60;
	var aAngle = 0.0;
	var aAngleWidth = 360.0;
	public function new() {
		aPos = new Vector();
		aColor = Color.wi;
	}
	static function get_i():Particle {
		return new Particle();
	}
	public function setPosition(pos:Vector):Particle {
		aPos.setValue(pos);
		return this;
	}
	public function setXy(x:Float, y:Float):Particle {
		aPos.setXy(x, y);
		return this;
	}
	public function setZ(z:Float = 0):Particle {
		aZ = z;
		return this;
	}
	public function setColor(color:Color):Particle {
		aColor = color;
		return this;
	}
	public function setCount(count:Int):Particle {
		aCount = count;
		return this;
	}
	public function setSize(size:Float):Particle {
		aSize = size;
		return this;
	}
	public function setSpeed(speed:Float):Particle {
		aSpeed = speed;
		return this;
	}
	public function setTicks(ticks:Float):Particle {
		aTicks = Std.int(ticks);
		return this;
	}
	public function setWay(angle:Float, angleWidth:Float):Particle {
		aAngle = angle;
		aAngleWidth = angleWidth;
		return this;
	}
	function get_a():Particle {
		for (i in 0...aCount) {
			var pa = new PActor();
			pa.color = aColor;
			pa.targetSize = aSize;
			pa.p.setValue(aPos);
			pa.z = aZ;
			pa.v.addWay(aAngle + random.p(aAngleWidth / 2), random.n(aSpeed));
			pa.removeTicks = Std.int(aTicks * random.f(0.5, 1.5));
		}
		return this;
	}
}
class PActor extends Actor {
	static var pixelSize:Vector;
	static var pixelSizeL:Float;
	override public function initialize() {
		pixelSize = Game.pixelSize;
		pixelSizeL = Game.pixelWHRatio < 1 ? pixelSize.x : pixelSize.y;
		dp(0);
	}
	public var removeTicks = 60;
	public var color:Color;
	public var targetSize:Float;
	var size = 0.01;
	var isExpand = true;
	override public function update() {
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
		if (ticks >= removeTicks) remove();
	}
}