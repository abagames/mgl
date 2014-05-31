package mgl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.utils.ByteArray;
import flash.Lib;
#if flash
import flash.net.FileReference;
import org.bytearray.gif.encoder.GIFEncoder;
#end
class Game {
	static public var isInGame(get, null):Bool;
	static public var ig(get, null):Bool; // is in game
	static public function endGame():Bool { return get_eg(); }
	static public var eg(get, null):Bool; // end game
	static public var ticks(get, null):Int;
	static public var t(get, null):Int; // ticks
	static public function dc(factor:Float = 1):Float {
		return getDifficulty(factor);
	}
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
	public function tt(title:String, title2:String = "", title3:String = ""):Game {
		return setTitle(title, title2, title3);
	}
	public function vr(version:Int = 1):Game { return setVersion(version); }
	public function dt(color:Color, seed:Int = -1):Game { return decorateTitle(color, seed); }
	public function enableDebuggingMode():Game { return get_dm(); }
	public var dm(get, null):Game; // enable debugging mode
	public function cm
	(scale:Float = 1, durationSec:Float = 3, intervalSec:Float = .1):Game {
		return enableCaptureMode(scale, durationSec, intervalSec);
	}
	public function yr(ratio:Float):Game { return setYRatio(ratio); }
	public function ds(baseDotSizeRatio:Float = 1):Game {
		return setBaseDotSizeRatio(baseDotSizeRatio);
	}
	public function initializeEnd():Game { return get_ie(); }
	public var ie(get, null):Game; // initialize end

	public function initialize():Void { }
	public function begin():Void { }
	public function updateBackground():Void { }
	public function update():Void { }
	public function end():Void { }
	public function initializeState():Void { }
	public function loadState(d:Dynamic):Void { }
	public function saveState(d:Dynamic):Void { }

	static public var isInGameState = false;
	static public var currentTicks = 0;
	static public var fps = 0.0;
	static public var pixelSize:Vector;
	static public var pixelWHRatio = 1.0;
	static public var baseDotSize = 1;
	static var mainInstance:Dynamic;
	static var title = "";
	static var title2 = "";
	static var title3 = "";
	static var version = 1;
	static var gInstance:Game;
	var baseSprite:Sprite;
	var baseRandomSeed = 0;	
	var titleTicks = 0;
	var wasClicked = false;
	var wasReleased = false;
	var isPaused = false;
	var fpsCount = 0;
	var lastTimer = 0;
	var isTitleDecorated = false;
	var titleDecoratingColor:Color;
	var titleDecoratingSeed = 0;
	var isDebuggingMode = false;
	var isCaptureMode = false;
	var captureInterval = 0;
	function initializeFirst(mi:Dynamic):Void {
		baseSprite = new Sprite();
		mainInstance = mi;
		baseRandomSeed = Util.getClassHash(mi);
		gInstance = this;
		pixelSize = new Vector().setXy(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		pixelWHRatio = pixelSize.x / pixelSize.y;
		setBaseDotSizeRatio();
		baseSprite.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		Lib.current.addChild(baseSprite);
	}
	public function setBaseDotSizeRatio(baseDotSizeRatio:Float = 1):Game {
		baseDotSize = Util.ci(Std.int(
			(Math.min(pixelSize.x, pixelSize.y) / 160 + 1) * baseDotSizeRatio), 1, 20);
		DotPixelArt.setBaseDotSize();
		Text.setBaseDotSize();
		return this;
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
		get_ie();
	}
	public function setTitle(t:String, t2:String = "", t3:String = ""):Game {
		title = t;
		title2 = t2;
		title3 = t3;
		return this;
	}
	public function setVersion(v:Int = 1):Game {
		version = v;
		return this;
	}
	function decorateTitle(color:Color, seed:Int = -1):Game {
		isTitleDecorated = true;
		titleDecoratingColor = color;
		if (seed < 0) seed = baseRandomSeed++;		
		titleDecoratingSeed = seed;
		return this;
	}
	function get_dm():Game {
		isDebuggingMode = true;
		return this;
	}
	public function enableCaptureMode
	(scale:Float = 1, durationSec:Float = 3, intervalSec:Float = .1):Game {
		isCaptureMode = true;
		Screen.beginCapture(scale, durationSec, intervalSec);
		captureInterval = Std.int(intervalSec * 60);
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
		if (isDebuggingMode) {
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
	static function getDifficulty(factor:Float = 1):Float {
		return Math.sqrt(currentTicks * 0.0001 * factor) + 1;
	}
	static function get_eg():Bool {
		if (!isInGameState) return false;
		Sound.fadeOut();
		Game.save();
		gInstance.end();
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
			} else {
				mainInstance.loadState(sharedObject.data);
				Key.loadState(sharedObject.data);
			}
			return true;
		} catch (e:Dynamic) {
			mainInstance.initializeState();
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
		var tts:Array<Text> = new Array<Text>();
		tts.push(new Text().setText(title));
		if (title2.length > 0) tts.insert(0, new Text().setText(title2));
		if (title3.length > 0) tts.insert(0, new Text().setText(title3));
		var ty = if (isTitleDecorated) {
			if (tts.length == 1) 0.37 else 0.42;
		} else {
			if (tts.length == 1) 0.4 else 0.41;
		}
		for (tt in tts) {
			tt.alignCenter().setTickForever();
			if (isTitleDecorated) tt.decorate(titleDecoratingColor, titleDecoratingSeed);
			tt.setXy(tx, ty);
			ty -= if (isTitleDecorated) 0.12 else 0.03;
		}
		var msgY = if (isTitleDecorated) 0.6 else 0.54;
		new Text().setText("CLICK/TOUCH/PUSH").setXy(tx, msgY).alignCenter().setTickForever();
		new Text().setText("TO").setXy(tx, msgY + 0.04).alignCenter().setTickForever();
		new Text().setText("START").setXy(tx, msgY + 0.075).alignCenter().setTickForever();
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
		rn.setSeed();
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
	var isCapturing = false;
	function updateFrame(e:Event):Void {
		if (isCaptureMode) {
			if (isCapturing) {
				Screen.endCapture();
				isCapturing = Key.s[67] = false;
			} else if (currentTicks % captureInterval == 0) {
				Screen.capture();
			}
		}
		Screen.preUpdate(isPaused);
		mainInstance.updateBackground();
		Mouse.update();
		Key.update();
		if (!isPaused) {
			Actor.updateAll();
			Fiber.updateAll();
			mainInstance.update();
			if (isDebuggingMode) {
				new Text().setText('FPS: ${Std.int(fps)}').setXy(0.01, 0.97).draw();
			}
			for (s in Sound.ss) s.update();
			currentTicks++;
			if (!isInGameState) handleTitleScreen();
		} else {
			new Text().setText("PAUSED").setXy(0.5, 0.45).alignCenter().draw();
			new Text().setText("CLICK/TOUCH TO RESUME").setXy(0.5, 0.55).alignCenter().draw();
		}
		if (isCaptureMode && isInGameState && Key.s[67]) {
			new Text().setText("CAPTURING...").setXy(.5, .5).alignCenter().draw();
			isCapturing = true;
		}
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
	static var capturedBds:Array<BitmapData>;
	static var capturedBdsIndex = 0;
	static var captureDuration = 0;
	static var captureInterval = 0;
	static var captureWidth = 0;
	static var captureHeight = 0;
	static var captureMatrix:Matrix;
	static public function beginCapture(scale:Float, durationSec:Float, intervalSec:Float):Void {
		capturedBds = new Array<BitmapData>();
		captureDuration = Std.int(durationSec / intervalSec);
		captureInterval = Std.int(intervalSec * 1000);
		for (i in 0...captureDuration) capturedBds.push(null);
		captureWidth = Std.int(pixelSize.xi * scale);
		captureHeight = Std.int(pixelSize.yi * scale);
		captureMatrix = new Matrix();
		captureMatrix.scale(scale, scale);
	}
	static public function capture():Void {
		var capturedBd = new BitmapData(captureWidth, captureHeight, false, 0);
		capturedBd.draw(Lib.current.stage, captureMatrix);
		capturedBds[capturedBdsIndex] = capturedBd;
		capturedBdsIndex = Util.loopRangeInt(capturedBdsIndex + 1, 0, captureDuration);
	}
	static public function endCapture():Void {
		#if flash
		var encoder = new GIFEncoder();
		encoder.setRepeat(0);
		encoder.setDelay(captureInterval);
		encoder.start();
		var idx = capturedBdsIndex;
		for (i in 0...captureDuration) {
			var cbd = capturedBds[idx];
			if (cbd != null) encoder.addFrame(cbd);
			idx = Util.loopRangeInt(idx + 1, 0, captureDuration);
		}
		encoder.finish();
		var fileReference = new FileReference();
		fileReference.save(encoder.stream, "capture.gif");
		#end
	}
}