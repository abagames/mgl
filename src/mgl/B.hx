package mgl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.Lib;
using mgl.U;
class B { // Bitmap
	static public function fr(x:Float, y:Float, width:Float, height:Float, color:C):Void {
		fillRect(x, y, width, height, color);
	}
	
	static public var pixelSize:V;
	static public var pixelRect:Rectangle;
	static public var pixelWHRatio = 1.0;
	static public var baseDotSize = 1;
	static var baseSprite:Sprite;
	static var bd:BitmapData;
	static var blurBd:BitmapData;
	static var baseBd:BitmapData;
	static var blurBitmap:Bitmap;
	static var pixelCount = 0;
	static var rect:Rectangle;
	static var zeroPoint:Point;
	static var fadeFilter:ColorMatrixFilter;
	static var blurFilter10:BlurFilter;
	static var blurFilter20:BlurFilter;
	static var lowFpsCount = -120;
	static var hasBlur = true;
	static public function initialize(bs:Sprite):Void {
		baseSprite = bs;
		pixelSize = new V().xy(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		pixelRect = new Rectangle(0, 0, pixelSize.x, pixelSize.y);
		pixelWHRatio = pixelSize.x / pixelSize.y;
		pixelCount = pixelSize.xi * pixelSize.yi;
		baseDotSize = U.ci(Std.int(Math.min(pixelSize.x, pixelSize.y) / 160) + 1, 1, 20);
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
		blurFilter10 = new BlurFilter(10, 10);
		blurFilter20 = new BlurFilter(20, 20);
		#end
		rect = new Rectangle();
		zeroPoint = new Point();
	}
	static public function postUpdate():Void {
		#if !js
		bd.unlock();
		#end
		if (hasBlur) drawBlur();
	}
	static public function preUpdate():Void {
		if (hasBlur) {
			if (G.fps < 40) {
				if (++lowFpsCount > 60) stopBlur();
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
		bd.fillRect(rect, c.i);
	}
	static inline function fillRect(x:Float, y:Float, width:Float, height:Float, color:C):Void {
		var w = width * pixelSize.x;
		var h = height * pixelSize.y;
		var px = Std.int(x * pixelSize.x) - Std.int(w / 2);
		var py = Std.int(y * pixelSize.y) - Std.int(h / 2);
		var pw = Std.int(w);
		var ph = Std.int(h);
		pixelFillRect(px, py, pw, ph, color);
	}
	static function drawBlur():Void {
		#if !js
		blurBd.lock();
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, fadeFilter);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter20);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter10);
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