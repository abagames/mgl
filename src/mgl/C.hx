package mgl;
using mgl.U;
class C { // Color
	static public var ti(get, null):C; // transparent instance
	static public var di(get, null):C; // dark (black) instance
	static public var ri(get, null):C; // red instance
	static public var gi(get, null):C; // green instance
	static public var bi(get, null):C; // blue instance
	static public var yi(get, null):C; // yellow instance
	static public var mi(get, null):C; // magenta instance
	static public var ci(get, null):C; // cyan instance
	static public var wi(get, null):C; // white instance
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var i(get, null):Int; // integer value
	public function v(v:C):C { return setValue(v); }
	public var gd(get, null):C; // go dark
	public var gw(get, null):C; // go white
	public var gr(get, null):C; // go red
	public var gg(get, null):C; // go green
	public var gb(get, null):C; // go blue
	public var gbl(get, null):C; // go blink
	public function bl(color:C, ratio:Float):C { return blend(color, ratio); }

	static inline var LEVEL_VALUE = 80;
	static inline var MAX_VALUE = 240;
	static inline var WHITENESS = 0;
	static var random:R;
	static var blinkColor:C;
	public static function initialize():Void {
		random = new R();
		blinkColor = new C();
	}
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
	public function getBlinkColor():C {
		changeValueColor(blinkColor, random.pi(64), random.pi(64), random.pi(64));
		return blinkColor;
	}
	static function get_ti():C { return new C(-1); }
	static function get_di():C { return new C(0, 0, 0); }
	static function get_ri():C { return new C(MAX_VALUE, WHITENESS, WHITENESS); }
	static function get_gi():C { return new C(WHITENESS, MAX_VALUE, WHITENESS); }
	static function get_bi():C { return new C(WHITENESS, WHITENESS, MAX_VALUE); }
	static function get_yi():C { return new C(MAX_VALUE, MAX_VALUE, WHITENESS); }
	static function get_mi():C { return new C(MAX_VALUE, WHITENESS, MAX_VALUE); }
	static function get_ci():C { return new C(WHITENESS, MAX_VALUE, MAX_VALUE); }
	static function get_wi():C { return new C(MAX_VALUE, MAX_VALUE, MAX_VALUE); }
	function get_i():Int {
		return 0xff000000 + r * 0x10000 + g * 0x100 + b;
	}
	function setValue(c:C):C {
		r = c.r;
		g = c.g;
		b = c.b;
		return this;
	}
	function get_gw():C {
		return changeValue(LEVEL_VALUE, LEVEL_VALUE, LEVEL_VALUE);
	}
	function get_gd():C {
		return changeValue(-LEVEL_VALUE, -LEVEL_VALUE, -LEVEL_VALUE);
	}
	function get_gr():C {
		return changeValue(LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2));
	}
	function get_gg():C {
		return changeValue(Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2));
	}
	function get_gb():C {
		return changeValue(Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE);
	}
	function get_gbl():C {
		return changeValue(random.pi(64), random.pi(64), random.pi(64));
	}
	function blend(c:C, ratio:Float):C {
		return changeValue(
			Std.int((c.r - r) * ratio),
			Std.int((c.g - g) * ratio),
			Std.int((c.b - b) * ratio));
	}

	function changeValue(rv:Int, gv:Int, bv:Int):C {
		var changedColor = new C();
		changeValueColor(changedColor, rv, gv, bv);
		return changedColor;
	}
	function changeValueColor(color:C, rv:Int, gv:Int, bv:Int):Void {
		color.v(this);
		color.r += rv;
		color.g += gv;
		color.b += bv;
		color.normalize();
	}
	public function normalize():Void {
		r = r.ci(0, 255);
		g = g.ci(0, 255);
		b = b.ci(0, 255);
	}
}