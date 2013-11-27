package mgl;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import mgl.K.ButtonState;
class M { // Mouse
	static public var p:V; // position
	static public var ib(get, null):Bool; // isButtonPressing
	static public var ipb(get, null):Bool; // isPressedButton

	static var pixelSize:V;
	static var baseSprite:Sprite;
	static var isPressing = false;
	static var buttonState:ButtonState;
	static public function initialize(s:Sprite) {
		baseSprite = s;
		pixelSize = G.pixelSize;
		p = new V();
		buttonState = new ButtonState(get_ib);
		baseSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		baseSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		baseSprite.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		baseSprite.addEventListener(Event.MOUSE_LEAVE, onReleased);
		baseSprite.addEventListener(TouchEvent.TOUCH_MOVE, onTouched);
		baseSprite.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchStarted);
		baseSprite.addEventListener(TouchEvent.TOUCH_END, onReleased);
		baseSprite.addEventListener(TouchEvent.TOUCH_OUT, onReleased);
	}
	static public function get_ib():Bool {
		return isPressing;
	}
	static public function get_ipb():Bool {
		return buttonState.isPressed;
	}
	static public function update():Void {
		buttonState.update();
	}
	static function onMoved(e:MouseEvent):Void {
		p.x = e.stageX / pixelSize.x;
		p.y = e.stageY / pixelSize.y;
		//e.preventDefault();
	}
	static function onTouched(e:TouchEvent):Void {
		p.x = e.stageX / pixelSize.x;
		p.y = e.stageY / pixelSize.y;
		//e.preventDefault();
	}
	static function onPressed(e:MouseEvent):Void {
		isPressing = true;
		onMoved(e);
		//e.preventDefault();
	}
	static function onTouchStarted(e:TouchEvent):Void {
		isPressing = true;
		onTouched(e);
		//e.preventDefault();
	}
	static function onReleased(e:Event):Void {
		isPressing = false;
		//e.preventDefault();
	}
}