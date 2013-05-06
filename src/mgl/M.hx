package mgl;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
class M { // Mouse
	public var p:V; // pos
	public var ip = false; // isPressing

	static var screenSize:V;
	static var baseSprite:Sprite;
	public static function initialize(game:G) {
		screenSize = game.screenSize;
		baseSprite = game.baseSprite;
	}
	public function new():Void {
		p = new V();
		baseSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		baseSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		baseSprite.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		baseSprite.addEventListener(Event.MOUSE_LEAVE, onReleased);
	}
	function onMoved(e:MouseEvent):Void {
		p.x = e.stageX / screenSize.x;
		p.y = e.stageY / screenSize.y;
	}
	function onPressed(e:MouseEvent):Void {
		ip = true;
		onMoved(e);
	}
	function onReleased(e:Event):Void {
		ip = false;
	}
}