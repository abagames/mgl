package mgl;
import flash.display.BitmapData;
import flash.display.ColorCorrection;
import flash.geom.Rectangle;
import flash.Lib;
class L { // Letter
	public var i(newInstance, null):L;
	public function t(text:String):L { return setText(text); }
	public function p(pos:V):L { return setPos(pos); }
	public function xy(x:Float, y:Float):L { return setXy(x, y); }
	public var al(alignLeft, null):L;
	public var ar(alignRight, null):L;
	public var ac(alignCenter, null):L;
	public function s(dotSize:Int):L { return setDotSize(dotSize); }
	public function c(color:C):L { return setColor(color); }
	public var d(draw, null):L;

	static inline var BASE_DOT_SIZE = 2;
	static inline var COUNT = 64;
	static var bd:BitmapData;
	static var dotPatterns:Array<Array<V>>;
	static var charToIndex:Array<Int>;
	static var rect:Rectangle;
	static var colorInstance:C;
	public static function initialize(game:G):Void {
		bd = game.bd;
		dotPatterns = new Array<Array<V>>();
		charToIndex = new Array<Int>();
		rect = new Rectangle();
		colorInstance = new C();
		var patterns = [
		0x4644AAA4, 0x6F2496E4, 0xF5646949, 0x167871F4, 0x2489F697, 0xE9669696, 0x79F99668,
		0x91967979, 0x1F799976, 0x1171FF17, 0xF99ED196, 0xEE444E99, 0x53592544, 0xF9F11119,
		0x9DDB9999, 0x79769996, 0x7ED99611, 0x861E9979, 0x994444E7, 0x46699699, 0x6996FD99,
		0xF4469999, 0x2224F248, 0x26244424, 0x64446622, 0x84284248, 0x40F0F024, 0xF0044E4,
		0x480A4E40, 0x9A459124, 0xA5A16, 0x640444F0, 0x80004049, 0x40400004, 0x44444040,
		0xA00004, 0x64E4E400, 0x45E461D9, 0x4424F424, 0x42F244E5, 
		];
		var p = 0, d = 32;
		var pIndex = 0;
		var dots:Array<V>;
		for (i in 0...COUNT) {
			dots = new Array<V>();
			for (j in 0...5) {
				for (k in 0...4) {
					if (++d >= 32) {
						p = patterns[pIndex++];
						d = 0;
					}
					if (p & 1 > 0) dots.push(new V().xy(k, j));
					p >>= 1;
				}
			}
			dotPatterns.push(dots);
		}
		var charCodes = [
		40, 41, 91, 93, 60, 62, 61, 43, 45, 42, 47, 37, 38, 95, 33, 63, 44, 46, 58, 124,
		39, 34, 36, 64, 117, 114, 100, 108];
		for (c in 0...128) {
			var li = -1;
			if (c >= 48 && c < 58) {
				li = c - 48;
			} else if (c >= 65 && c <= 90) {
				li = c - 65 + 10;
			} else {
				var lic = 36;
				for (cc in charCodes) {
					if (cc == c) {
						li = lic;
						break;
					}
					lic++;
				}
			}
			charToIndex.push(li);
		}
	}
	var text:String;
	var pos:V;
	var align:LetterAlign;
	var dotSize:Int;
	var color:C;
	public function new() {
		align = Center;
		dotSize = BASE_DOT_SIZE;
		color = colorInstance.wi;
		pos = new V();
	}
	function newInstance():L {
		return new L();
	}
	function setText(text:String):L {
		this.text = text;
		return this;
	}
	function setPos(pos:V):L {
		this.pos.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):L {
		pos.x = x;
		pos.y = y;
		return this;
	}
	function alignLeft():L {
		align = Left;
		return this;
	}
	function alignRight():L {
		align = Right;
		return this;
	}
	function alignCenter():L {
		align = Center;
		return this;
	}
	function setDotSize(dotSize:Int):L {
		this.dotSize = dotSize;
		return this;
	}
	function setColor(color:C):L {
		this.color = color;
		return this;
	}
	function draw():L {
		var tx = Std.int(pos.x * Lib.current.width), ty = Std.int(pos.y * Lib.current.height);
		var ci = color.i;
		var lw = dotSize * 5;
		switch (align) {
		case Left:
		case Center:
			tx -= Std.int(text.length * lw / 2);
		case Right:
			tx -= text.length * lw;
		}
		rect.width = rect.height = dotSize;
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li = charToIndex[c];
			if (li >= 0) drawDots(li, tx, ty, ci);
			tx += lw;
		}
		return this;
	}

	function drawDots(i:Int, x:Int, y:Int, ci:Int):Void {
		for (p in dotPatterns[i]) {
			rect.x = x + p.xi * dotSize;
			rect.y = y + p.yi * dotSize;
			bd.fillRect(rect, ci);
		}
	}
}
enum LetterAlign {
	Left;
	Center;
	Right;
}