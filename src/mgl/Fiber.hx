package mgl;
import haxe.macro.Expr;
class Fiber {
	static public var i(get, null):Fiber; // instance
	static public function ip(parent:Dynamic):Fiber { return new Fiber(parent); }
	static public function clear():Bool { return get_cl(); }
	static public var cl(get, null):Bool; // clear
	macro static public function doIt(f:Expr, block:Expr) {
		return macro $f.doBlock(function() { $block; });
	}
	macro static public function d(f:Expr, block:Expr) { // do
		return macro $f.doBlock(function() { $block; });
	}
	public function w(count:Float):Fiber { return wait(count); }
	public function aw(count:Float):Fiber { return addWait(count); }
	public function dw(count:Float):Fiber { return decrementWait(count); }
	public function disableAutoDecrement():Fiber { return get_dd(); }
	public var dd(get, null):Fiber; // disable auto decrement
	public function disableLoop():Fiber { return get_dl(); }
	public var dl(get, null):Fiber; // disable loop
	public function update():Fiber { return get_u(); }
	public var u(get, null):Fiber; // update
	public function loop():Fiber { return get_l(); }
	public var l(get, null):Fiber; // loop
	public function remove():Fiber { return get_r(); }
	public var r(get, null):Fiber; // remove
	public var count(get, null):Float;
	public var cn(get, null):Float; // count
	
	static var s:Array<Fiber>;
	static public function initialize():Void {
		get_cl();
	}
	static function get_i():Fiber {
		return new Fiber(null);
	}
	static function get_cl():Bool {
		s = new Array<Fiber>();
		return true;
	}
	static public function updateAll(fibers:Array<Fiber> = null):Void {
		if (fibers == null) fibers = s;
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
	var currentCount = 0.0;
	public function new(parent:Dynamic = null) {
		if (parent != null) parent.fs.push(this);
		else s.push(this);
	}
	function doBlock(block:Void -> Void):Fiber {
		this.block = block;
		return this;
	}
	public function wait(count:Float):Fiber {
		currentCount = defaultCount = count;
		return this;
	}
	public function addWait(count:Float):Fiber {
		currentCount += count;
		return this;
	}
	public function decrementWait(count:Float):Fiber {
		currentCount -= count;
		return this;
	}
	function get_dd():Fiber {
		isAutoDecrement = false;
		return this;
	}
	function get_dl():Fiber {
		isLooping = false;
		return this;
	}
	function get_u():Fiber {
		if (isRemoving) return this;
		if (isAutoDecrement) currentCount--;
		if (currentCount > 0) return this;
		if (isLooping) get_l();
		block();
		return this;
	}
	function get_l():Fiber {
		currentCount += defaultCount;
		return this;
	}
	function get_r():Fiber {
		isRemoving = true;
		return this;
	}
	function get_count():Float {
		return currentCount;
	}
	function get_cn():Float {
		return currentCount;
	}
}