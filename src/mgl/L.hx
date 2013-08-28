package mgl;
class L { // Letter
	static public var i(get, null):L; // instance
	public function tx(text:String):L { return setText(text); }
	public function p(pos:V):L { return setPos(pos); }
	public function xy(x:Float, y:Float):L { return setXy(x, y); }
	public var al(get, null):L; // align left
	public var ar(get, null):L; // align right
	public var ac(get, null):L; // align center
	public var avc(get, null):L; // align vertical center
	public function sz(dotSize:Int):L { return setDotSize(dotSize); }
	public function c(color:C):L { return setColor(color); }
	public var d(get, null):L; // draw

	static inline var COUNT = 66;
	static var baseDotSize = 1;
	static var pixelSize:V;
	static var dotPatterns:Array<Array<V>>;
	static var charToIndex:Array<Int>;
	public static function initialize():Void {
		pixelSize = B.pixelSize;
		baseDotSize = U.ci(Std.int(B.baseDotSize / 2), 1, 10);
		dotPatterns = new Array<Array<V>>();
		charToIndex = new Array<Int>();
		var patterns = [
		0x4644AAA4, 0x6F2496E4, 0xF5646949, 0x167871F4, 0x2489F697, 0xE9669696, 0x79F99668, 
		0x91967979, 0x1F799976, 0x1171FF17, 0xF99ED196, 0xEE444E99, 0x53592544, 0xF9F11119, 
		0x9DDB9999, 0x79769996, 0x7ED99611, 0x861E9979, 0x994444E7, 0x46699699, 0x6996FD99, 
		0xF4469999, 0x2224F248, 0x26244424, 0x64446622, 0x84284248, 0x40F0F024, 0xF0044E4, 
		0x480A4E40, 0x9A459124, 0xA5A16, 0x640444F0, 0x80004049, 0x40400004, 0x44444040, 
		0xAA00044, 0x6476E400, 0xFAFA61D9, 0xE44E4EAA, 0x24F42445, 0xF244E544, 0x42
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
		var charStr = "()[]<>=+-*/%&_!?,.:|'\"$@#\\urdl";
		var charCodes = new Array<Int>();
		for (i in 0...charStr.length) charCodes.push(charStr.charCodeAt(i));
		for (c in 0...128) {
			var li = -1;
			if (c == 32) {
			} else if (c >= 48 && c < 58) {
				li = c - 48;
			} else if (c >= 65 && c <= 90) {
				li = c - 65 + 10;
			} else {
				li = Lambda.indexOf(charCodes, c);
				if (li >= 0) li += 36;
				else li = -2;
			}
			charToIndex.push(li);
		}
	}
	var text:String;
	var pos:V;
	var align:LetterAlign;
	var isAlignVerticalCenter = false;
	var dotSize:Int;
	var color:C;
	public function new() {
		align = Center;
		dotSize = baseDotSize;
		color = C.wi;
		pos = new V();
	}
	static function get_i():L {
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
		pos.xy(x, y);
		return this;
	}
	function get_al():L {
		align = Left;
		return this;
	}
	function get_ar():L {
		align = Right;
		return this;
	}
	function get_ac():L {
		align = Center;
		return this;
	}
	function get_avc():L {
		isAlignVerticalCenter = true;
		return this;
	}
	function setDotSize(dotSize:Int):L {
		this.dotSize = dotSize * baseDotSize;
		return this;
	}
	function setColor(color:C):L {
		this.color = color;
		return this;
	}
	function get_d():L {
		draw(B.pixelFillRect);
		return this;
	}

	public function draw(df:Int -> Int -> Int -> Int -> C -> Void):Void {
		var tx = Std.int(pos.x * pixelSize.x), ty = Std.int(pos.y * pixelSize.y);
		var lw = dotSize * 5;
		switch (align) {
		case Left:
		case Center:
			tx -= Std.int(text.length * lw / 2);
		case Right:
			tx -= text.length * lw;
		}
		if (isAlignVerticalCenter) ty -= dotSize * 3;
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li = charToIndex[c];
			if (li >= 0) drawDots(li, tx, ty, df);
			else if (li == -2) throw "invalid char: " + text.charAt(i);
			tx += lw;
		}
	}
	inline function drawDots(i:Int, x:Int, y:Int, df:Int -> Int -> Int -> Int -> C -> Void):Void {
		for (p in dotPatterns[i]) {
			var px = x + p.xi * dotSize;
			var py = y + p.yi * dotSize;
			df(px, py, dotSize, dotSize, color);
		}
	}
}
enum LetterAlign {
	Left;
	Center;
	Right;
}