package mgl;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
class M { // Mouse
	public var p:V; // pos
	public var ip = false; // isPressing

	public function new(baseSprite:Sprite):Void {
		p = new V();
		baseSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		baseSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		baseSprite.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		baseSprite.addEventListener(Event.MOUSE_LEAVE, onReleased);
	}
	function onMoved(e:MouseEvent):Void {
		p.x = e.stageX;
		p.y = e.stageY;
	}
	function onPressed(e:MouseEvent):Void {
		ip = true;
		onMoved(e);
	}
	function onReleased(e:Event):Void {
		ip = false;
	}
}