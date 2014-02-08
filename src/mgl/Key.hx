package mgl;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import mgl.Key.ButtonState;
#if flash
import flash.events.GameInputEvent;
import flash.ui.GameInput;
import flash.ui.GameInputControl;
import flash.ui.GameInputDevice;
#end
using Math;
class Key {
	static public var pressingKeys(get, null):Array<Bool>;
	static public var s:Array<Bool>; // pressing keys
	static public var isUpPressing(get, null):Bool;
	static public var iu(get, null):Bool; // isUpPressing
	static public var isDownPressing(get, null):Bool;
	static public var id(get, null):Bool; // isDownPressing
	static public var isRightPressing(get, null):Bool;
	static public var ir(get, null):Bool; // isRightPressing
	static public var isLeftPressing(get, null):Bool;
	static public var il(get, null):Bool; // isLeftPressing
	static public var isButtonPressing(get, null):Bool;
	static public var ib(get, null):Bool; // isButtonPressing
	static public var isButton1Pressing(get, null):Bool;
	static public var ib1(get, null):Bool; // isButton1Pressing
	static public var isButton2Pressing(get, null):Bool;
	static public var ib2(get, null):Bool; // isButton2Pressing
	static public var isPressedUp(get, null):Bool;
	static public var ipu(get, null):Bool; // isPressedUp
	static public var isPressedDown(get, null):Bool;
	static public var ipd(get, null):Bool; // isPressedDown
	static public var isPressedRight(get, null):Bool;
	static public var ipr(get, null):Bool; // isPressedRight
	static public var isPressedLeft(get, null):Bool;
	static public var ipl(get, null):Bool; // isPressedLeft
	static public var isPressedButton(get, null):Bool;
	static public var ipb(get, null):Bool; // isPressedButton
	static public var isPressedButton1(get, null):Bool;
	static public var ipb1(get, null):Bool; // iPressedsButton1
	static public var isPressedButton2(get, null):Bool;
	static public var ipb2(get, null):Bool; // isPressedButton2
	static public var stick(get, null):Vector;
	static public var st(get, null):Vector; // stick

	static public function reset():Bool { return get_rs(); }
	static public var rs(get, null):Bool; // reset

	static var uState:ButtonState;
	static var dState:ButtonState;
	static var rState:ButtonState;
	static var lState:ButtonState;
	static var buttonState:ButtonState;
	static var button1State:ButtonState;
	static var button2State:ButtonState;
	static inline var GI_STICK_THRESHOLD = 0.5;
	static var kStick:Vector;
	static var giStick:Vector;
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
		kStick = new Vector();
		giStick = new Vector();
		uState = new ButtonState(get_iu);
		dState = new ButtonState(get_id);
		rState = new ButtonState(get_ir);
		lState = new ButtonState(get_il);
		buttonState = new ButtonState(get_ib);
		button1State = new ButtonState(get_ib1);
		button2State = new ButtonState(get_ib2);
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
	static function get_pressingKeys():Array<Bool> {
		return s;
	}
	static function get_isUpPressing():Bool {
		return get_iu();
	}
	static function get_iu():Bool {
		return s[0x26] || s[0x57] || giStick.y < 0;
	}
	static function get_isDownPressing():Bool {
		return get_id();
	}
	static function get_id():Bool {
		return s[0x28] || s[0x53] || giStick.y > 0;
	}
	static function get_isRightPressing():Bool {
		return get_ir();
	}
	static function get_ir():Bool {
		return s[0x27] || s[0x44] || giStick.x > 0;
	}
	static function get_isLeftPressing():Bool {
		return get_il();
	}
	static function get_il():Bool {
		return s[0x25] || s[0x41] || giStick.x < 0;
	}
	static function get_isButtonPressing():Bool {
		return get_ib();
	}
	static function get_ib():Bool {
		return get_ib1() || get_ib2();
	}
	static function get_isButton1Pressing():Bool {
		return get_ib1();
	}
	static function get_ib1():Bool {
		return s[0x5a] || s[0xbe] || s[0x20] || s[0x0d] || giButton1;
	}
	static function get_isButton2Pressing():Bool {
		return get_ib2();
	}
	static function get_ib2():Bool {
		return s[0x58] || s[0xbf] || giButton2;
	}	
	static function get_isPressedUp():Bool {
		return uState.isPressed;
	}
	static function get_ipu():Bool {
		return uState.isPressed;
	}
	static function get_isPressedDown():Bool {
		return dState.isPressed;
	}
	static function get_ipd():Bool {
		return dState.isPressed;
	}
	static function get_isPressedRight():Bool {
		return rState.isPressed;
	}
	static function get_ipr():Bool {
		return rState.isPressed;
	}
	static function get_isPressedLeft():Bool {
		return lState.isPressed;
	}
	static function get_ipl():Bool {
		return lState.isPressed;
	}
	static function get_isPressedButton():Bool {
		return buttonState.isPressed;
	}
	static function get_ipb():Bool {
		return buttonState.isPressed;
	}
	static function get_isPressedButton1():Bool {
		return button1State.isPressed;
	}
	static function get_ipb1():Bool {
		return button1State.isPressed;
	}
	static function get_isPressedButton2():Bool {
		return button2State.isPressed;
	}
	static function get_ipb2():Bool {
		return button2State.isPressed;
	}
	static function get_stick():Vector {
		return get_st();
	}
	static function get_st():Vector {
		kStick.setNumber(0);
		kStick.add(giStick);
		if (get_iu()) kStick.y -= 1;
		if (get_id()) kStick.y += 1;
		if (get_ir()) kStick.x += 1;
		if (get_il()) kStick.x -= 1;
		if (kStick.l > 0) kStick.divide(kStick.length);
		return kStick;
	}
	static function get_rs():Bool {
		for (i in 0...256) s[i] = false;
		return true;
	}
	
	static public function update():Void {
		#if flash
		giStick.setNumber(0);
		giButton1 = giButton2 = false;
		if (device != null) {
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
			} catch (e:Dynamic) { }
		}
		#end
		uState.update();
		dState.update();
		rState.update();
		lState.update();
		buttonState.update();
		button1State.update();
		button2State.update();
	}
	static public function loadState(d) {
		#if flash
		isUdReverse = d.isUdReverse;
		#end
	}
	static public function saveState(d) {
		#if flash
		d.isUdReverse = isUdReverse;
		#end
	}	

	static function onPressed(e:KeyboardEvent) {
		#if flash
		if (e.keyCode == 82 && !s[82]) {
			isUdReverse = !isUdReverse;
			new Text().setText("REVERSE Y AXIS").setXy(0.2, 0.95).setTicks();
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
class ButtonState {
	public var isPressed = false;
	var isPressing = false;
	var isPressingFunc:Void -> Bool;
	public function new(isPressingFunc:Void -> Bool) {
		this.isPressingFunc = isPressingFunc;
	}
	public function update():Void {
		isPressed = false;
		if (isPressingFunc()) {
			if (!isPressing) {
				isPressed = true;
				isPressing = true;
			}
		} else {
			isPressing = false;
		}
	}
}