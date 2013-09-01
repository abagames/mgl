package mgl;
using Math;
class A { // Actor
	public var p:V; // position
	public var v:V; // velocity
	public var a = 0.0; // angle
	public var s = 0.0; // speed
	public var t(get, null):Int; // ticks
	public var r(get, null):A; // remove
	public function ih(actors:Array<Dynamic>, isCallHit:Bool = true):Bool {
		return isHit(actors, isCallHit);
	}
	static public function acs(className:String):Array<Dynamic> {
		return getActors(className);
	}
	// Functions should be used in an i (initialize) function
	public function dp(priority:Int):A { return setDisplayPriority(priority); }
	public var er(get, null):A; // enable rolling shape
	public function cs(radius:Float):A { return setCircleShape(radius); }
	public function ch(radius:Float):A { return setCircleHit(radius); }
	public function rs(width:Float, height:Float = -1):A { return setRectShape(width, height); }
	public function rh(width:Float, height:Float = -1):A { return setRectHit(width, height); }
	public function hr(ratio:Float):A { return setHitRatio(ratio); }
	public function gs(color:C, seed:Int = -1):A { return generateShape(color, seed); }

	public function i():Void { } // initialize
	public function b():Void { } // begin
	public function u():Void { } // update
	public function h(hitActor:Dynamic):Void { } // hit
	
	public var m(get, null):A; // move

	static var groups:Map<String, ActorGroup>;
	static var pixelWHRatio = 1.0;
	static var emptyGroup:Array<A>;
	static public function initialize() {
		pixelWHRatio = B.pixelWHRatio;
		groups = new Map<String, ActorGroup>();
		emptyGroup = new Array<A>();
	}
	static public function clear():Void {
		for (g in groups) g.s = new Array<A>();
	}
	static public function update():Void {
		var groupsArray = Lambda.array(groups);
		groupsArray.sort(ActorGroup.compare);
		for (g in groupsArray) {
			var actors = g.s;
			var i = 0;
			while (i < actors.length) {
				if (actors[i].isRemoving) {
					actors.splice(i, 1);
				} else {
					actors[i].updateFrame();
					i++;
				}
			}
		}
	}
	public var isRemoving = false;
	public var ticks = 0;
	var isRectShape = false;
	var circleShape = 0.0;
	var circleHit = 0.0;
	var rectShape:V;
	var rectHit:V;
	var isEnableRollingShape = false;
	var d:D;
	var group:ActorGroup;
	var ho:V;
	var fs:Array<F>;
	public function new() {
		p = new V();
		v = new V();
		rectShape = new V();
		rectHit = new V();
		ho = new V();
		fs = new Array<F>();
		var className = Type.getClassName(Type.getClass(this));
		group = groups.get(className);
		if (group == null) {
			group = new ActorGroup(className);
			groups.set(className, group);
			group.hasHitFunction = Lambda.exists(Type.getInstanceFields(Type.getClass(this)),
				function(f) { return f == "h"; } );
			i();
			group.isRectShape = isRectShape;
			group.circleShape = circleShape;
			group.circleHit = circleHit;
			group.rectShape.v(rectShape);
			group.rectHit.v(rectHit);
			group.isEnableRollingShape = isEnableRollingShape;
			group.d = d;
		} else {
			isRectShape = group.isRectShape;
			circleShape = group.circleShape;
			circleHit = group.circleHit;
			rectShape.v(group.rectShape);
			rectHit.v(group.rectHit);
			isEnableRollingShape = group.isEnableRollingShape;
			d = group.d;
		}
		b();
		group.s.push(this);
	}
	function get_t():Int {
		return ticks;
	}
	function get_m():A {
		p.a(v);
		p.aa(a, s);
		return this;
	}
	function get_r():A {
		isRemoving = true;
		return this;
	}
	function isHit(actors:Array<Dynamic>, isCallHit:Bool):Bool {
		if (actors.length <= 0) return false;
		var hasHitFunction = group.hasHitFunction;
		var hitTest:Dynamic -> Bool;
		var ac = actors[0];
		if (isRectShape || ac.isRectShape) {
			var xyr = (rectHit.x / rectHit.y - 1).abs();
			var acxyr = (ac.rectHit.x / ac.rectHit.y - 1).abs();
			if (xyr > acxyr) {
				hitTest = function(ac:Dynamic):Bool {
					ho.v(p).s(ac.p);
					if (pixelWHRatio < 1) ho.y /= pixelWHRatio;
					else if (pixelWHRatio > 1) ho.x *= pixelWHRatio;
					if (a != 0) ho.r(-a);
					return (ho.x.abs() <= (rectHit.x + ac.rectHit.x) / 2 &&
						ho.y.abs() <= (rectHit.y + ac.rectHit.y) / 2);
				}
			} else {
				hitTest = function(ac:Dynamic):Bool {
					ho.v(p).s(ac.p);
					if (pixelWHRatio < 1) ho.y /= pixelWHRatio;
					else if (pixelWHRatio > 1) ho.x *= pixelWHRatio;
					if (ac.a != 0) ho.r(-ac.a);
					return (ho.x.abs() <= (rectHit.x + ac.rectHit.x) / 2 &&
						ho.y.abs() <= (rectHit.y + ac.rectHit.y) / 2);
				}
			}
		} else {
			hitTest = function(a:Dynamic):Bool {
				return (p.dtd(a.p) <= circleHit + a.circleHit);
			}
		}
		var hf:Bool = false;
		for (a in actors) {
			if (this == a) continue;
			if (hitTest(a)) {
				if (hasHitFunction && isCallHit) h(a);
				hf = true;
			}
		}
		return hf;
	}
	static function getActors(className:String):Array<Dynamic> {
		var g = groups.get(className);
		if (g == null) return emptyGroup;
		return g.s;
	}
	function setDisplayPriority(priority:Int):A {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.displayPriority = priority;
		return this;
	}
	function get_er():A {
		isEnableRollingShape = true;
		return this;
	}
	function setCircleShape(radius:Float):A {
		circleShape = radius;
		setCircleHit(radius);
		return this;
	}
	function setCircleHit(radius:Float):A {
		circleHit = radius;
		rectHit.n(radius * 1.4);
		isRectShape = false;
		return this;
	}
	function setRectShape(width:Float, height:Float):A {
		rectShape.x = width;
		rectShape.y = (height >= 0 ? height : width);
		setRectHit(width, height);
		return this;
	}
	function setRectHit(width:Float, height:Float):A {
		rectHit.x = width;
		rectHit.y = (height >= 0 ? height : width);
		isRectShape = true;
		return this;
	}
	function setHitRatio(ratio:Float):A {
		rectHit.v(rectShape).m(ratio);
		circleHit = circleShape * ratio;
		return this;
	}
	function generateShape(color:C, seed:Int):A {
		d = D.i;
		if (isEnableRollingShape) d.er;
		if (isRectShape) d.gr(rectShape.x, rectShape.y, color, seed);
		else d.gc(circleShape, color, seed);
		return this;
	}
	
	function updateFrame():Void {
		m;
		F.updateAll(fs);
		u();
		if (d != null) d.p(p).r(a).d;
		ticks++;
	}
}
class ActorGroup {
	static public function compare(x:ActorGroup, y:ActorGroup):Int {
		return x.displayPriority - y.displayPriority;
	}
	public var className:String;
	public var s:Array<A>;
	public var displayPriority = 10;
	public var hasHitFunction = false;
	public var isRectShape = false;
	public var circleShape = 0.0;
	public var circleHit = 0.0;
	public var rectShape:V;
	public var rectHit:V;
	public var isEnableRollingShape = false;
	public var d:D;
	public function new(className:String) {
		this.className = className;
		s = new Array<A>();
		rectShape = new V();
		rectHit = new V();
	}
}