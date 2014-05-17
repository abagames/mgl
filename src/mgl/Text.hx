package mgl;
import mgl.Game.Screen;
using mgl.Util;
class Text {
	static public var i(get, null):Text; // instance
	public function tx(text:String):Text { return setText(text); }
	public function p(pos:Vector):Text { return setPosition(pos); }
	public function xy(x:Float, y:Float):Text { return setXy(x, y); }
	public function c(color:Color):Text { return setColor(color); }
	public function ds(dotScale:Float = -1):Text { return setDotScale(dotScale); }
	public function dc(color:Color, seed:Int = -1):Text { return decorate(color, seed); }
	public function alignLeft():Text { return get_al(); }
	public var al(get, null):Text; // align left
	public function alignCenter():Text { return get_ac(); }
	public var ac(get, null):Text; // align center
	public function alignRight():Text { return get_ar(); }
	public var ar(get, null):Text; // align right
	public function alignVerticalCenter():Text { return get_avc(); }
	public var avc(get, null):Text; // align vertical center
	public function v(vel:Vector):Text { return setVelocity(vel); }
	public function vxy(x:Float, y:Float):Text { return setVelocityXy(x, y); }
	public function t(ticks:Int = 60):Text { return setTicks(ticks); }
	public function setTickForever():Text { return get_tf(); }
	public var tf(get, null):Text; // set tick forever
	public function addOnce():Text { return get_ao(); }
	public var ao(get, null):Text; // add once
	public function remove():Bool { return get_r(); }
	public var r(get, null):Bool; // remove
	public function draw():Text { return get_d(); }
	public var d(get, null):Text; // draw

	public var tActor(get, null):Actor; // T actor
	public var ta(get, null):Actor; // T actor
	
	static var shownMessages:Array<String>;
	static public function initialize():Void {
		shownMessages = new Array<String>();
		Letter.initialize();
	}
	static public function setBaseDotSize():Void {
		Letter.setBaseDotSize();
	}
	var actor:TActor;
	var text:String;
	var isFirstTicks = true;
	public function new() {
		actor = new TActor();
	}
	static function get_i():Text {
		return new Text();
	}
	public function setText(text:String):Text {
		this.text = text;
		actor.letter.setText(text);
		return this;
	}
	public function setPosition(pos:Vector):Text {
		actor.p.v(pos);
		return this;
	}
	public function setXy(x:Float, y:Float):Text {
		actor.p.xy(x, y);
		return this;
	}
	public function setColor(color:Color):Text {
		actor.letter.setColor(color);
		return this;
	}
	public function setDotScale(dotScale:Float = -1):Text {
		actor.letter.setDotScale(dotScale);
		return this;
	}
	public function decorate(color:Color, seed:Int = -1):Text {
		actor.letter.decorate(color, seed);
		return this;
	}
	function get_al():Text {
		actor.letter.alignLeft();
		return this;
	}
	function get_ar():Text {
		actor.letter.alignRight();
		return this;
	}
	function get_ac():Text {
		actor.letter.alignCenter();
		return this;
	}
	function get_avc():Text {
		actor.letter.alignVerticalCenter();
		return this;
	}
	public function setVelocity(vel:Vector):Text {
		actor.v.v(vel);
		return this;
	}
	public function setVelocityXy(x:Float, y:Float):Text {
		actor.v.xy(x, y);
		return this;
	}
	public function setTicks(ticks:Int = 60):Text {
		actor.removeTicks = ticks;
		return this;
	}
	function get_tf():Text {
		actor.removeTicks = 9999999;
		return this;
	}
	function get_ao():Text {
		for (m in shownMessages) {
			if (m == text) {
				actor.r;
				return null;
			}
		}
		shownMessages.push(text);
		return this;
	}
	function get_r():Bool {
		return actor.remove();
	}
	function get_d():Text {
		actor.draw();
		actor.remove();
		return this;
	}
	function get_tActor():Actor {
		return actor;
	}
	function get_ta():Actor {
		return actor;
	}
}
class TActor extends Actor {
	override public function initialize() {
		dp(100);
	}
	public var removeTicks = 1;
	public var letter:Letter;
	var isFirstTicks = true;
	override public function begin() {
		letter = new Letter();
	}
	override public function update() {
		if (isFirstTicks) {
			p.s(v);
			v.d(removeTicks);
			isFirstTicks = false;
		}
		draw();
		if (ticks >= removeTicks) get_r();
	}
	public function draw() {
		letter.setPos(p);
		letter.drawToScreen();
	}
}
class Letter {
	static inline var COUNT = 66;
	static var pixelSize:Vector;
	static var baseDotSize = 1;
	static var dotPatterns:Array<Array<Vector>>;
	static var charToIndex:Array<Int>;
	static var decoratedLetterWidth = 3 * 4;
	static var decoratedLetterHeight = 2 * 5 + 4;
	static var decoratingDotPattern:Array<Array<Int>>;
	static public function initialize():Void {
		pixelSize = Game.pixelSize;
		dotPatterns = new Array<Array<Vector>>();
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
		var dots:Array<Vector>;
		for (i in 0...COUNT) {
			dots = new Array<Vector>();
			for (j in 0...5) {
				for (k in 0...4) {
					if (++d >= 32) {
						p = patterns[pIndex++];
						d = 0;
					}
					if (p & 1 > 0) dots.push(new Vector().xy(k, j));
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
		decoratingDotPattern = [[0, 1, 1], [1, 1, 1], [1, 1, 1]];
	}
	static public function setBaseDotSize():Void {
		baseDotSize = Std.int(Game.baseDotSize / 2).clampInt(1, 10);
	}
	var text:String;
	var pos:Vector;
	var align:LetterAlign;
	var isAlignVerticalCenter = false;
	var dotSize = 1;
	var color:Color;
	var isDecorated = false;
	var decoratingColor:Color;
	var decoratingSeed = 0;
	var decoratiedShape:DotPixelArt;
	public function new() {
		pos = new Vector();
		align = Left;
		dotSize = baseDotSize;
		color = Color.white;
	}
	public function setText(text:String):Void {
		this.text = text;
	}
	public function setPos(pos:Vector):Void {
		this.pos.v(pos);
	}
	public function decorate(color:Color, seed:Int):Void {
		isDecorated = true;
		decoratingColor = color;
		decoratingSeed = seed;
	}
	public function alignLeft():Void {
		align = Left;
	}
	public function alignRight():Void {
		align = Right;
	}
	public function alignCenter():Void {
		align = Center;
	}
	public function alignVerticalCenter():Void {
		isAlignVerticalCenter = true;
	}
	public function setColor(color:Color):Void {
		this.color = color;
	}
	public function setDotScale(dotScale:Float):Void {
		if (dotScale < 0) dotSize = baseDotSize;
		dotSize = Std.int(dotScale * baseDotSize);
	}
	public function setDotSize(dotSize:Int = 1):Void {
		this.dotSize = dotSize;
	}
	public function drawToScreen():Void {
		draw(Screen.pixelFillRect);
	}
	public function draw(df:Int -> Int -> Int -> Int -> Color -> Void):Void {
		if (isDecorated) {
			drawDecorated();
			return;
		}
		var tx = Std.int(pos.x * pixelSize.x);
		var ty = Std.int(pos.y * pixelSize.y);
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
	inline function drawDots(i:Int, x:Int, y:Int, df:Int -> Int -> Int -> Int -> Color -> Void):Void {
		for (p in dotPatterns[i]) {
			var px = x + p.xi * dotSize;
			var py = y + p.yi * dotSize;
			df(px, py, dotSize, dotSize, color);
		}
	}
	function drawDecorated():Void {
		if (decoratiedShape == null) setDecoratedShape();
		var x = pos.x;
		var y = pos.y;
		if (align == Center) {
			x -= decoratedLetterWidth * text.length * dotSize / pixelSize.xi;
		} else if (align == Right) {
			x -= decoratedLetterWidth * text.length * dotSize / pixelSize.xi * 2;
		}
		if (isAlignVerticalCenter) {
			y -= decoratedLetterHeight * dotSize / pixelSize.yi;
		}
		decoratiedShape.xy(x, y).draw();
	}
	function setDecoratedShape():Void {
		var dw = text.length * decoratedLetterWidth;
		var dh = decoratedLetterHeight;
		var dots = [for (x in 0...dw) [for (y in 0...dh) 0]];
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li = charToIndex[c];
			if (li < 0) continue;
			var dx = i * 3 * 4 + 2;
			var dy = 2;
			for (p in dotPatterns[li]) {
				setDots(dots, dx + p.xi * 2, dy + p.yi * 2);
			}
		}
		decoratiedShape = new DotPixelArt();
		decoratiedShape.setGeneratedColors(decoratingColor, decoratingSeed);
		for (x in 0...dw) {
			for (y in 0...dh) {
				if (dots[x][y] > 0) continue;
				for (ox in x - 1...x + 2) {
					for (oy in y - 1...y + 2) {
						if (checkDot(dots, ox, oy, dw, dh) == 1) dots[x][y] = 2;
					}
				}
			}
		}
		for (x in 0...dw) {
			for (y in 0...dh) {
				if (dots[x][y] <= 0) continue;
				var ry = if (dots[x][y] == 1) y / dh; else 0;
				decoratiedShape.setDot(x, y, ry);
			}
		}
	}
	function setDots(dots:Array<Array<Int>>, x:Int, y:Int):Void {
		for (ox in 0...3) {
			for (oy in 0...3) {
				if (decoratingDotPattern[oy][ox] == 0) continue;
				dots[x + ox][y + oy] = 1;
			}
		}
	}
	function checkDot(dots:Array<Array<Int>>, x:Int, y:Int, w:Int, h:Int):Int {
		if (x < 0 || x >= w || y < 0 || y >= h) return -1;
		return dots[x][y];
	}
}
enum LetterAlign {
	Left;
	Center;
	Right;
}