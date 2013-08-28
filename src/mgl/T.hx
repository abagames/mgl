package mgl;
class T { // Text
	static public var i(get, null):T; // instance
	public function p(pos:V):T { return setPos(pos); }
	public function xy(x:Float, y:Float):T { return setXy(x, y); }
	public function tx(text:String):T { return setText(text); }
	public function v(vel:V):T { return setVel(vel); }
	public function vxy(x:Float, y:Float):T { return setVelXy(x, y); }
	public function t(ticks:Int):T { return setTicks(ticks); }
	public var ao(get, null):T; // add once
	
	static var shownMessages:Array<String>;
	public static function initialize():Void {
		shownMessages = new Array<String>();
	}
	var actor:TActor;
	var text:String;
	var isFirstTicks = true;
	public function new() {
		actor = new TActor();
		actor.letter = L.i.avc;
	}
	static function get_i():T {
		return new T();
	}
	function setPos(pos:V):T {
		actor.p.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):T {
		actor.p.xy(x, y);
		return this;
	}
	function setText(text:String):T {
		this.text = text;
		actor.letter.tx(text);
		return this;
	}
	function setVel(vel:V):T {
		actor.v.v(vel);
		return this;
	}
	function setVelXy(x:Float, y:Float):T {
		actor.v.xy(x, y);
		return this;
	}
	function setTicks(ticks:Int):T {
		actor.removeTicks = ticks;
		return this;
	}
	function get_ao():T {
		for (m in shownMessages) {
			if (m == text) {
				actor.r;
				return null;
			}
		}
		shownMessages.push(text);
		return this;
	}
}
class TActor extends A {
	override public function i() {
		dp(100);
	}
	public var removeTicks = 60;
	public var letter:L;
	var isFirstTicks = true;
	override public function u() {
		if (isFirstTicks) {
			v.d(removeTicks);
			isFirstTicks = false;
		}
		letter.p(p.a(v)).d;
		if (ticks >= removeTicks) r;
	}
}