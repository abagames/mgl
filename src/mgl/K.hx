package mgl;
import flash.events.KeyboardEvent;
import flash.Lib;
class K { // Key
	public var s:Array<Bool>;
	public var iu(get, null):Bool; // isUpPressed
	public var id(get, null):Bool; // isDownPressed
	public var ir(get, null):Bool; // isRightPressed
	public var il(get, null):Bool; // isLeftPressed
	public var ib(get, null):Bool; // isButtonPressed
	public var ib1(get, null):Bool; // isButton1Pressed
	public var ib2(get, null):Bool; // isButton2Pressed
	public var st(get, null):V; // stick
	public var r(get, null):K; // reset

	var stick:V;
	public function new() {
		s = new Array<Bool>();
		for (i in 0...256) s.push(false);
		stick = new V();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
	}
	function get_iu():Bool {
		return s[0x26] || s[0x57];
	}
	function get_id():Bool {
		return s[0x28] || s[0x53];
	}
	function get_ir():Bool {
		return s[0x27] || s[0x44];
	}
	function get_il():Bool {
		return s[0x25] || s[0x41];
	}
	function get_ib():Bool {
		return get_ib1() || get_ib2();
	}
	function get_ib1():Bool {
		return s[0x5a] || s[0xbe] || s[0x20];
	}
	function get_ib2():Bool {
		return s[0x58] || s[0xbf];
	}	
	function get_st():V {
		stick.n(0);
		if (get_iu()) stick.y -= 1;
		if (get_id()) stick.y += 1;
		if (get_ir()) stick.x += 1;
		if (get_il()) stick.x -= 1;
		if (stick.x != 0 && stick.y != 0) stick.m(0.7);
		return stick;
	}
	function get_r():K {
		for (i in 0...256) s[i] = false;
		return this;
	}

	function onPressed(e:KeyboardEvent) {
		s[e.keyCode] = true;
	}
	function onReleased(e:KeyboardEvent) {
		s[e.keyCode] = false;
	}
}