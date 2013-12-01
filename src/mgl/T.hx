package mgl;
import mgl.G.Screen;
class T { // Text
	static public var i(get, null):T; // instance
	public function tx(text:String):T { return setText(text); }
	public function p(pos:V):T { return setPos(pos); }
	public function xy(x:Float, y:Float):T { return setXy(x, y); }
	public function c(color:C):T { return setColor(color); }
	public function ds(dotScale:Float = -1):T { return setDotScale(dotScale); }	
	public var al(get, null):T; // align left
	public var ac(get, null):T; // align center
	public var ar(get, null):T; // align right
	public var avc(get, null):T; // align vertical center
	public function v(vel:V):T { return setVel(vel); }
	public function vxy(x:Float, y:Float):T { return setVelXy(x, y); }
	public function t(ticks:Int = 60):T { return setTicks(ticks); }
	public var tf(get, null):T; // tick forever
	public var ao(get, null):T; // add once
	public var r(get, null):Bool; // remove
	public var d(get, null):T; // draw

	public var ta(get, null):A; // T actor
	
	static var shownMessages:Array<String>;
	static public function initialize():Void {
		shownMessages = new Array<String>();
		Letter.initialize();
	}
	var actor:TActor;
	var text:String;
	var isFirstTicks = true;
	public function new() {
		actor = new TActor();
	}
	static function get_i():T {
		return new T();
	}
	function setText(text:String):T {
		this.text = text;
		actor.letter.setText(text);
		return this;
	}
	function setPos(pos:V):T {
		actor.p.v(pos);
		return this;
	}
	function setXy(x:Float, y:Float):T {
		actor.p.xy(x, y);
		return this;
	}
	function setColor(color:C):T {
		actor.letter.setColor(color);
		return this;
	}
	function setDotScale(dotScale:Float):T {
		actor.letter.setDotScale(dotScale);
		return this;
	}
	function get_al():T {
		actor.letter.alignLeft();
		return this;
	}
	function get_ar():T {
		actor.letter.alignRight();
		return this;
	}
	function get_ac():T {
		actor.letter.alignCenter();
		return this;
	}
	function get_avc():T {
		actor.letter.alignVerticalCenter();
		return this;
	}
	function setVel(vel:V):T {
		actor.v.v(vel);
		return this;
	}
	function setVelXy(x:Float, y:Float):T {
		actor.v.xy(x, y);
		return this;
	}
	function setTicks(ticks:Int):T {
		actor.removeTicks = ticks;
		return this;
	}
	function get_tf():T {
		actor.removeTicks = 9999999;
		return this;
	}
	function get_ao():T {
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
		return actor.r;
	}
	function get_d():T {
		actor.draw();
		actor.r;
		return this;
	}
	function get_ta():A {
		return actor;
	}
}
class TActor extends A {
	override public function i() {
		dp(100);
	}
	public var removeTicks = 1;
	public var letter:Letter;
	var isFirstTicks = true;
	override public function b() {
		letter = new Letter();
	}
	override public function u() {
		if (isFirstTicks) {
			v.d(removeTicks);
			isFirstTicks = false;
		}
		p.a(v);
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
	static var pixelSize:V;
	static var baseDotSize = 1;
	static var dotPatterns:Array<Array<V>>;
	static var charToIndex:Array<Int>;
	static public function initialize():Void {
		pixelSize = G.pixelSize;
		baseDotSize = U.ci(Std.int(G.baseDotSize / 2), 1, 10);
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
	var dotSize = 1;
	var color:C;
	public function new() {
		pos = new V();
		align = Left;
		dotSize = baseDotSize;
		color = C.wi;
	}
	public function setText(text:String):Void {
		this.text = text;
	}
	public function setPos(pos:V):Void {
		this.pos.v(pos);
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
	public function setColor(color:C):Void {
		this.color = color;
	}
	public function setDotScale(dotScale:Float):Void {
		if (dotScale < 0) dotSize = baseDotSize;
		dotSize = Std.int(dotScale * baseDotSize);
	}
	public function drawToScreen():Void {
		draw(Screen.pixelFillRect);
	}
	public function draw(df:Int -> Int -> Int -> Int -> C -> Void):Void {
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