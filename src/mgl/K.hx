package mgl;
import flash.events.KeyboardEvent;
import flash.Lib;
class K { // Key
	public var s:Array<Bool>;
	public var iu(isUpPressed, null):Bool;
	public var id(isDownPressed, null):Bool;
	public var ir(isRightPressed, null):Bool;
	public var il(isLeftPressed, null):Bool;
	public var ib(isButtonPressed, null):Bool;
	public var ib1(isButton1Pressed, null):Bool;
	public var ib2(isButton2Pressed, null):Bool;
	public var st(getStick, null):V;
	public var r(reset, null):K;

	var stick:V;
	public function new() {
		s = new Array<Bool>();
		for (i in 0...256) s.push(false);
		stick = new V();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
	}
	function isUpPressed():Bool {
		return s[0x26] || s[0x57];
	}
	function isDownPressed():Bool {
		return s[0x28] || s[0x53];
	}
	function isRightPressed():Bool {
		return s[0x27] || s[0x44];
	}
	function isLeftPressed():Bool {
		return s[0x25] || s[0x41];
	}
	function isButtonPressed():Bool {
		return isButton1Pressed() || isButton2Pressed();
	}
	function isButton1Pressed():Bool {
		return s[0x5a] || s[0xbe] || s[0x20];
	}
	function isButton2Pressed():Bool {
		return s[0x58] || s[0xbf];
	}	
	function getStick():V {
		stick.n(0);
		if (isUpPressed()) stick.y -= 1;
		if (isDownPressed()) stick.y += 1;
		if (isRightPressed()) stick.x += 1;
		if (isLeftPressed()) stick.x -= 1;
		if (stick.x != 0 && stick.y != 0) stick.m(0.7);
		return stick;
	}
	function reset():K {
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