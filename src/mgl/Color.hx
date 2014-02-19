package mgl;
using mgl.Util;
class Color {
	static public var transparent(get, null):Color;
	static public var ti(get, null):Color; // transparent instance
	static public var black(get, null):Color;
	static public var dark(get, null):Color;
	static public var di(get, null):Color; // dark (black) instance
	static public var red(get, null):Color;
	static public var ri(get, null):Color; // red instance
	static public var green(get, null):Color;
	static public var gi(get, null):Color; // green instance
	static public var blue(get, null):Color;
	static public var bi(get, null):Color; // blue instance
	static public var yellow(get, null):Color;
	static public var yi(get, null):Color; // yellow instance
	static public var magenta(get, null):Color;
	static public var mi(get, null):Color; // magenta instance
	static public var cyan(get, null):Color;
	static public var ci(get, null):Color; // cyan instance
	static public var white(get, null):Color;
	static public var wi(get, null):Color; // white instance
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var int(get, null):Int;
	public var i(get, null):Int; // integer value
	public function v(v:Color):Color { return setValue(v); }
	public function goDark():Color { return get_gd(); }
	public var gd(get, null):Color; // go dark
	public function goWhite():Color { return get_gw(); }
	public var gw(get, null):Color; // go white
	public function goRed():Color { return get_gr(); }
	public var gr(get, null):Color; // go red
	public function goGreen():Color { return get_gg(); }
	public var gg(get, null):Color; // go green
	public function goBlue():Color { return get_gb(); }
	public var gb(get, null):Color; // go blue
	public function goBlink():Color { return get_gbl(); }
	public var gbl(get, null):Color; // go blink
	public function bl(color:Color, ratio:Float):Color { return blend(color, ratio); }

	static inline var LEVEL_VALUE = 80;
	static inline var MAX_VALUE = 240;
	static inline var WHITENESS = 0;
	static var random:Random;
	static var blinkColor:Color;
	static public function initialize():Void {
		random = new Random();
		blinkColor = new Color();
	}
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
	public function getBlinkColor():Color {
		changeValueColor(blinkColor, random.pi(64), random.pi(64), random.pi(64));
		return blinkColor;
	}
	static function get_transparent():Color { return new Color(-1); }
	static function get_ti():Color { return new Color(-1); }
	static function get_black():Color { return new Color(0, 0, 0); }
	static function get_dark():Color { return new Color(0, 0, 0); }
	static function get_di():Color { return new Color(0, 0, 0); }
	static function get_red():Color { return new Color(MAX_VALUE, WHITENESS, WHITENESS); }
	static function get_ri():Color { return new Color(MAX_VALUE, WHITENESS, WHITENESS); }
	static function get_green():Color { return new Color(WHITENESS, MAX_VALUE, WHITENESS); }
	static function get_gi():Color { return new Color(WHITENESS, MAX_VALUE, WHITENESS); }
	static function get_blue():Color { return new Color(WHITENESS, WHITENESS, MAX_VALUE); }
	static function get_bi():Color { return new Color(WHITENESS, WHITENESS, MAX_VALUE); }
	static function get_yellow():Color { return new Color(MAX_VALUE, MAX_VALUE, WHITENESS); }
	static function get_yi():Color { return new Color(MAX_VALUE, MAX_VALUE, WHITENESS); }
	static function get_magenta():Color { return new Color(MAX_VALUE, WHITENESS, MAX_VALUE); }
	static function get_mi():Color { return new Color(MAX_VALUE, WHITENESS, MAX_VALUE); }
	static function get_cyan():Color { return new Color(WHITENESS, MAX_VALUE, MAX_VALUE); }
	static function get_ci():Color { return new Color(WHITENESS, MAX_VALUE, MAX_VALUE); }
	static function get_white():Color { return new Color(MAX_VALUE, MAX_VALUE, MAX_VALUE); }
	static function get_wi():Color { return new Color(MAX_VALUE, MAX_VALUE, MAX_VALUE); }
	inline function get_int():Int { return get_i(); }
	inline function get_i():Int {
		return 0xff000000 + r * 0x10000 + g * 0x100 + b;
	}
	public function setValue(c:Color):Color {
		r = c.r;
		g = c.g;
		b = c.b;
		return this;
	}
	function get_gw():Color {
		return changeValue(LEVEL_VALUE, LEVEL_VALUE, LEVEL_VALUE);
	}
	function get_gd():Color {
		return changeValue(-LEVEL_VALUE, -LEVEL_VALUE, -LEVEL_VALUE);
	}
	function get_gr():Color {
		return changeValue(LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2));
	}
	function get_gg():Color {
		return changeValue(Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2));
	}
	function get_gb():Color {
		return changeValue(Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE);
	}
	function get_gbl():Color {
		return changeValue(random.pi(64), random.pi(64), random.pi(64));
	}
	public function blend(c:Color, ratio:Float):Color {
		return changeValue(
			Std.int((c.r - r) * ratio),
			Std.int((c.g - g) * ratio),
			Std.int((c.b - b) * ratio));
	}

	function changeValue(rv:Int, gv:Int, bv:Int):Color {
		var changedColor = new Color();
		changeValueColor(changedColor, rv, gv, bv);
		return changedColor;
	}
	function changeValueColor(color:Color, rv:Int, gv:Int, bv:Int):Void {
		color.v(this);
		color.r += rv;
		color.g += gv;
		color.b += bv;
		color.normalize();
	}
	public function normalize():Void {
		r = r.clampInt(0, 255);
		g = g.clampInt(0, 255);
		b = b.clampInt(0, 255);
	}
}