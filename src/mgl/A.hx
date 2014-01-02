package mgl;
using Math;
class A { // Actor
	static public function acs(className:String):Array<Dynamic> {
		return getActors(className);
	}
	static public var cl(get, null):Bool; // clear
	static public function cls(className:String):Void { clearSpecificActors(className); }
	static public function sc(className:String, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		scroll(className, vx, vy, minX, maxX, minY, maxY);
	}
	static public function scs(classNames:Array<String>, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		scrollActors(classNames, vx, vy, minX, maxX, minY, maxY);
	}
	public var p:V; // position
	public var z = 0.0;
	public var v:V; // velocity
	public var w = 0.0; // way
	public var s = 0.0; // speed
	public var t(get, null):Int; // ticks
	public var r(get, null):Bool; // remove
	public function hr(width:Float = -999, height:Float = -1):A { return setHitRect(width, height); }
	public function ih(actorClassName:String, onHit:Dynamic -> Void = null):Bool {
		return isHit(actorClassName, onHit);
	}
	// Functions should be used in an i (initialize) function
	public function dp(priority:Int):A { return setDisplayPriority(priority); }

	public function i():Void { } // initialize
	public function b():Void { } // begin
	public function u():Void { } // update
	
	public var m(get, null):A; // move

	static var groups:Map<String, ActorGroup>;
	static var emptyGroup:Array<A>;
	static public function initialize() {
		groups = new Map<String, ActorGroup>();
		emptyGroup = new Array<A>();
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
	static function getActors(className:String):Array<Dynamic> {
		var g = groups.get(className);
		if (g == null) return emptyGroup;
		return g.s;
	}
	static function get_cl():Bool {
		for (g in groups) g.s = new Array<A>();
		return true;
	}
	static function clearSpecificActors(className:String):Void {
		var g = groups.get(className);
		if (g == null) return;
		g.s = new Array<A>();
	}
	static function scroll(className:String, vx:Float, vy:Float,
	minX:Float, maxX:Float, minY:Float, maxY:Float):Void {
		var actors = getActors(className);
		for (a in actors) {
			a.p.x += vx;
			a.p.y += vy;
			if (minX < maxX) a.p.x = U.lr(a.p.x, minX, maxX);
			if (minY < maxY) a.p.y = U.lr(a.p.y, minY, maxY);
		}
	}
	static function scrollActors(classNames:Array<String>, vx:Float, vy:Float,
	minX:Float, maxX:Float, minY:Float, maxY:Float):Void {
		for (cn in classNames) scroll(cn, vx, vy, minX, maxX, minY, maxY);
	}
	public var isRemoving = false;
	public var ticks = 0;
	public var hitRect:V;
	var d:D; // dot pixel art
	var group:ActorGroup;
	var ho:V;
	var fs:Array<F>;
	public function new() {
		p = new V();
		v = new V();
		hitRect = new V().xy(-999, -999);
		ho = new V();
		fs = new Array<F>();
		var className = Type.getClassName(Type.getClass(this));
		group = groups.get(className);
		if (group == null) {
			group = new ActorGroup(className);
			groups.set(className, group);
			i();
			group.hitRect.v(hitRect);
			group.d = d;
		} else {
			hitRect.v(group.hitRect);
			d = group.d;
		}
		b();
		group.s.push(this);
	}
	function get_t():Int {
		return ticks;
	}
	function setHitRect(width:Float, height:Float):A {
		hitRect.x = width;
		hitRect.y = (height >= 0 ? height : width);
		return this;
	}
	function get_r():Bool {
		if (isRemoving) return false;
		isRemoving = true;
		return true;
	}
	function isHit(actorClassName:String, onHit:Dynamic -> Void):Bool {
		var pixelWHRatio = G.pixelWHRatio;
		var actors = A.acs(actorClassName);
		if (actors.length <= 0) return false;
		var hitTest:Dynamic -> Bool;
		var ac = actors[0];
		var xyr = (hitRect.x / hitRect.y - 1).abs();
		var ahx:Float = ac.hitRect.x;
		var ahy:Float = ac.hitRect.y;
		var acxyr = (ahx / ahy - 1).abs();
		if (xyr > acxyr) {
			hitTest = function(ac:Dynamic):Bool {
				ho.v(p).s(ac.p);
				if (w != 0) ho.rt(-w);
				return (ho.x.abs() <= (hitRect.x + ac.hitRect.x) / 2 &&
					ho.y.abs() <= (hitRect.y + ac.hitRect.y) / 2);
			}
		} else {
			hitTest = function(ac:Dynamic):Bool {
				ho.v(p).s(ac.p);
				if (ac.w != 0) ho.rt(-ac.w);
				return (ho.x.abs() <= (hitRect.x + ac.hitRect.x) / 2 &&
					ho.y.abs() <= (hitRect.y + ac.hitRect.y) / 2);
			}
		}
		var hf = false;
		for (a in actors) {
			if (this == a || a.isRemoving) continue;
			if (hitTest(a)) {
				if (onHit != null) onHit(a);
				hf = true;
			}
		}
		return hf;
	}
	function setDisplayPriority(priority:Int):A {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.displayPriority = priority;
		return this;
	}
	function get_m():A {
		p.a(v);
		p.aw(w, s);
		return this;
	}

	function updateFrame():Void {
		m;
		F.updateAll(fs);
		u();
		if (d != null) d.p(p).z(z).rt(w).d;
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
	public var hitRect:V;
	public var d:D;
	public function new(className:String) {
		this.className = className;
		s = new Array<A>();
		hitRect = new V();
	}
}