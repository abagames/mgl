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
class Game {
	static public var isInGame(get, null):Bool;
	static public var ig(get, null):Bool; // is in game
	static public function endGame():Bool { return get_eg(); }
	static public var eg(get, null):Bool; // end game
	static public var ticks(get, null):Int;
	static public var t(get, null):Int; // ticks
	static public function load():Bool { return get_ld(); }
	static public var ld(get, null):Bool; // load
	static public function save():Bool { return get_sv(); }
	static public var sv(get, null):Bool; // save
	static public var random(get, null):Random;
	static public var rn:Random;
	static public function fillRect(x:Float, y:Float, width:Float, height:Float, color:Color):Void {
		Screen.fillRect(x, y, width, height, color);
	}
	static public function fr(x:Float, y:Float, width:Float, height:Float, color:Color):Void {
		Screen.fillRect(x, y, width, height, color);
	}
	static public function drawToForeground():Bool { return get_df(); }
	static public var df(get, null):Bool; // draw to foreground
	static public function drawToBackground():Bool { return get_db(); }
	static public var db(get, null):Bool; // draw to background
	public function new(main:Dynamic) { initializeFirst(main); }
	public function tt(title:String, title2:String = ""):Game { return setTitle(title, title2); }
	public function vr(version:Int = 1):Game { return setVersion(version); }
	public function enableDebuggingMode():Game { return get_dm(); }
	public var dm(get, null):Game; // enable debugging mode
	public function yr(ratio:Float):Game { return setYRatio(ratio); }
	public function initializeEnd():Game { return get_ie(); }
	public var ie(get, null):Game; // initialize end

	public function initialize():Void { }
	public function i():Void { } // initialize
	public function begin():Void { }
	public function b():Void { } // begin
	public function update():Void { }
	public function u():Void { } // update
	public function end():Void { }
	public function e():Void { } // end
	public function initializeState():Void { }
	public function is():Void { } // initialize state
	public function loadState(d:Dynamic):Void { }
	public function ls(d:Dynamic):Void { } // load state
	public function saveState(d:Dynamic):Void { }
	public function ss(d:Dynamic):Void { } // save state

	static public var isInGameState = false;
	static public var currentTicks = 0;
	static public var fps = 0.0;
	static public var pixelSize:Vector;
	static public var pixelWHRatio = 1.0;
	static public var baseDotSize = 1;
	static var mainInstance:Dynamic;
	static var title = "";
	static var title2 = "";
	static var version = 1;
	static var gInstance:Game;
	var baseSprite:Sprite;
	var titleTicks = 0;
	var wasClicked = false;
	var wasReleased = false;
	var isDebugging = false;
	var isPaused = false;
	var fpsCount = 0;
	var lastTimer = 0;
	function initializeFirst(mi:Dynamic):Void {
		baseSprite = new Sprite();
		mainInstance = mi;
		gInstance = this;
		pixelSize = new Vector().setXy(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		pixelWHRatio = pixelSize.x / pixelSize.y;
		baseDotSize = Util.ci(Std.int(Math.min(pixelSize.x, pixelSize.y) / 160) + 1, 1, 20);
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
		Actor.initializeAll();
		Color.initialize();
		DotPixelArt.initialize(mainInstance);
		Fiber.initialize();
		Key.initialize();
		Mouse.initialize(baseSprite);
		Particle.initialize();
		Sound.initialize(mainInstance);
		Text.initialize();
		rn = Random.i;
		mainInstance.initialize();
		mainInstance.i();
		get_ie();
	}
	public function setTitle(t:String, t2:String = ""):Game {
		title = t;
		title2 = t2;
		return this;
	}
	public function setVersion(v:Int = 1):Game {
		version = v;
		return this;
	}
	function get_dm():Game {
		isDebugging = true;
		return this;
	}
	public function setYRatio(ratio:Float):Game {
		pixelSize.y = pixelSize.x * ratio;
		pixelWHRatio = pixelSize.x / pixelSize.y;
		return this;
	}
	var isGameLoopStarted = false;
	function get_ie():Game {
		if (isGameLoopStarted) return this;
		isGameLoopStarted = true;
		Game.load();
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
	static function get_isInGame():Bool {
		return isInGameState;
	}
	static function get_ig():Bool {
		return isInGameState;
	}
	static function get_ticks():Int {
		return currentTicks;
	}
	static function get_t():Int {
		return currentTicks;
	}
	static function get_eg():Bool {
		if (!isInGameState) return false;
		Sound.fadeOut();
		Game.save();
		gInstance.end();
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
				mainInstance.initializeState();
				mainInstance.is();
			} else {
				mainInstance.loadState(sharedObject.data);
				mainInstance.ls(sharedObject.data);
				Key.loadState(sharedObject.data);
			}
			return true;
		} catch (e:Dynamic) {
			mainInstance.initializeState();
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
			mainInstance.saveState(sharedObject.data);
			mainInstance.ss(sharedObject.data);
			Key.saveState(sharedObject.data);
			sharedObject.flush();
			return true;
		} catch (e:Dynamic) { }
		#end
		return false;
	}
	static function get_random():Random {
		return rn;
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
			new Text().setText(title).setXy(tx, 0.4).alignCenter().setTickForever();
		} else {
			new Text().setText(title).setXy(tx, 0.38).alignCenter().setTickForever();
			new Text().setText(title2).setXy(tx, 0.41).alignCenter().setTickForever();
		}
		new Text().setText("CLICK/TOUCH/PUSH").setXy(tx, 0.54).alignCenter().setTickForever();
		new Text().setText("TO").setXy(tx, 0.58).alignCenter().setTickForever();
		new Text().setText("START").setXy(tx, 0.615).alignCenter().setTickForever();
		isInGameState = false;
		wasClicked = wasReleased = false;
		titleTicks = 10;
	}
	function beginGame():Void {
		Sound.stop();
		isInGameState = true;
		initializeGame();
	}
	function initializeGame():Void {
		Actor.clear();
		Fiber.clear();
		currentTicks = 0;
		random.setSeed(0);
		mainInstance.b();
		mainInstance.begin();
	}
	function handleTitleScreen():Void {
		if (Mouse.isButtonPressing || Key.isButtonPressing ||
		Key.isUpPressing || Key.isDownPressing || Key.isRightPressing || Key.isLeftPressing) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}
	}
	function updateFrame(e:Event):Void {
		Screen.preUpdate(isPaused);
		Mouse.update();
		Key.update();
		if (!isPaused) {
			Actor.updateAll();
			Fiber.updateAll();
			mainInstance.update();
			mainInstance.u();
			if (isDebugging) {
				new Text().setText('FPS: ${Std.int(fps)}').setXy(0.01, 0.97);
			}
			for (s in Sound.ss) s.u();
			currentTicks++;
		} else {
			new Text().setText("PAUSED").setXy(0.5, 0.45).alignCenter().draw();
			new Text().setText("CLICK/TOUCH TO RESUME").setXy(0.5, 0.55).alignCenter().draw();
		}
		if (!isInGameState) handleTitleScreen();
		Screen.postUpdate();
		calcFps();
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		Key.rs;
		if (isInGameState) isPaused = true;
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
	static var pixelSize:Vector;
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
		pixelSize = Game.pixelSize;
		pixelWHRatio = Game.pixelWHRatio;
		baseDotSize = Game.baseDotSize;
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
			if (Game.fps < 40) {
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
	static public inline function pixelFillRect(x:Int, y:Int, width:Int, height:Int, c:Color):Void {
		rect.x = x;
		rect.y = y;
		rect.width = width;
		rect.height = height;
		currentBd.fillRect(rect, c.int);
	}
	static public inline function fillRect(x:Float, y:Float, width:Float, height:Float, color:Color):Void {
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