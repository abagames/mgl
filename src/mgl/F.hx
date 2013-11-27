package mgl;
import haxe.macro.Expr;
class F { // Fiber
	static public var i(get, null):F; // instance
	static public function ip(parent:Dynamic):F { return new F(parent); }
	static public var cl(get, null):Bool; // clear
	macro static public function d(f:Expr, block:Expr) { // do
		return macro $f.doBlock(function() { $block; });
	}
	public function w(count:Float):F { return wait(count); }
	public function dw(count:Float):F { return decrementWait(count); }
	public var dd(get, null):F; // disable auto decrement
	public var dl(get, null):F; // disable loop
	public var u(get, null):F; // update
	public var l(get, null):F; // loop
	public var r(get, null):F; // remove
	public var cn(get, null):Float; // count
	
	static var s:Array<F>;
	static public function initialize():Void {
		get_cl();
	}
	static function get_i():F {
		return new F(null);
	}
	static function get_cl():Bool {
		s = new Array<F>();
		return true;
	}
	static public function update():Void {
		updateAll(s);
	}
	static public function updateAll(fibers:Array<F>):Void {
		var i = 0;
		while (i < fibers.length) {
			if (fibers[i].isRemoving) {
				fibers.splice(i, 1);
			} else {
				fibers[i].u;
				i++;
			}
		}		
	}
	public var isRemoving = false;
	var block:Void -> Void;
	var isAutoDecrement = true;
	var isLooping = true;
	var defaultCount = 0.0;
	var count = 0.0;
	function new(parent:Dynamic) {
		if (parent != null) parent.fs.push(this);
		else s.push(this);
	}
	function doBlock(block:Void -> Void):F {
		this.block = block;
		return this;
	}
	function wait(count:Float):F {
		this.count = defaultCount = count;
		return this;
	}
	function decrementWait(dc:Float):F {
		count -= dc;
		return this;
	}
	function get_dd():F {
		isAutoDecrement = false;
		return this;
	}
	function get_dl():F {
		isLooping = false;
		return this;
	}
	function get_u():F {
		if (isRemoving) return this;
		if (isAutoDecrement) count--;
		if (count > 0) return this;
		if (isLooping) l;
		block();
		return this;
	}
	function get_l():F {
		count = defaultCount;
		return this;
	}
	function get_r():F {
		isRemoving = true;
		return this;
	}
	function get_cn():Float {
		return count;
	}
}