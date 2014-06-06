package mgl;
using Math;
using mgl.Util;
class Actor {
	static public function acs(className:String):Array<Dynamic> {
		return getActors(className);
	}
	static public function clear():Bool { return get_cl(); }
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
	static public function ap(isAffected:Bool = true):Void {
		return setAffectedByPixelWHRatio(isAffected);
	}
	public var position(get, set):Vector;
	public var p:Vector; // position
	public var z = 0.0;
	public var velocity(get, set):Vector;
	public var v:Vector; // velocity
	public var way(get, set):Float;
	public var w = 0.0; // way
	public var speed(get, set):Float;
	public var s = 0.0; // speed
	public var scaleX(get, set):Float;
	public var sx = 1.0; // scaleX
	public var scaleY(get, set):Float;
	public var sy = 1.0; // scaleY
	public var dotPixelArt(get, set):DotPixelArt;
	public var d:DotPixelArt; // dot pixel art
	public var ticks(get, null):Int;
	public var t(get, null):Int; // ticks
	public function remove():Bool { return get_r(); }
	public var r(get, null):Bool; // remove
	public function hr(width:Float = -999, height:Float = -1):Actor { return setHitRect(width, height); }
	public function hc(diameter:Float = -999):Actor { return setHitCircle(diameter); }
	public function ih(actorClassName:String, onHit:Dynamic -> Void = null):Bool {
		return isHit(actorClassName, onHit);
	}
	// Functions should be used in an initialize function
	public function dp(priority:Int):Actor { return setDisplayPriority(priority); }
	public function drawToBackground():Actor { return get_db(); }
	public var db(get, null):Actor; // draw to background
	public function drawToForeground():Actor { return get_df(); }
	public var df(get, null):Actor; // draw to foreground
	public function sortByZ():Actor { return get_sz(); }
	public var sz(get, null):Actor; // sort by Z

	public function initialize():Void { }
	public function begin():Void { }
	public function update():Void { }
	
	public function move():Actor { return get_m(); }
	public var m(get, null):Actor;

	static var groups:Map<String, ActorGroup>;
	static var emptyGroup:Array<Actor>;
	static var isAffectedByPixelWHRatio = false;
	static public function initializeAll() {
		groups = new Map<String, ActorGroup>();
		emptyGroup = new Array<Actor>();
		isAffectedByPixelWHRatio = (Game.pixelWHRatio != 1);
	}
	static public function updateAll():Void {
		var groupsArray = Lambda.array(groups);
		groupsArray.sort(ActorGroup.compare);
		for (g in groupsArray) {
			if (g.isDrawingToBack) Game.drawToBackground();
			else Game.drawToForeground();
			var actors = g.s;
			if (g.isSortingByZ) actors.sort(compareByZ);
			var i = 0;
			while (i < actors.length) {
				if (actors[i].isRemoving) {
					actors.splice(i, 1);
				} else {
					actors[i].updateFrame();
					i++;
				}
			}
			Game.drawToForeground();
		}
	}
	static public function getActors(className:String):Array<Dynamic> {
		var g = groups.get(className);
		if (g == null) return emptyGroup;
		var actors = new Array<Dynamic>();
		for (a in g.s) {
			if (!a.isRemoving) actors.push(a);
		}
		return actors;
	}
	static function get_cl():Bool {
		for (g in groups) g.s = new Array<Actor>();
		return true;
	}
	static public function clearSpecificActors(className:String):Void {
		var g = groups.get(className);
		if (g == null) return;
		g.s = new Array<Actor>();
	}
	static public function scroll(className:String, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		var actors = getActors(className);
		for (a in actors) {
			a.p.x += vx;
			a.p.y += vy;
			if (minX < maxX) a.p.x = Util.loopRange(a.p.x, minX, maxX);
			if (minY < maxY) a.p.y = Util.loopRange(a.p.y, minY, maxY);
		}
	}
	static public function scrollActors(classNames:Array<String>, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0):Void {
		for (cn in classNames) scroll(cn, vx, vy, minX, maxX, minY, maxY);
	}
	static public function setAffectedByPixelWHRatio(isAffected:Bool = false):Void {
		isAffectedByPixelWHRatio = isAffected;
	}
	static public function compareByZ(x:Actor, y:Actor):Int {
		if (x.z > y.z) return -1;
		if (x.z < y.z) return 1;
		return 0;
	}
	public var isRemoving = false;
	public var currentTicks = 0;
	public var hitRect:Vector;
	public var hitDiameter = -999.0;
	var group:ActorGroup;
	var ho:Vector;
	var av:Vector;
	var fs:Array<Fiber>;
	public function new() {
		p = new Vector();
		v = new Vector();
		hitRect = new Vector().setXy(-999, -999);
		ho = new Vector();
		av = new Vector();
		fs = new Array<Fiber>();
		var className = Type.getClassName(Type.getClass(this));
		group = groups.get(className);
		if (group == null) {
			group = new ActorGroup(className);
			groups.set(className, group);
			initialize();
			group.hitRect.setValue(hitRect);
			group.hitDiameter = hitDiameter;
			group.d = d;
		} else {
			hitRect.setValue(group.hitRect);
			hitDiameter = group.hitDiameter;
			d = group.d;
		}
		begin();
		group.s.push(this);
	}
	function get_position():Vector {
		return p;
	}
	function set_position(v:Vector):Vector {
		p = v;
		return p;
	}
	function get_velocity():Vector {
		return v;
	}
	function set_velocity(v:Vector):Vector {
		this.v = v;
		return this.v;
	}
	function get_way():Float {
		return w;
	}
	function set_way(v:Float):Float {
		w = v;
		return w;
	}
	function get_speed():Float {
		return s;
	}
	function set_speed(v:Float):Float {
		s = v;
		return s;
	}
	function get_scaleX():Float {
		return sx;
	}
	function set_scaleX(v:Float):Float {
		sx = v;
		return sx;
	}
	function get_scaleY():Float {
		return sy;
	}
	function set_scaleY(v:Float):Float {
		sy = v;
		return sy;
	}
	function get_dotPixelArt():DotPixelArt {
		return d;
	}
	function set_dotPixelArt(v:DotPixelArt):DotPixelArt {
		d = v;
		return d;
	}
	function get_ticks():Int {
		return currentTicks;
	}
	function get_t():Int {
		return currentTicks;
	}
	function get_r():Bool {
		if (isRemoving) return false;
		isRemoving = true;
		return true;
	}
	public function setHitRect(width:Float = -999, height:Float = -1):Actor {
		hitRect.x = width;
		hitRect.y = (height >= 0 ? height : width);
		return this;
	}
	public function setHitCircle(diameter:Float = -999):Actor {
		hitDiameter = diameter;
		setHitRect(diameter, diameter);
		return this;
	}
	public function isHit(actorClassName:String, onHit:Dynamic -> Void = null):Bool {
		var actors = Actor.getActors(actorClassName);
		if (actors.length <= 0) return false;
		var hitTest:Dynamic -> Bool;
		var ac = actors[0];
		if (hitDiameter > 0 && ac.hitDiameter > 0) {
			hitTest = function (ac:Dynamic):Bool {
				return p.distanceToDistorted(ac.p) <= (hitDiameter + ac.hitDiameter) / 2;
			}
		} else {
			var xyr = (hitRect.x / hitRect.y - 1).abs();
			var ahx:Float = ac.hitRect.x;
			var ahy:Float = ac.hitRect.y;
			var acxyr = (ahx / ahy - 1).abs();
			if (xyr > acxyr) {
				hitTest = function(ac:Dynamic):Bool {
					ho.setValue(p).sub(ac.p);
					if (w != 0) ho.rotate(-w);
					return (ho.x.abs() <= (hitRect.x + ac.hitRect.x) / 2 &&
						ho.y.abs() <= (hitRect.y + ac.hitRect.y) / 2);
				}
			} else {
				hitTest = function(ac:Dynamic):Bool {
					ho.setValue(p).sub(ac.p);
					if (ac.w != 0) ho.rotate(-ac.w);
					return (ho.x.abs() <= (hitRect.x + ac.hitRect.x) / 2 &&
						ho.y.abs() <= (hitRect.y + ac.hitRect.y) / 2);
				}
			}
		}
		var hf = false;
		for (ac in actors) {
			var a:Actor = ac;
			if (this == a || a.isRemoving) continue;
			var sz = (hitRect.x + hitRect.y + a.hitRect.x + a.hitRect.y) / 2;
			if ((p.x - a.p.x) > sz && (p.y - a.p.y) > sz) continue;
			if (hitTest(a)) {
				if (onHit != null) onHit(a);
				hf = true;
			}
		}
		return hf;
	}
	function setDisplayPriority(priority:Int):Actor {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.displayPriority = priority;
		return this;
	}
	function get_db():Actor {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.isDrawingToBack = true;
		return this;
	}
	function get_df():Actor {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.isDrawingToBack = false;
		return this;
	}
	function get_sz():Actor {
		var group = groups.get(Type.getClassName(Type.getClass(this)));
		group.isSortingByZ = true;
		return this;
	}
	function get_m():Actor {
		if (isAffectedByPixelWHRatio) {
			av.n().add(v).addWay(w, s);
			av.y *= Game.pixelWHRatio;
			p.add(av);
		} else {
			p.add(v);
			p.addWay(w, s);
		}
		return this;
	}

	function updateFrame():Void {
		move();
		Fiber.updateAll(fs);
		update();
		if (d != null) d.setPosition(p).setZ(z).setScale(sx, sy).rotate(w).draw();
		currentTicks++;
	}
}
class ActorGroup {
	static public function compare(x:ActorGroup, y:ActorGroup):Int {
		return x.displayPriority - y.displayPriority;
	}
	public var className:String;
	public var s:Array<Actor>;
	public var displayPriority = 10;
	public var isDrawingToBack = false;
	public var isSortingByZ = false;
	public var hitRect:Vector;
	public var hitDiameter = -999.0;
	public var d:DotPixelArt;
	public function new(className:String) {
		this.className = className;
		s = new Array<Actor>();
		hitRect = new Vector();
	}
}