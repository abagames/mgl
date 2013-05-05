package mgl;
class C { // Color
	public var ti(transparentInstance, null):C;
	public var di(darkBlackInstance, null):C;
	public var ri(redInstance, null):C;
	public var gi(greenInstance, null):C;
	public var bi(blueInstance, null):C;
	public var yi(yellowInstance, null):C;
	public var mi(magentaInstance, null):C;
	public var ci(cyanInstance, null):C;
	public var wi(whiteInstance, null):C;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var i(getIntegerValue, null):Int;
	public function v(v:C):C { return setValue(v); }
	public var gd(goDark, null):C;
	public var gw(goWhite, null):C;
	public var gr(goRed, null):C;
	public var gg(goGreen, null):C;
	public var gb(goBlue, null):C;
	public var gbl(getBlink, null):C;
	public function bl(color:C, ratio:Float):C { return blend(color, ratio); }

	static inline var LEVEL_VALUE = 80;
	static inline var MAX_VALUE = 250;
	static inline var WHITENESS = 0;
	static var random:R;
	static var u:U;
	public static function initialize():Void {
		random = new R();
		u = new U();
	}
	var blinkColor:C;
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
	function transparentInstance():C { return new C(-1); }
	function darkBlackInstance():C { return new C(0, 0, 0); }
	function redInstance():C { return new C(MAX_VALUE, WHITENESS, WHITENESS); }
	function greenInstance():C { return new C(WHITENESS, MAX_VALUE, WHITENESS); }
	function blueInstance():C { return new C(WHITENESS, WHITENESS, MAX_VALUE); }
	function yellowInstance():C { return new C(MAX_VALUE, MAX_VALUE, WHITENESS); }
	function magentaInstance():C { return new C(MAX_VALUE, WHITENESS, MAX_VALUE); }
	function cyanInstance():C { return new C(WHITENESS, MAX_VALUE, MAX_VALUE); }
	function whiteInstance():C { return new C(MAX_VALUE, MAX_VALUE, MAX_VALUE); }
	function getIntegerValue():Int {
		return 0xff000000 + r * 0x10000 + g * 0x100 + b;
	}
	function setValue(c:C):C {
		r = c.r;
		g = c.g;
		b = c.b;
		return this;
	}
	function goWhite():C {
		return changeValue(LEVEL_VALUE, LEVEL_VALUE, LEVEL_VALUE);
	}
	function goDark():C {
		return changeValue(-LEVEL_VALUE, -LEVEL_VALUE, -LEVEL_VALUE);
	}
	function goRed():C {
		return changeValue(LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2));
	}
	function goGreen():C {
		return changeValue(Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE, Std.int(-LEVEL_VALUE / 2));
	}
	function goBlue():C {
		return changeValue(Std.int(-LEVEL_VALUE / 2), Std.int(-LEVEL_VALUE / 2), LEVEL_VALUE);
	}
	function getBlink():C {
		if (blinkColor == null) blinkColor = new C();
		changeValueColor(blinkColor, 
			random.i(128, -64), random.i(128, -64), random.i(128, -64));
		return blinkColor;
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
		color.r += rv; color.g += gv; color.b += bv;
		color.normalize();
	}
	function normalize():Void {
		r = u.ci(r, 0, MAX_VALUE);
		g = u.ci(g, 0, MAX_VALUE);
		b = u.ci(b, 0, MAX_VALUE);
	}
}