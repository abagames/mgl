package mgl;
import mgl.G.Screen;
import mgl.T.Letter;
using Math;
using mgl.U;
class D { // DotPixelArt
	static public var i(get, null):D; // instance
	public function c(color:C):D { return setColor(color); }
	public function cs(color:C):D { return setColorSpot(color); }
	public function cb(color:C = null):D { return setColorBottom(color); }
	public function cbs(color:C = null):D { return setColorBottomSpot(color); }
	public function si(x:Float = 0, y:Float = 0, xy:Float = 0):D {
		return setSpotInterval(x, y, xy);
	}
	public function st(threshold:Float):D { return setSpotThreshold(threshold); }
	public function ds(dotScale:Float = -1):D { return setDotScale(dotScale); }
	public function o(x:Float = 0, y:Float = 0):D { return setOffset(x, y); }
	public function fr(width:Float, height:Float = -1, edgeWidth:Int = 0):D {
		return fillRect(width, height, edgeWidth);
	}
	public function lr(width:Float, height:Float = -1, edgeWidth:Int = 1):D {
		return lineRect(width, height, edgeWidth);
	}
	public function gr(width:Float, height:Float = -1, seed:Int = -1):D {
		return generateRect(width, height, seed);
	}
	public function fc(diameter:Float, edgeWidth:Int = 0):D {
		return fillCircle(diameter, edgeWidth);
	}
	public function lc(diameter:Float, edgeWidth:Int = 1):D {
		return lineCircle(diameter, edgeWidth);
	}
	public function gc(diameter:Float, seed:Int = -1):D {
		return generateCircle(diameter, seed);
	}
	public function gs(width:Float, height:Float = -1, seed:Int = -1):D {
		return generateShape(width, height, seed);
	}
	public function tx(text:String):D {
		return drawText(text);
	}
	public function p(pos:V):D { return setPos(pos); }
	public function xy(x:Float, y:Float):D { return setXy(x, y); }
	public function z(z:Float = 0):D { return setZ(z); }
	public function rt(angle:Float = 0):D { return rotate(angle); }
	public function sc(x:Float = 1, y:Float = -1):D { return setScale(x, y); }
	public var ed(get, null):D; // enable dot scale
	public var dd(get, null):D; // disable dot scale
	public var er(get, null):D; // enable rolling shape
	public function dc(color:C = null):D { return setDrawColor(color); }
	public var d(get, null):D; // draw

	static var baseRandomSeed = 0;
	static var pixelSize:V;
	static var pixelWHRatio:Float;
	static var baseDotSize = 1;
	static var rPos:V;
	static var aVec:V;
	public static function initialize(main:Dynamic) {
		baseRandomSeed = U.ch(main);
		pixelSize = G.pixelSize;
		pixelWHRatio = G.pixelWHRatio;
		baseDotSize = G.baseDotSize;
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
	var pz = 0.0;
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
	function setDotScale(dotScale:Float):D {
		if (dotScale < 0) dotSize = baseDotSize;
		else dotSize = Std.int(dotScale * baseDotSize);
		return this;
	}
	function setOffset(x:Float, y:Float):D {
		offset.x = Std.int(x * pixelSize.x / dotSize);
		offset.y = Std.int(y * pixelSize.y / dotSize);
		return this;
	}
	function fillRect(width:Float, height:Float, edgeWidth:Int):D {
		if (height < 0) height = width;
		return setRect(width, height, edgeWidth, false);
	}
	function lineRect(width:Float, height:Float, edgeWidth:Int):D {
		if (height < 0) height = width;
		return setRect(width, height, edgeWidth, true);
	}
	function generateRect(width:Float, height:Float, seed:Int):D {
		if (height < 0) height = width;
		var oc = C.di.v(color);
		setGeneratedColors(color, seed);
		fr(width, height, 1).c(oc).cb(oc.gd).si().lr(width, height);
		return this;
	}
	function fillCircle(diameter:Float, edgeWidth:Int):D {
		return setCircle(diameter, edgeWidth, false);
	}
	function lineCircle(diameter:Float, edgeWidth:Int):D {
		return setCircle(diameter, edgeWidth, true);
	}
	function generateCircle(diameter:Float, seed:Int):D {
		var oc = C.di.v(color);
		setGeneratedColors(color, seed);
		fc(diameter).c(oc).cb(oc.gd).si().lc(diameter);
		return this;
	}
	function generateShape(width:Float, height:Float, seed:Int,
		fillRatio:Float = 0.4, sideRatio:Float = 0.2, crossRatio:Float = 0.2):D {
		if (height < 0) height = width;
		if (seed < 0) seed = baseRandomSeed++;
		var w = Std.int(width * pixelSize.x / dotSize / 2);
		var h = Std.int(height * pixelSize.y / dotSize);
		if (w < 3) w = 3;
		if (h < 3) h = 3;
		var oy = -Std.int(h / 2);
		var pixels = new Array<Array<Int>>();
		for (x in 0...w) {
			var lp = new Array<Int>();
			for (y in 0...h) lp.push(0);
			pixels.push(lp);
		}
		var nextPixels = new Array<V>();
		var oc = C.di.v(color);
		setGeneratedColors(color, seed);
		var r = R.i.s(seed);
		for (i in 0...Std.int(w * h * fillRatio)) {
			for (j in 0...100) {
				if (nextPixels.length <= 0) nextPixels.push(V.i.xy(r.fi(1, w - 2), r.fi(1, h - 2)));
				var np = nextPixels[r.ni(nextPixels.length - 1)];
				var nx = np.xi, ny = np.yi;
				nextPixels.remove(np);
				if (pixels[nx][ny] > 0) continue;
				var countSide = 0, countCross = 1;
				for (ix in (nx - 1).ci(0, w - 2)...(nx + 2).ci(1, w - 1)) {
					for (iy in (ny - 1).ci(1, h - 2)...(ny + 2).ci(2, h - 1)) {
						if (pixels[ix][iy] > 0) {
							if (ix == nx || iy == ny) countSide++;
							else countCross++;
						}
					}
				}
				if (r.n() < 0.9 - countSide * sideRatio && r.n() < 0.9 - countCross * crossRatio) {
					setDot(nx, ny + oy, ny / h);
					setDot(-nx, ny + oy, ny / h);
					pixels[nx][ny] = 1;
					for (ix in (nx - 1).ci(0, w - 2)...(nx + 2).ci(1, w - 1)) {
						for (iy in (ny - 1).ci(1, h - 2)...(ny + 2).ci(2, h - 1)) {
							if (pixels[ix][iy] == 0) {
								for (np in nextPixels) if (np.xi == ix && np.yi == iy) continue;
								nextPixels.push(V.i.xy(ix, iy));
							}
						}
					}
					break;
				}
			}
		}
		c(oc).cb(oc.gd).si();
		for (x in 1...w - 1) {
			for (y in 1...h - 1) {
				if (pixels[x][y] != 1) continue;
				var hp = false;
				for (ix in x - 1...x + 2) {
					for (iy in y - 1...y + 2) {
						if (pixels[ix][iy] == 0 && (ix == x || iy == y)) {
							setDot(ix, iy + oy, iy / h);
							setDot(-ix, iy + oy, iy / h);
							pixels[ix][iy] = 2;
						}
					}
				}
			}
		}
		return this;
	}
	function drawText(text:String):D {
		var l = new Letter();
		l.setDotSize();
		l.setText(text);
		l.alignCenter();
		l.alignVerticalCenter();
		l.draw(pixelFillRect);
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
	function setZ(z:Float):D {
		pz = z;
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
		var zs = 1.0 / (pz + 1);
		var dox:Float;
		var doy:Float;
		var x:Float;
		var y:Float;
		if (pz == 0) {
			dox = dotSize * scaleX;
			doy = dotSize * scaleY;
			x = pos.x * pixelSize.x;
			y = pos.y * pixelSize.y;
		} else {
			dox = dotSize * scaleX * zs;
			doy = dotSize * scaleY * zs;
			x = ((pos.x - 0.5) * zs + 0.5) * pixelSize.x;
			y = ((pos.y - 0.5) * zs + 0.5) * pixelSize.y;
		}
		var w:Float;
		var h:Float;
		if (isDotScale) {
			w = dotSize * scaleX.abs() * zs;
			h = dotSize * scaleY.abs() * zs;
		} else {
			w = h = dotSize;
		}
		w += 0.99;
		h += 0.99;
		var rox = Std.int(w / 2);
		var roy = Std.int(h / 2);
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
			if (angle != 0) rPos.rt(angle);
			var px = Std.int(x + rPos.x) - rox;
			var py = Std.int(y + rPos.y) - roy;
			if (drawColor != null) Screen.pixelFillRect(px, py, pw, ph, drawColor);
			else Screen.pixelFillRect(px, py, pw, ph, d.color);
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
	function setCircle(diameter:Float, edgeWidth:Int, isDrawingEdge:Bool):D {
		var ps = pixelWHRatio < 1 ? pixelSize.x : pixelSize.y;
		var r = Std.int(ps * diameter / 2 / dotSize);
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
	function setDot(x:Int, y:Int, ry:Float):OffsetColor {
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
		if (c.r < 0) return null;
		var d = new OffsetColor();
		d.offset.x = x + offset.x;
		d.offset.y = y + offset.y;
		d.color = c;
		dots.push(d);
		return d;
	}
	function setGeneratedColors(color:C, seed:Int):Void {
		if (seed < 0) seed = baseRandomSeed++;
		var r = R.i.s(seed);
		var cbl = C.di.v(color);
		blinkColor(cbl, r);
		c(cbl).cb(cbl.gd);
		blinkColor(cbl, r);
		cs(cbl).cbs(cbl.gd).si(r.ni(3), r.ni(3), r.ni(3));
	}
	function blinkColor(c:C, r:R):Void {
		c.r += r.pi(64);
		c.g += r.pi(64);
		c.b += r.pi(64);
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