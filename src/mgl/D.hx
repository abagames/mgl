package mgl;
using Math;
class D { // DotShape
	static public var i(get, null):D; // instance
	public function sz(dotSize:Int):D { return setDotSize(dotSize); }
	public function c(color:C):D { return setColor(color); }
	public function cs(color:C):D { return setColorSpot(color); }
	public function cb(color:C = null):D { return setColorBottom(color); }
	public function cbs(color:C = null):D { return setColorBottomSpot(color); }
	public function si(x:Float = 0, y:Float = 0, xy:Float = 0):D {
		return setSpotInterval(x, y, xy);
	}
	public function st(threshold:Float):D { return setSpotThreshold(threshold); }
	public function o(x:Float = 0, y:Float = 0):D { return setOffset(x, y); }
	public function fr(width:Float, height:Float, edgeWidth:Int = 0):D {
		return fillRect(width, height, edgeWidth);
	}
	public function lr(width:Float, height:Float, edgeWidth:Int = 1):D {
		return lineRect(width, height, edgeWidth);
	}
	public function gr(width:Float, height:Float, color:C, seed:Int = -1):D {
		return generateRect(width, height, color, seed);
	}
	public function fc(radius:Float, edgeWidth:Int = 0):D {
		return fillCircle(radius, edgeWidth);
	}
	public function lc(radius:Float, edgeWidth:Int = 1):D {
		return lineCircle(radius, edgeWidth);
	}
	public function gc(radius:Float, color:C, seed:Int = -1):D {
		return generateCircle(radius, color, seed);
	}
	public function tx(text:String):D {
		return drawText(text);
	}
	public function p(pos:V):D { return setPos(pos); }
	public function xy(x:Float, y:Float):D { return setXy(x, y); }
	public function r(angle:Float):D { return rotate(angle); }
	public function sc(x:Float = 1, y:Float = -1):D { return setScale(x, y); }
	public var ed(get, null):D; // enable dot scale
	public var dd(get, null):D; // disable dot scale
	public var er(get, null):D; // enable rolling shape
	public function dc(color:C = null):D { return setDrawColor(color); }
	public var d(get, null):D; // draw

	static var pixelSize:V;
	static var pixelWHRatio:Float;
	static var baseDotSize = 1;
	static var rPos:V;
	static var aVec:V;
	public static function initialize() {
		pixelSize = B.pixelSize;
		pixelWHRatio = B.pixelWHRatio;
		baseDotSize = B.baseDotSize;
		rPos = new V();
		aVec = new V();
	}
	var dots:Array<OffsetColor>;
	var dotSize = 1;
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
	var scaleX = 1.0;
	var scaleY = 1.0;
	var isDotScale = true;
	var isRollingShape = false;
	var drawColor:C;
	public function new() {
		dots = new Array<OffsetColor>();
		dotSize = baseDotSize;
		color = C.wi;
		colorSpot = C.di;
		offset = new V();
		pos = new V();
	}
	static function get_i():D  {
		return new D();
	}
	function setDotSize(dotSize:Int = -1):D {
		if (dotSize < 0) this.dotSize = baseDotSize;
		else this.dotSize = dotSize;
		return this;
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
		offset.x = Std.int(x * pixelSize.x / dotSize);
		offset.y = Std.int(y * pixelSize.y / dotSize);
		return this;
	}
	function fillRect(width:Float, height:Float, edgeWidth:Int):D {
		return setRect(width, height, edgeWidth, false);
	}
	function lineRect(width:Float, height:Float, edgeWidth:Int):D {
		return setRect(width, height, edgeWidth, true);
	}
	function generateRect(width:Float, height:Float, color:C, seed:Int):D {
		setGeneratedColors(color, seed);
		fr(width, height).c(color).cb(color.gd).si().lr(width, height);
		return this;
	}
	function fillCircle(radius:Float, edgeWidth:Int):D {
		return setCircle(radius, edgeWidth, false);
	}
	function lineCircle(radius:Float, edgeWidth:Int):D {
		return setCircle(radius, edgeWidth, true);
	}
	function generateCircle(radius:Float, color:C, seed:Int):D {
		setGeneratedColors(color, seed);
		fc(radius, 1).c(color).cb(color.gd).si().lc(radius);
		return this;
	}
	function drawText(text:String):D {
		L.i.tx(text).avc.draw(pixelFillRect);
		return this;
	}
	function setPos(pos:V):D {
		this.pos.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):D {
		this.pos.xy(x, y);
		return this;
	}
	function rotate(angle:Float):D {
		if (pixelWHRatio == 1.0) {
			this.angle = angle;
		} else {
			var a = angle * Math.PI / 180;
			aVec.xy(a.sin() * pixelWHRatio, -a.cos());
			this.angle = aVec.w;
		}
		return this;
	}
	function setScale(x:Float, y:Float):D {
		scaleX = x;
		scaleY = (y >= 0 ? y : x);
		return this;
	}
	function get_ed():D {
		isDotScale = true;
		return this;
	}
	function get_dd():D {
		isDotScale = false;
		return this;
	}
	function get_er():D {
		isRollingShape = true;
		return this;
	}
	function setDrawColor(color:C):D {
		drawColor = color;
		return this;
	}
	function get_d():D {
		var w:Float;
		var h:Float;
		if (isDotScale) {
			w = dotSize * scaleX.abs();
			h = dotSize * scaleY.abs();
		} else {
			w = h = dotSize;
		}
		w += .99;
		h += .99;
		var dox = dotSize * scaleX;
		var doy = dotSize * scaleY;
		/*if (isRollingShape) {
			dox *= .7;
			doy *= .7;
		}*/
		var rox = Std.int(w / 2);
		var roy = Std.int(h / 2);
		var x = pos.x * pixelSize.x;
		var y = pos.y * pixelSize.y;
		var pw:Int;
		var ph:Int;
		if (!isRollingShape) {
			pw = Std.int(w);
			ph = Std.int(h);
		} else {
			pw = Std.int(w * 1.4);
			ph = Std.int(h * 1.4);
		}
		for (d in dots) {
			rPos.x = d.offset.x * dox;
			rPos.y = d.offset.y * doy;
			if (angle != 0) rPos.r(angle);
			var px = Std.int(x + rPos.x) - rox;
			var py = Std.int(y + rPos.y) - roy;
			if (drawColor != null) B.pixelFillRect(px, py, pw, ph, drawColor);
			else B.pixelFillRect(px, py, pw, ph, d.color);
		}
		return this;
	}

	function setRect(width:Float, height:Float, edgeWidth:Int, isDrawingEdge:Bool = false):D {
		var w = Std.int(pixelSize.x * width / dotSize);
		var h = Std.int(pixelSize.y * height / dotSize);
		var ox = -Std.int(w / 2), oy = -Std.int(h / 2);
		for (y in 0...h) {
			for (x in 0...w) {
				if (x < edgeWidth || x >= w - edgeWidth ||
					y < edgeWidth || y >= h - edgeWidth) {
					if (isDrawingEdge) setDot(x + ox, y + oy, y / h);
				} else {
					if (!isDrawingEdge) setDot(x + ox, y + oy, y / h);
				}
			}
		}
		return this;
	}
	function setCircle(radius:Float, edgeWidth:Int, isDrawingEdge:Bool):D {
		var ps = pixelWHRatio < 1 ? pixelSize.x : pixelSize.y;
		var r = Std.int(ps * radius / dotSize);
		if (isDrawingEdge) {
			for (er in r - edgeWidth + 1...r + 1) setOneCircle(er, true);
		} else {
			setOneCircle(r - edgeWidth, false);
		}
		return this;
	}
	function setOneCircle(radius:Int, isDrawingEdge:Bool):Void {
		var d = 3 - radius * 2;
		var y = radius;
		for (x in 0...Std.int(y * 0.7) + 2) {
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
	public function pixelFillRect(x:Int, y:Int, width:Int, height:Int, c:C):Void {
		setDot(x, y, 0);
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
		d.color = c;
		dots.push(d);
	}
	function setGeneratedColors(color:C, seed:Int):Void {
		var r = R.i;
		if (seed >= 0) r.s(seed);
		var cbl = C.di.v(color);
		blinkColor(cbl, r);
		c(cbl).cb(cbl.gd);
		blinkColor(cbl, r);
		cs(cbl).cbs(cbl.gd).si(r.ni(3), r.ni(3), r.ni(3));
	}
	function blinkColor(c:C, r:R):Void {
		c.r += r.pi(80);
		c.g += r.pi(80);
		c.b += r.pi(80);
		c.normalize();
	}
}
class OffsetColor {
	public var offset:V;
	public var color:C;
	public function new() {
		offset = new V();
	}
}