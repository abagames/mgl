package mgl;
using Math;
class A { // Actor
	public var i(newInstance, null):A;
	public var p:V; // position
	public var v:V; // velocity
	public var a = 0.0; // angle
	public var s = 0.0; // speed
	public var u(update, null):A;
	public function c(radius:Float):A { return setHitCircle(radius); }
	public function r(width:Float, height:Float = -1):A { return setHitRect(width, height); }
	public function ic(actors:Array<Dynamic>, hitInstance:Dynamic = null):Bool {
		return isHitCircle(actors, hitInstance);
	}
	public function ir(actors:Array<Dynamic>, hitInstance:Dynamic = null):Bool {
		return isHitRect(actors, hitInstance);
	}

	var hitRect:V;
	var hitCircle = 0.0;
	public function new() {
		p = new V();
		v = new V();
		hitRect = new V();
	}
	function newInstance():A {
		return new A();
	}
	function update():A {
		p.a(v);
		p.aa(a, s);
		return this;
	}
	function setHitCircle(radius:Float):A {
		hitCircle = radius;
		return this;
	}
	function setHitRect(width:Float, height:Float):A {
		hitRect.x = width;
		hitRect.y = (height >= 0 ? height : width);
		return this;
	}
	function isHitCircle(actors:Array<Dynamic>, hitInstance:Dynamic):Bool {
		return isHit(actors, hitInstance, function(a:A):Bool {
			return (p.dt(a.p) <= hitCircle + a.hitCircle);
		});
	}
	function isHitRect(actors:Array<Dynamic>, hitInstance:Dynamic):Bool {
		return isHit(actors, hitInstance, function(a:A):Bool {
			return ((p.x - a.p.x).abs() <= (hitRect.x + a.hitRect.x) / 2 &&
				(p.y - a.p.y).abs() <= (hitRect.y + a.hitRect.y) / 2);
		});
	}
	function isHit(actors:Array<Dynamic>, hitInstance:Dynamic, hitTest:A -> Bool):Bool {
		var hf:Bool = false;
		for (a in actors) {
			if (this == a.a) continue;
			if (hitTest(a.a)) {
				if (hitInstance != null) hitInstance.h(a);
				hf = true;
			}
		}
		return hf;
	}
}