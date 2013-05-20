package mgl;
import flash.display.BitmapData;
import flash.geom.Rectangle;
class P { // Particle
	public var i(newInstance, null):P;
	public function p(pos:V):P { return setPos(pos); }
	public function c(color:C):P { return setColor(color); }
	public function cn(count:Int):P { return setCount(count); }
	public function sz(size:Float):P { return setSize(size); }
	public function s(speed:Float):P { return setSpeed(speed); }
	public function t(ticks:Float):P { return setTicks(ticks); }
	public function an(angle:Float, angleWidth:Float):P { return setAngle(angle, angleWidth); }
	public var a(add, null):P;

	public static var ps:Array<P>;
	static var bd:BitmapData;
	static var screenSize:V;
	static var random:R;
	static var rect:Rectangle;
	static var colorInstance:C;
	static var screenWidth:Float;
	static var screenHeight:Float;
	public static function initialize(game:G):Void {
		bd = game.bd;
		screenSize = game.screenSize;
		ps = new Array<P>();
		random = new R();
		rect = new Rectangle();
		colorInstance = new C();
	}
	var actor:A;
	var ticks = 60;
	var color:C;
	var size = 0.01;
	var targetSize:Float;
	var isExpand = true;
	var aPos:V;
	var aColor:C;
	var aCount = 1;
	var aSize = 0.02;
	var aSpeed = 0.02;
	var aTicks = 60;
	var aAngle = 0.0;
	var aAngleWidth = 6.28;
	public function new() {
		actor = new A();
		aPos = new V();
		aColor = colorInstance.wi;
	}
	function newInstance():P {
		return new P();
	}
	function setPos(pos:V):P {
		aPos.v(pos);
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
	function add():P {
		for (i in 0...aCount) {
			var p = new P();
			p.color = aColor;
			p.targetSize = aSize;
			p.actor.p.v(aPos);
			p.actor.v.aa(aAngle + random.pn(aAngleWidth / 2), random.n(aSpeed));
			p.ticks = Std.int(aTicks * random.n(1, 0.5));
			ps.push(p);
		}
		return this;
	}

	public function u():Bool {
		actor.p.a(actor.v);
		actor.v.m(0.98);
		if (isExpand) {
			size *= 1.5;
			if (size > targetSize) isExpand = false;
		} else {
			size *= 0.95;
		}
		var s = size * screenSize.x;
		rect.x = Std.int(actor.p.x * screenSize.x) - Std.int(s / 2);
		rect.y = Std.int(actor.p.y * screenSize.y) - Std.int(s / 2);
		rect.width = rect.height = Std.int(s);
		bd.fillRect(rect, color.gbl.i);
		return --ticks > 0;
	}
}