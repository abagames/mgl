package mgl;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
#if flash
import flash.events.GameInputEvent;
import flash.ui.GameInput;
import flash.ui.GameInputControl;
import flash.ui.GameInputDevice;
#end
using Math;
class K { // Key
	static public var s:Array<Bool>;
	static public var iu(get, null):Bool; // isUpPressed
	static public var id(get, null):Bool; // isDownPressed
	static public var ir(get, null):Bool; // isRightPressed
	static public var il(get, null):Bool; // isLeftPressed
	static public var ib(get, null):Bool; // isButtonPressed
	static public var ib1(get, null):Bool; // isButton1Pressed
	static public var ib2(get, null):Bool; // isButton2Pressed
	static public var st(get, null):V; // stick
	static public var r(get, null):Bool; // reset

	static inline var GI_STICK_THRESHOLD = .5;
	static var stick:V;
	static var giStick:V;
	static var giButton1 = false;
	static var giButton2 = false;
	#if flash
	static var input:GameInput;
	static var device:GameInputDevice;
	static var isUdReverse = false;
	static var isRPressed = false;
	#end
	static public function initialize() {
		s = new Array<Bool>();
		for (i in 0...256) s.push(false);
		stick = new V();
		giStick = new V();
		#if flash
		if (GameInput.isSupported) {
			input = new GameInput();
			input.addEventListener(GameInputEvent.DEVICE_ADDED, function (e) {
				if (GameInput.numDevices > 0) {
					device = GameInput.getDeviceAt(0);
					device.enabled = true;
				}
			});
			input.addEventListener(GameInputEvent.DEVICE_REMOVED, function (e) { device = null; } );
		}
		#end
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);	
	}
	static function get_iu():Bool {
		return s[0x26] || s[0x57] || giStick.y < 0;
	}
	static function get_id():Bool {
		return s[0x28] || s[0x53] || giStick.y > 0;
	}
	static function get_ir():Bool {
		return s[0x27] || s[0x44] || giStick.x > 0;
	}
	static function get_il():Bool {
		return s[0x25] || s[0x41] || giStick.x < 0;
	}
	static function get_ib():Bool {
		return get_ib1() || get_ib2();
	}
	static function get_ib1():Bool {
		return s[0x5a] || s[0xbe] || s[0x20] || s[0x0d] || giButton1;
	}
	static function get_ib2():Bool {
		return s[0x58] || s[0xbf] || giButton2;
	}	
	static function get_st():V {
		stick.n(0);
		stick.a(giStick);
		if (get_iu()) stick.y -= 1;
		if (get_id()) stick.y += 1;
		if (get_ir()) stick.x += 1;
		if (get_il()) stick.x -= 1;
		if (stick.l > 0) stick.d(stick.l);
		return stick;
	}
	static function get_r():Bool {
		for (i in 0...256) s[i] = false;
		return true;
	}
	
	static public function u():Void {
		#if flash
		giStick.n(0);
		giButton1 = giButton2 = false;
		if (device == null) return;
		try {
			var c0:GameInputControl = device.getControlAt(0);
			var c1:GameInputControl = device.getControlAt(1);
			var c2:GameInputControl = device.getControlAt(2);
			var c3:GameInputControl = device.getControlAt(3);
			if (c0.value.abs() > GI_STICK_THRESHOLD) giStick.x += c0.value;
			if (c1.value.abs() > GI_STICK_THRESHOLD) giStick.y -= c1.value;
			if (c2.value.abs() > GI_STICK_THRESHOLD) giStick.x += c2.value;
			if (c3.value.abs() > GI_STICK_THRESHOLD) giStick.y -= c3.value;
			if (isUdReverse) giStick.y *= -1;
			var c4:GameInputControl = device.getControlAt(4);
			var c5:GameInputControl = device.getControlAt(5);
			var c6:GameInputControl = device.getControlAt(6);
			var c7:GameInputControl = device.getControlAt(7);
			giButton1 = (c4.value > GI_STICK_THRESHOLD) || (c6.value > GI_STICK_THRESHOLD);
			giButton2 = (c5.value > GI_STICK_THRESHOLD) || (c7.value > GI_STICK_THRESHOLD);
		} catch (e:Dynamic) {}
		#end
	}
	static public function ls(d) {
		#if flash
		isUdReverse = d.isUdReverse;
		#end
	}
	static public function ss(d) {
		#if flash
		d.isUdReverse = isUdReverse;
		#end
	}	

	static function onPressed(e:KeyboardEvent) {
		#if flash
		if (e.keyCode == 82 && !s[82]) {
			isUdReverse = !isUdReverse;
			T.i.tx("REVERSE Y AXIS").xy(.2, .95);
			isRPressed = true;
		}
		#end
		s[e.keyCode] = true;
		//if (e.keyCode >= 37 && e.keyCode <= 40) e.preventDefault();
	}
	static function onReleased(e:KeyboardEvent) {
		s[e.keyCode] = false;
	}
}