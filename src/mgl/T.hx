package mgl;
class T { // Text
	public var i(newInstance, null):T;
	public function p(pos:V):T { return setPos(pos); }
	public function xy(x:Float, y:Float):T { return setXy(x, y); }
	public function t(text:String):T { return setText(text); }
	public function v(vel:V):T { return setVel(vel); }
	public function tc(ticks:Int):T { return setTicks(ticks); }
	public var a(add, null):T;
	public var ao(addOnce, null):T;
	
	public static var s:Array<T>;
	static var shownMessages:Array<String>;
	public static function initialize():Void {
		s = new Array<T>();
		if (shownMessages == null) shownMessages = new Array<String>();
	}
	var letter:L;
	var actor:A;
	var text:String;
	var ticks = 60;
	var isFirstTicks = true;
	public function new() {
		letter = new L();
		actor = new A();
	}
	function newInstance():T {
		return new T();
	}
	function setPos(pos:V):T {
		actor.p.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):T {
		actor.p.x = x;
		actor.p.y = y;
		return this;
	}
	function setText(text:String):T {
		this.text = text;
		letter.t(text);
		return this;
	}
	function setVel(vel:V):T {
		actor.v.x = vel.x;
		actor.v.y = vel.y;
		return this;
	}
	function setTicks(ticks:Int):T {
		this.ticks = ticks;
		return this;
	}
	function add():T {
		s.push(this);
		return this;
	}
	function addOnce():T {
		for (m in shownMessages) if (m == text) return null;
		shownMessages.push(text);
		return add();
	}

	public function u():Bool {
		if (isFirstTicks) {
			actor.v.d(ticks);
			isFirstTicks = false;
		}
		letter.p(actor.p.a(actor.v)).d;
		return --ticks > 0;
	}
}