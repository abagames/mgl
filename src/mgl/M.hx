package mgl;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
class M { // Mouse
	static public var p:V; // pos
	static public var ip = false; // isPressing

	static var pixelSize:V;
	static var baseSprite:Sprite;
	static public function initialize(s:Sprite) {
		baseSprite = s;
		pixelSize = V.i.v(B.pixelSize);
		p = new V();
		baseSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		baseSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		baseSprite.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		baseSprite.addEventListener(Event.MOUSE_LEAVE, onReleased);
		baseSprite.addEventListener(TouchEvent.TOUCH_MOVE, onTouched);
		baseSprite.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchStarted);
		baseSprite.addEventListener(TouchEvent.TOUCH_END, onReleased);
		baseSprite.addEventListener(TouchEvent.TOUCH_OUT, onReleased);
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
		ip = true;
		onMoved(e);
		//e.preventDefault();
	}
	static function onTouchStarted(e:TouchEvent):Void {
		ip = true;
		onTouched(e);
		//e.preventDefault();
	}
	static function onReleased(e:Event):Void {
		ip = false;
		//e.preventDefault();
	}
}