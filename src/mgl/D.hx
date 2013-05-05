package mgl;
import flash.display.BitmapData;
import flash.display.ColorCorrection;
import flash.geom.Rectangle;
import flash.Lib;
using Math;
class D { // DotShape
	public var i(getNewInstance, null):D;
	public function c(color:C):D { return setColor(color); }
	public function cs(color:C):D { return setColorSpot(color); }
	public function cb(color:C):D { return setColorBottom(color); }
	public function cbs(color:C):D { return setColorBottomSpot(color); }
	public function si(x:Float = 0, y:Float = 0, xy:Float = 0):D {
		return setSpotInterval(x, y, xy);
	}
	public function st(threshold:Float):D { return setSpotThreshold(threshold); }
	public function o(x:Float = 0, y:Float = 0):D { return setOffset(x, y); }
	public function fr(width:Int, height:Int):D { return fillRect(width, height); }
	public function lr(width:Int, height:Int):D { return lineRect(width, height); }
	public function fc(radius:Int):D { return fillCircle(radius); }
	public function lc(radius:Int):D { return lineCircle(radius); }
	public function p(pos:V):D { return setPos(pos); }
	public function r(angle:Float):D { return rotate(angle); }
	public function sz(dotSize:Int):D { return setDotSize(dotSize); }
	public function dc(color:C = null):D { return setDrawColor(color); }
	public var d(draw, null):D;

	static inline var BASE_DOT_SIZE = 3;
	static var bd:BitmapData;
	static var rect:Rectangle;
	static var rPos:V;
	static var colorInstance:C;
	public static function initialize(game:G) {
		bd = game.bd;
		rect = new Rectangle();
		rPos = new V();
		colorInstance = new C();
	}
	var dots:Array<OffsetColor>;
	var color:C;
	var colorSpot:C;
	var colorBottom:C;
	var colorBottomSpot:C;
	var spotThreshold = 0.3;
	var xSpotInterval = 0.0;
	var ySpotInterval = 0.0;
	var xySpotInterval = 0.0;
	var offset:V;
	var pos:V;
	var angle = 0.0;
	var dotSize = BASE_DOT_SIZE;
	var scaleX = 1.0;
	var scaleY = 1.0;
	var isDotScale = true;
	var drawColor:C;
	public function new() {
		dots = new Array<OffsetColor>();
		color = colorInstance.wi;
		colorSpot = colorInstance.di;
		offset = new V();
		pos = new V();
	}
	function getNewInstance():D  {
		return new D();
	}
	function setColor(color:C):D {
		this.color = color;
		return this;
	}
	function setColorSpot(color:C):D {
		colorSpot = color;
		return this;
	}
	function setColorBottom(color:C):D {
		colorBottom = color;
		return this;
	}
	function setColorBottomSpot(color:C):D {
		colorBottomSpot = color;
		return this;
	}
	function setSpotInterval(x:Float = 0, y:Float = 0, xy:Float = 0):D {
		xSpotInterval = (x == 0 ? 0 : Math.PI / 2 / x);
		ySpotInterval = (y == 0 ? 0 : Math.PI / 2 / y);
		xySpotInterval = (xy == 0 ? 0 : Math.PI / 2 / xy);
		return this;
	}
	function setSpotThreshold(threshold:Float):D {
		spotThreshold =  threshold;
		return this;
	}
	function setOffset(x:Float, y:Float):D {
		offset.x = x; offset.y = y;
		return this;
	}
	function fillRect(width:Int, height:Int):D {
		return setRect(width, height, false);
	}
	function lineRect(width:Int, height:Int):D {
		return setRect(width, height, true);
	}
	function fillCircle(radius:Int):D {
		return setCircle(radius, false);
	}
	function lineCircle(radius:Int):D {
		return setCircle(radius, true);
	}
	function setPos(pos:V):D {
		this.pos.v(pos);
		return this;
	}
	function rotate(angle:Float):D {
		this.angle = angle;
		return this;
	}
	function setDotSize(dotSize:Int = BASE_DOT_SIZE):D {
		this.dotSize = dotSize;
		return this;
	}
	function setScale(x:Float, y:Float):D {
		scaleX = x;
		scaleY = (y > 0 ? y : x);
		return this;
	}
	function enableDotScale():D {
		isDotScale = true;
		return this;
	}
	function disableDotScale():D {
		isDotScale = false;
		return this;
	}
	function setDrawColor(color:C):D {
		drawColor = color;
		return this;
	}
	function draw():D {
		if (isDotScale) {
			rect.width = dotSize * scaleX.abs();
			rect.height = dotSize * scaleY.abs();
		} else {
			rect.width = rect.height = dotSize;
		}
		var dox = dotSize * scaleX;
		var doy = dotSize * scaleY;
		var rox = Std.int(rect.width / 2);
		var roy = Std.int(rect.height / 2);
		var x = pos.x * Lib.current.width;
		var y = pos.y * Lib.current.height;
		for (d in dots) {
			rPos.x = d.offset.x * dox;
			rPos.y = d.offset.y * doy;
			if (angle != 0) rPos.r(angle);
			rect.x = Std.int(x + rPos.x) - rox;
			rect.y = Std.int(y + rPos.y) - roy;
			if (drawColor != null) bd.fillRect(rect, drawColor.i);
			else bd.fillRect(rect, d.color);
		}
		return this;
	}

	function setRect(width:Int, height:Int, isDrawingEdge:Bool = false):D {
		var ox = Std.int(-width / 2), oy = -Std.int(height / 2);
		for (y in 0...height) {
			for (x in 0...width) {
				if (!isDrawingEdge ||
				x == 0 || x == width - 1 || y == 0 || y == height - 1) {
					setDot(x + ox, y + oy, y / height);
				}
			}
		}
		return this;
	}
	function setCircle(radius:Int, isDrawingEdge:Bool):D {
		var d = 3 - radius * 2;
		var y = radius;
		for (x in 0...y + 1) {
			if (isDrawingEdge) {
				setCircleDotsEdge(x, y, radius);
				setCircleDotsEdge(y, x, radius);
			} else {
				setCircleDots(x, y, radius);
				setCircleDots(y, x, radius);
			}
			if (d < 0) {
				d += 6 + x * 4;
			} else {
				d += 10 + x * 4 - y * 4;
				y--;
			}
		}
		return this;
	}
	function setCircleDots(x:Int, y:Int, r:Int):Void {
		setXLine(-x, x, y, r);
		setXLine(-x, x, -y, r);
	}
	function setXLine(xb:Int, xe:Int, y:Int, r:Int):Void {
		var ry = (y + r) / (r * 2);
		for (x in xb...xe + 1) setDot(x, y, ry);
	}
	function setCircleDotsEdge(x:Int, y:Int, r:Int):Void {
		var ry = (y + r) / (r * 2);
		setDot(-x, y, ry);
		setDot(x, y, ry);
		ry = (-y + r) / (r * 2);
		setDot(-x, -y, ry);
		setDot(x, -y, ry);
	}
	function setDot(x:Int, y:Int, ry:Float):Void {
		var ca = (x * xSpotInterval).cos() * (y * ySpotInterval).cos() *
			((x + y) * xySpotInterval).cos();
		var c:C;
		if (ca.abs() < spotThreshold) {
			if (colorBottomSpot != null) c = colorSpot.bl(colorBottomSpot, ry);
			else c = colorSpot;
		} else {
			if (colorBottom != null) c = color.bl(colorBottom, ry);
			else c = color;
		}
		if (c.r < 0) return;
		var d = new OffsetColor();
		d.offset.x = x + offset.x;
		d.offset.y = y + offset.y;
		d.color = c.i;
		dots.push(d);
	}
}
class OffsetColor {
	public var offset:V;
	public var color:Int;
	public function new() {
		offset = new V();
	}
}