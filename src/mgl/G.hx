package mgl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.utils.ByteArray;
import flash.Lib;
class G { // Game
	static public var ig(get, null):Bool; // is in game
	static public var eg(get, null):Bool; // end game
	static public var t(get, null):Int; // ticks
	static public var ld(get, null):Bool; // load
	static public var sv(get, null):Bool; // save
	static public var rn:R;
	static public function fr(x:Float, y:Float, width:Float, height:Float, color:C):Void {
		Screen.fillRect(x, y, width, height, color);
	}
	static public var df(get, null):Bool; // draw to foreground
	static public var db(get, null):Bool; // draw to background
	public function new(main:Dynamic) { initialize(main); }
	public function tt(title:String, title2:String = ""):G { return setTitle(title, title2); }
	public function vr(version:Int = 1):G { return setVersion(version); }
	public var dm(get, null):G; // debugging mode
	public function yr(ratio:Float):G { return setYRatio(ratio); }
	public var ie(get, null):G; // initialize end

	public function i():Void { ie; } // initialize
	public function b():Void { } // begin
	public function u():Void { } // update
	public function e():Void { } // end
	public function is():Void { } // initialize state
	public function ls(d:Dynamic):Void { } // load state
	public function ss(d:Dynamic):Void { } // save state

	static public var isInGame = false;
	static public var ticks = 0;
	static public var fps = 0.0;
	static public var pixelSize:V;
	static public var pixelWHRatio = 1.0;
	static public var baseDotSize = 1;
	static var mainInstance:Dynamic;
	static var title = "";
	static var title2 = "";
	static var version = 1;
	static var gInstance:G;
	var baseSprite:Sprite;
	var titleTicks = 0;
	var wasClicked = false;
	var wasReleased = false;
	var isDebugging = false;
	var isPaused = false;
	var fpsCount = 0;
	var lastTimer = 0;
	function initialize(mi:Dynamic):Void {
		baseSprite = new Sprite();
		mainInstance = mi;
		gInstance = this;
		pixelSize = new V().xy(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		pixelWHRatio = pixelSize.x / pixelSize.y;
		baseDotSize = U.ci(Std.int(Math.min(pixelSize.x, pixelSize.y) / 160) + 1, 1, 20);
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
		Screen.initialize(baseSprite);
		A.initialize();
		C.initialize();
		D.initialize(mainInstance);
		F.initialize();
		K.initialize();
		M.initialize(baseSprite);
		P.initialize();
		S.initialize(mainInstance);
		T.initialize();
		rn = R.i;
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
		pixelSize.y = pixelSize.x * ratio;
		pixelWHRatio = pixelSize.x / pixelSize.y;
		return this;
	}
	function get_ie():G {
		G.ld;
		if (isDebugging) {
			beginGame();
		} else {
			initializeGame();
			beginTitle();
		}
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
		S.fo();
		G.sv;
		gInstance.e();
		gInstance.beginTitle();
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
		} catch (e:Dynamic) {
			mainInstance.is();
		}
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
	static function get_df():Bool {
		Screen.drawToFront();
		return true;
	}
	static function get_db():Bool {
		Screen.drawToBack();
		return true;
	}
	
	function beginTitle():Void {
		var tx = 0.5;
		if (title2.length <= 0) {
			T.i.tx(title).xy(tx, 0.4).ac.tf;
		} else {
			T.i.tx(title).xy(tx, 0.38).ac.tf;
			T.i.tx(title2).xy(tx, 0.41).ac.tf;
		}
		T.i.tx("CLICK/TOUCH/PUSH").xy(tx, 0.54).ac.tf;
		T.i.tx("TO").xy(tx, 0.58).ac.tf;
		T.i.tx("START").xy(tx, 0.615).ac.tf;
		isInGame = false;
		wasClicked = wasReleased = false;
		titleTicks = 10;
	}
	function beginGame():Void {
		S.s;
		isInGame = true;
		initializeGame();
	}
	function initializeGame():Void {
		A.cl;
		F.cl;
		ticks = 0;
		rn.s();
		mainInstance.b();
	}
	function handleTitleScreen():Void {
		if (M.ib || K.ib || K.iu || K.id || K.ir || K.il) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}
	}
	function updateFrame(e:Event):Void {
		Screen.preUpdate(isPaused);
		M.update();
		K.update();
		if (!isPaused) {
			A.update();
			F.update();
			mainInstance.u();
			if (isDebugging) {
				T.i.tx('FPS: ${Std.int(fps)}').xy(0.01, 0.97);
			}
			for (s in S.ss) s.u();
			ticks++;
		} else {
			T.i.tx("PAUSED").xy(0.5, 0.45).ac.d;
			T.i.tx("CLICK/TOUCH TO RESUME").xy(0.5, 0.55).ac.d;
		}
		if (!isInGame) handleTitleScreen();
		Screen.postUpdate();
		calcFps();
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		K.rs;
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
class Screen {
	static var baseSprite:Sprite;
	static var pixelSize:V;
	static var pixelWHRatio = 1.0;
	static var baseDotSize = 1;
	static var pixelRect:Rectangle;
	static var pixelCount = 0;
	static var bd:BitmapData;
	static var currentBd:BitmapData;
	static var blurBd:BitmapData;
	static var baseBd:BitmapData;
	static var blurBitmap:Bitmap;
	static var rect:Rectangle;
	static var zeroPoint:Point;
	static var fadeFilter:ColorMatrixFilter;
	static var blurFilter:BlurFilter;
	static var lowFpsCount = -120;
	static var hasBlur = true;
	static public function initialize(bs:Sprite):Void {
		baseSprite = bs;
		pixelSize = G.pixelSize;
		pixelWHRatio = G.pixelWHRatio;
		baseDotSize = G.baseDotSize;
		pixelRect = new Rectangle(0, 0, pixelSize.x, pixelSize.y);
		pixelCount = pixelSize.xi * pixelSize.yi;
		baseBd = new BitmapData(pixelSize.xi, pixelSize.yi, false, 0);
		baseSprite.addChild(new Bitmap(baseBd));
		#if js
		bd = new BitmapData(pixelSize.xi, pixelSize.yi, true, 0);
		baseSprite.addChild(new Bitmap(bd));
		hasBlur = false;
		#else
		bd = new BitmapData(pixelSize.xi, pixelSize.yi, true, 0);
		blurBd = new BitmapData(pixelSize.xi, pixelSize.yi, true, 0);
		blurBitmap = new Bitmap(blurBd);
		baseSprite.addChild(blurBitmap);
		fadeFilter = new ColorMatrixFilter(
			[1, 0, 0, 0, 0,  0, 1, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0.8, 0]);
		blurFilter = new BlurFilter(10, 10);
		#end
		currentBd = bd;
		rect = new Rectangle();
		zeroPoint = new Point();
	}
	static public function postUpdate():Void {
		#if !js
		bd.unlock();
		#end
		if (hasBlur) drawBlur();
	}
	static public function preUpdate(isPaused:Bool):Void {
		if (!isPaused && hasBlur) {
			if (G.fps < 40) {
				if (++lowFpsCount > 120) stopBlur();
			} else {
				lowFpsCount = 0;
			}
		}
		#if !js
		bd.lock();
		#end
		bd.fillRect(pixelRect, 0);
	}
	static public inline function pixelFillRect(x:Int, y:Int, width:Int, height:Int, c:C):Void {
		rect.x = x;
		rect.y = y;
		rect.width = width;
		rect.height = height;
		currentBd.fillRect(rect, c.i);
	}
	static public inline function fillRect(x:Float, y:Float, width:Float, height:Float, color:C):Void {
		var w = width * pixelSize.x;
		var h = height * pixelSize.y;
		var px = Std.int(x * pixelSize.x) - Std.int(w / 2);
		var py = Std.int(y * pixelSize.y) - Std.int(h / 2);
		var pw = Std.int(w);
		var ph = Std.int(h);
		pixelFillRect(px, py, pw, ph, color);
	}
	static public function drawToFront():Void {
		currentBd = bd;
	}
	static public function drawToBack():Void {
		currentBd = baseBd;
	}
	static function drawBlur():Void {
		#if !js
		blurBd.lock();
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, fadeFilter);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.unlock();
		#end
	}
	static function stopBlur():Void {
		baseSprite.removeChild(blurBitmap);
		baseSprite.addChild(new Bitmap(bd));
		hasBlur = false;
	}
}