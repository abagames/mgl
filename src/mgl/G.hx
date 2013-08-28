package mgl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.net.SharedObject;
import flash.utils.ByteArray;
import flash.Lib;
using mgl.U;
class G { // Game
	static public var ig(get, null):Bool; // is in game
	static public var eg(get, null):Bool; // end game
	static public var t(get, null):Int; // ticks
	static public var r:R;
	public function new(main:Dynamic) { initialize(main); }
	public function tt(title:String, title2:String = ""):G { return setTitle(title, title2); }
	public function vr(version:Int = 1):G { return setVersion(version); }
	public var dm(get, null):G; // debugging mode
	public function yr(ratio:Float):G { return setYRatio(ratio); }
	public var ie(get, null):G; // initialize end

	public function i():Void { } // initialize
	public function b():Void { } // begin
	public function u():Void { } // update
	public function is():Void { } // initialize state
	public function ls(d:Dynamic):Void { } // load state
	public function ss(d:Dynamic):Void { } // save state
	
	static public var ld(get, null):Bool; // load
	static public var sv(get, null):Bool; // save

	static public var isInGame = false;
	static public var ticks = 0;
	static public var fps = 0.0;
	static var titleTicks = 0;
	static var wasClicked = false;
	static var wasReleased = false;
	static var mainInstance:Dynamic;
	static var title = "";
	static var title2 = "";
	static var version = 1;
	var baseSprite:Sprite;
	var isDebugging = false;
	var isPaused = false;
	var backgroundColor:C;
	var fpsCount = 0;
	var lastTimer = 0;
	var lt:L;
	function initialize(mi:Dynamic):Void {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		baseSprite = new Sprite();
		mainInstance = mi;
		baseSprite.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		Lib.current.addChild(baseSprite);
	}
	function onAdded(_):Void {
		baseSprite.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		#if ios
		haxe.Timer.delay(added, 100);
		#else
		added();
		#end
	}
	function added():Void {
		B.initialize(baseSprite);
		A.initialize();
		C.initialize();
		D.initialize();
		F.initialize();
		K.initialize();
		L.initialize();
		M.initialize(baseSprite);
		P.initialize();
		S.initialize();
		T.initialize();
		lt = L.i;
		r = R.i;
		mainInstance.i();
	}
	function setTitle(t:String, t2:String):G {
		title = t;
		title2 = t2;
		return this;
	}
	function setVersion(v:Int):G {
		version = v;
		return this;
	}
	function get_dm():G {
		isDebugging = true;
		return this;
	}
	function setYRatio(ratio:Float):G {
		B.pixelSize.y = B.pixelSize.x * ratio;
		B.pixelWHRatio = B.pixelSize.x / B.pixelSize.y;
		D.initialize();
		return this;
	}
	function get_ie():G {
		G.ld;
		if (isDebugging) beginGame();
		else initializeGame();
		lastTimer = Std.int(Date.now().getTime());
		Lib.current.addEventListener(Event.ACTIVATE, onActivated);
		Lib.current.addEventListener(Event.DEACTIVATE, onDeactivated);
		Lib.current.addEventListener(Event.ENTER_FRAME, updateFrame);
		return this;
	}
	static function get_ig():Bool {
		return isInGame;
	}
	static function get_t():Int {
		return ticks;
	}
	static function get_eg():Bool {
		if (!isInGame) return false;
		G.sv;
		isInGame = false;
		wasClicked = wasReleased = false;
		ticks = 0;
		titleTicks = 10;
		return true;
	}
	static function get_ld():Bool {
		#if (flash || js)
		try {
			var storeKey = StringTools.replace(title + "_" + title2 + "_" + version, " ", "");
			var sharedObject:SharedObject = SharedObject.getLocal(storeKey);
			if (sharedObject.size < 10) {
				mainInstance.is();
			} else {
				mainInstance.ls(sharedObject.data);
				K.ls(sharedObject.data);
			}
			return true;
		} catch (e:Dynamic) { }
		#end
		return false;
	}
	static function get_sv():Bool {
		#if (flash || js)
		try {
			var storeKey = StringTools.replace(title + "_" + title2 + "_" + version, " ", "");
			var sharedObject:SharedObject = SharedObject.getLocal(storeKey);
			mainInstance.ss(sharedObject.data);
			K.ss(sharedObject.data);
			sharedObject.flush();
			return true;
		} catch (e:Dynamic) { }
		#end
		return false;
	}
	
	function beginGame():Void {
		isInGame = true;
		ticks = 0;
		r.s();
		initializeGame();
	}
	function initializeGame():Void {
		A.clear();
		F.clear();
		mainInstance.b();
	}
	function handleTitleScreen():Void {
		var tx = 0.5;
		if (title2.length <= 0) {
			lt.tx(title).xy(tx, 0.4).d;
		} else {
			lt.tx(title).xy(tx, 0.38).d;
			lt.tx(title2).xy(tx, 0.41).d;
		}
		lt.tx("CLICK/TOUCH/PUSH").xy(tx, 0.54).d;
		lt.tx("TO").xy(tx, 0.58).d;
		lt.tx("START").xy(tx, 0.615).d;
		if (M.ip || K.ib || K.iu || K.id || K.ir || K.il) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}
	}
	function updateFrame(e:Event):Void {
		B.preUpdate();
		K.u();
		if (!isPaused) {
			A.update();
			F.update();
			mainInstance.u();
			if (isDebugging) {
				lt.al.tx("FPS: " + Std.string(Std.int(fps))).xy(0, 0.95).d.ac;
			}
			for (s in S.ss) s.u();
			ticks++;
		} else {
			lt.tx("PAUSED").xy(0.5, 0.45).d;
			lt.tx("CLICK/TOUCH TO RESUME").xy(0.5, 0.55).d;
		}
		if (!isInGame) handleTitleScreen();
		B.postUpdate();
		calcFps();
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		K.r;
		if (isInGame) isPaused = true;
	}
	function calcFps():Void {
		fpsCount++;
		var currentTimer = Std.int(Date.now().getTime());
		var delta = currentTimer - lastTimer;
		if (delta >= 1000) {
			fps = fpsCount * 1000 / delta;
			lastTimer = currentTimer;
			fpsCount = 0;
		}
	}
}