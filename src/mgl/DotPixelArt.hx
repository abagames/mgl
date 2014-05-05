package mgl;
import mgl.Game.Screen;
import mgl.Text.Letter;
using Math;
using mgl.Util;
class DotPixelArt {
	static public var i(get, null):DotPixelArt; // instance
	public function c(color:Color):DotPixelArt { return setColor(color); }
	public function cs(color:Color):DotPixelArt { return setColorSpot(color); }
	public function cb(color:Color = null):DotPixelArt { return setColorBottom(color); }
	public function cbs(color:Color = null):DotPixelArt { return setColorBottomSpot(color); }
	public function si(x:Float = 0, y:Float = 0, xy:Float = 0):DotPixelArt {
		return setSpotInterval(x, y, xy);
	}
	public function st(threshold:Float):DotPixelArt { return setSpotThreshold(threshold); }
	public function ds(dotScale:Float = -1):DotPixelArt { return setDotScale(dotScale); }
	public function o(x:Float = 0, y:Float = 0):DotPixelArt { return setOffset(x, y); }
	public function fr(width:Float, height:Float = -1, edgeWidth:Int = 0):DotPixelArt {
		return fillRect(width, height, edgeWidth);
	}
	public function lr(width:Float, height:Float = -1, edgeWidth:Int = 1):DotPixelArt {
		return lineRect(width, height, edgeWidth);
	}
	public function gr(width:Float, height:Float = -1, seed:Int = -1):DotPixelArt {
		return generateRect(width, height, seed);
	}
	public function ft(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	edgeWidth:Int = 0):DotPixelArt {
		return fillTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, edgeWidth);
	}
	public function lt(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	edgeWidth:Int = 1):DotPixelArt {
		return lineTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, edgeWidth);
	}
	public function gt(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	seed:Int = -1):DotPixelArt {
		return generateTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, seed);
	}
	public function fc(diameter:Float, edgeWidth:Int = 0):DotPixelArt {
		return fillCircle(diameter, edgeWidth);
	}
	public function lc(diameter:Float, edgeWidth:Int = 1):DotPixelArt {
		return lineCircle(diameter, edgeWidth);
	}
	public function gc(diameter:Float, seed:Int = -1):DotPixelArt {
		return generateCircle(diameter, seed);
	}
	public function gs(width:Float, height:Float = -1, seed:Int = -1):DotPixelArt {
		return generateShape(width, height, seed);
	}
	public function tx(text:String):DotPixelArt {
		return drawText(text);
	}
	public function p(pos:Vector):DotPixelArt { return setPosition(pos); }
	public function xy(x:Float, y:Float):DotPixelArt { return setXy(x, y); }
	public function z(z:Float = 0):DotPixelArt { return setZ(z); }
	public function rt(angle:Float = 0):DotPixelArt { return rotate(angle); }
	public function sc(x:Float = 1, y:Float = -1):DotPixelArt { return setScale(x, y); }
	public function enableDotScale():DotPixelArt { return get_ed(); }
	public var ed(get, null):DotPixelArt; // enable dot scale
	public function disableDotScale():DotPixelArt { return get_dd(); }
	public var dd(get, null):DotPixelArt; // disable dot scale
	public function enableRollingShape():DotPixelArt { return get_er(); }
	public var er(get, null):DotPixelArt; // enable rolling shape
	public function dc(color:Color = null):DotPixelArt { return setDrawColor(color); }
	public function draw():DotPixelArt { return get_d(); }
	public var d(get, null):DotPixelArt; // draw

	static var baseRandomSeed = 0;
	static var pixelSize:Vector;
	static var pixelWHRatio:Float;
	static var baseDotSize = 1;
	static var rPos:Vector;
	static var aVec:Vector;
	static public function initialize(main:Dynamic) {
		baseRandomSeed = Util.getClassHash(main);
		pixelSize = Game.pixelSize;
		pixelWHRatio = Game.pixelWHRatio;
		rPos = new Vector();
		aVec = new Vector();
	}
	static public function setBaseDotSize():Void {
		baseDotSize = Game.baseDotSize;
	}
	var dots:Array<OffsetColor>;
	var dotSize = 1;
	var color:Color;
	var colorSpot:Color;
	var colorBottom:Color;
	var colorBottomSpot:Color;
	var spotThreshold = 0.3;
	var xSpotInterval = 0.0;
	var ySpotInterval = 0.0;
	var xySpotInterval = 0.0;
	var offset:Vector;
	var pos:Vector;
	var pz = 0.0;
	var angle = 0.0;
	var scaleX = 1.0;
	var scaleY = 1.0;
	var isDotScale = true;
	var isRollingShape = false;
	var drawColor:Color;
	public function new() {
		dots = new Array<OffsetColor>();
		dotSize = baseDotSize;
		color = Color.white;
		colorSpot = Color.black;
		offset = new Vector();
		pos = new Vector();
	}
	static function get_i():DotPixelArt  {
		return new DotPixelArt();
	}
	public function setColor(color:Color):DotPixelArt {
		this.color = color;
		return this;
	}
	public function setColorSpot(color:Color):DotPixelArt {
		colorSpot = color;
		return this;
	}
	public function setColorBottom(color:Color = null):DotPixelArt {
		colorBottom = color;
		return this;
	}
	public function setColorBottomSpot(color:Color = null):DotPixelArt {
		colorBottomSpot = color;
		return this;
	}
	public function setSpotInterval(x:Float = 0, y:Float = 0, xy:Float = 0):DotPixelArt {
		xSpotInterval = (x == 0 ? 0 : Math.PI / 2 / x);
		ySpotInterval = (y == 0 ? 0 : Math.PI / 2 / y);
		xySpotInterval = (xy == 0 ? 0 : Math.PI / 2 / xy);
		return this;
	}
	public function setSpotThreshold(threshold:Float):DotPixelArt {
		spotThreshold =  threshold;
		return this;
	}
	public function setDotScale(dotScale:Float = -1):DotPixelArt {
		if (dotScale < 0) dotSize = baseDotSize;
		else dotSize = Std.int(dotScale * baseDotSize);
		return this;
	}
	public function setOffset(x:Float = 0, y:Float = 0):DotPixelArt {
		offset.x = Std.int(x * pixelSize.x / dotSize);
		offset.y = Std.int(y * pixelSize.y / dotSize);
		return this;
	}
	public function fillRect(width:Float, height:Float = -1, edgeWidth:Int = 0):DotPixelArt {
		if (height < 0) height = width;
		return setRect(width, height, edgeWidth, false);
	}
	public function lineRect(width:Float, height:Float = -1, edgeWidth:Int = 1):DotPixelArt {
		if (height < 0) height = width;
		return setRect(width, height, edgeWidth, true);
	}
	public function generateRect(width:Float, height:Float = -1, seed:Int = -1):DotPixelArt {
		if (height < 0) height = width;
		var oc = new Color().setValue(color);
		setGeneratedColors(color, seed);
		fillRect(width, height, 1);
		setColor(oc).setColorBottom(oc.goDark()).setSpotInterval().lineRect(width, height);
		return this;
	}
	public function fillTrapezoid(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	edgeWidth:Int = 0):DotPixelArt {
		if (height < 0) height = width;
		return setTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, edgeWidth, false);
	}
	public function lineTrapezoid(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	edgeWidth:Int = 1):DotPixelArt {
		if (height < 0) height = width;
		return setTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, edgeWidth, true);
	}
	public function generateTrapezoid(width:Float, height:Float = -1,
	topFrom:Float = .5, topTo:Float = .5, bottomFrom:Float = 0, bottomTo:Float = 1,
	seed:Int = -1):DotPixelArt {
		if (height < 0) height = width;
		var oc = new Color().setValue(color);
		setGeneratedColors(color, seed);
		fillTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, 1);
		setColor(oc).setColorBottom(oc.goDark()).setSpotInterval()
			.lineTrapezoid(width, height, topFrom, topTo, bottomFrom, bottomTo, 1);
		return this;
	}
	public function fillCircle(diameter:Float, edgeWidth:Int = 0):DotPixelArt {
		return setCircle(diameter, edgeWidth, false);
	}
	public function lineCircle(diameter:Float, edgeWidth:Int = 1):DotPixelArt {
		return setCircle(diameter, edgeWidth, true);
	}
	public function generateCircle(diameter:Float, seed:Int = -1):DotPixelArt {
		var oc = new Color().setValue(color);
		setGeneratedColors(color, seed);
		fillCircle(diameter);
		setColor(oc).setColorBottom(oc.goDark()).setSpotInterval().lineCircle(diameter);
		return this;
	}
	public function generateShape(width:Float, height:Float = -1, seed:Int = -1,
	fillRatio:Float = 0.4, sideRatio:Float = 0.2, crossRatio:Float = 0.2):DotPixelArt {
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
		var nextPixels = new Array<Vector>();
		var oc = new Color().setValue(color);
		setGeneratedColors(color, seed);
		var r = new Random().setSeed(seed);
		for (i in 0...Std.int(w * h * fillRatio)) {
			for (j in 0...100) {
				if (nextPixels.length <= 0) nextPixels.push(Vector.i.xy(r.fi(1, w - 2), r.fi(1, h - 2)));
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
								if (!Lambda.exists(nextPixels, function(np) {
									return (np.xi == ix && np.yi == iy);
								})) {
									nextPixels.push(new Vector().setXy(ix, iy));
								}
							}
						}
					}
					break;
				}
			}
		}
		setColor(oc).setColorBottom(oc.goDark()).setSpotInterval();
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
	public function drawText(text:String):DotPixelArt {
		var l = new Letter();
		l.setDotSize();
		l.setText(text);
		l.alignCenter();
		l.alignVerticalCenter();
		l.draw(pixelFillRect);
		return this;
	}
	public function setPosition(pos:Vector):DotPixelArt {
		this.pos.v(pos);
		return this;
	}
	public function setXy(x:Float, y:Float):DotPixelArt {
		this.pos.xy(x, y);
		return this;
	}
	public function setZ(z:Float = 0):DotPixelArt {
		pz = z;
		return this;
	}
	public function rotate(angle:Float = 0):DotPixelArt {
		if (pixelWHRatio == 1.0) {
			this.angle = angle;
		} else {
			var a = angle * Math.PI / 180;
			aVec.setXy(a.sin() * pixelWHRatio, -a.cos());
			this.angle = aVec.way;
		}
		return this;
	}
	public function setScale(x:Float = 1, y:Float = 1):DotPixelArt {
		scaleX = x;
		scaleY = (y >= 0 ? y : x);
		return this;
	}
	function get_ed():DotPixelArt {
		isDotScale = true;
		return this;
	}
	function get_dd():DotPixelArt {
		isDotScale = false;
		return this;
	}
	function get_er():DotPixelArt {
		isRollingShape = true;
		return this;
	}
	public function setDrawColor(color:Color = null):DotPixelArt {
		drawColor = color;
		return this;
	}
	function get_d():DotPixelArt {
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
			if (angle != 0) rPos.rotate(angle);
			var px = Std.int(x + rPos.x) - rox;
			var py = Std.int(y + rPos.y) - roy;
			if (drawColor != null) Screen.pixelFillRect(px, py, pw, ph, drawColor);
			else Screen.pixelFillRect(px, py, pw, ph, d.color);
		}
		return this;
	}

	function setRect(width:Float, height:Float, edgeWidth:Int, isDrawingEdge:Bool = false):DotPixelArt {
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
	function setTrapezoid(width:Float, height:Float,
	topFrom:Float, topTo:Float, bottomFrom:Float, bottomTo:Float,
	edgeWidth:Int, isDrawingEdge:Bool = false):DotPixelArt {
		var w = Std.int(pixelSize.x * width / dotSize);
		var h = Std.int(pixelSize.y * height / dotSize);
		var ox = -Std.int(w / 2), oy = -Std.int(h / 2);
		var fx = topFrom * w;
		var tx = topTo * w;
		var vfx = (bottomFrom * w - fx) / (h - 1);
		var vtx = (bottomTo * w - tx) / (h - 1);
		for (y in 0...h) {
			var fxi = Std.int(fx);
			var txi = Std.int(tx);
			for (x in fxi...txi) {
				if (x < fxi + edgeWidth || x >= txi - edgeWidth ||
					y < edgeWidth || y >= h - edgeWidth) {
					if (isDrawingEdge) setDot(x + ox, y + oy, y / h);
				} else {
					if (!isDrawingEdge) setDot(x + ox, y + oy, y / h);
				}
			}
			fx += vfx;
			tx += vtx;
		}
		return this;
	}
	function setCircle(diameter:Float, edgeWidth:Int, isDrawingEdge:Bool):DotPixelArt {
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
	public function pixelFillRect(x:Int, y:Int, width:Int, height:Int, c:Color):Void {
		setDot(x, y, 0);
	}
	public function setDot(x:Int, y:Int, ry:Float):OffsetColor {
		var ca = (x * xSpotInterval).cos() * (y * ySpotInterval).cos() *
			((x + y) * xySpotInterval).cos();
		var c:Color;
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
	public function setGeneratedColors(color:Color, seed:Int):Void {
		if (seed < 0) seed = baseRandomSeed++;
		var r = new Random().setSeed(seed);
		var cbl = new Color().setValue(color);
		blinkColor(cbl, r);
		setColor(cbl).setColorBottom(cbl.goDark());
		blinkColor(cbl, r);
		setColorSpot(cbl).setColorBottomSpot(cbl.goDark());
		setSpotInterval(r.nextInt(3), r.nextInt(3), r.nextInt(3));
	}
	function blinkColor(c:Color, r:Random):Void {
		c.r += r.nextPlusMinusInt(64);
		c.g += r.nextPlusMinusInt(64);
		c.b += r.nextPlusMinusInt(64);
		c.normalize();
	}
}
class OffsetColor {
	public var offset:Vector;
	public var color:Color;
	public function new() {
		offset = new Vector();
	}
}