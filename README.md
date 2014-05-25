mgl (Mini Game programming Library)
======================
Mgl is a mini game programming library written in Haxe + OpenFL. Mgl is useful for creating a simple Flash game in short term. HTML5/Windows build targets are partially supported.

Using the [SiON](https://github.com/keim/SiON "SiON") synthesizer library.

Using the [as3gif](https://code.google.com/p/as3gif/ "as3gif") animated gif encoder.

####Sample games

[SCAFFOLD NOW](http://abagames.sakura.ne.jp/flash/sn/) /
[DON'T SEE ME](http://abagames.sakura.ne.jp/flash/dsm/) /
[MISSILE COMES BACK TO ME](http://abagames.sakura.ne.jp/flash/mcbtm/) /
[PROMINENT MOUNTAIN](http://abagames.sakura.ne.jp/flash/pm/) /
[BADDALION](http://abagames.sakura.ne.jp/flash/bd/) /
[SUM10](http://abagames.sakura.ne.jp/flash/st/) /
[WASD THRUST](http://abagames.sakura.ne.jp/flash/wt/) /
[LURE AWAY](http://abagames.sakura.ne.jp/flash/la/) /
[FROM FOUR SIDES](http://abagames.sakura.ne.jp/flash/ffs/) /
[PINCER ATTACK](http://abagames.sakura.ne.jp/flash/pa/) / 
[STRONG BUY STRONG SELL](http://abagames.sakura.ne.jp/flash/sbss/) /
[OVEREXPLODE](http://abagames.sakura.ne.jp/flash/oe/) /
[DETERMINISTIC PANELS](http://abagames.sakura.ne.jp/flash/dp/) /
[CUT OFF LINE AMEBA](http://abagames.sakura.ne.jp/flash/cola/) /
[EARTH DEFENSE STICKS](http://abagames.sakura.ne.jp/flash/eds/) /
[SIDE WALLS MULTI KICKS](http://abagames.sakura.ne.jp/flash/swmk/) /
[POLE SLIP DOWN](http://abagames.sakura.ne.jp/flash/psd/) /
[CALC +-*/](http://abagames.sakura.ne.jp/flash/cp/) /
[TYPHOON AVENUE](http://abagames.sakura.ne.jp/flash/ta/) /
[LEFT RIGHT HAND RULE](http://abagames.sakura.ne.jp/flash/lrh/) /
[REFLECTOR SATELLITES](http://abagames.sakura.ne.jp/flash/rs/) /
[BALLOON BURROWER](http://abagames.sakura.ne.jp/flash/bb/) /
[SATELLITE CATCH](http://abagames.sakura.ne.jp/flash/sc/) /
[POLAR NS](http://abagames.sakura.ne.jp/flash/pns/)

####Sample games (using the older version mgl)

[LONG EDGE WINS](http://abagames.sakura.ne.jp/flash/lew/) /
[REVGRAV](http://abagames.sakura.ne.jp/flash/rg/) /
[SPACE SHIPS CONTACT ACCIDENTAL](http://abagames.sakura.ne.jp/flash/ssca/) /
[YOU HAVE ONE SHOT](http://abagames.sakura.ne.jp/flash/yhos/) /
[SIDE SHOT BOOSTER](http://abagames.sakura.ne.jp/flash/ssb/) /
[MAGNETIC ACTION](http://abagames.sakura.ne.jp/flash/ma/)

###Advantages

* A basic game loop is automatically managed.
* You can do spawning, moving and removing the actor in an easy-to-write manner.
* Using a method chaining and a shortened name helps to write a logic with a one-liner.
* Since the dot pixel art and the sound effect are generated procedurally, you don't have to care about them.
* Many useful classes for particles, key handling, mouse handling, fiber, random, text, color and 2d vector.

### Limitations

* Not suitable for a large scale game because of lacking flexibility in handling a game loop.
* No 3d, neither external bitmaps nor sounds loading support.

###Sample code

[BALL 28 IN SPACE](http://abagames.sakura.ne.jp/flash/b2is/)

```haxe
import mgl.*;
using mgl.Fiber;
using mgl.Util;
// A basic game loop handling class.
class Main extends Game {
	static public function main() {
		new Main();
	}
	function new() {
		super(this);
	}
	var bgmDrumSound:Sound;
	var endGameSound:Sound;
	// initialize() --> Title -> begin() -> update()(every frame) -> Begin the game -v
	//                    ^    v-----------------------------------------------------<
	//                    ^  begin() -> update()(every frame) -> End the game -v
	//                    ^----------------------------------------------------<
	// First initializer.
	override function initialize() {
		Ball.main = this;
		// Apply quarter-note quantization.
		Sound.setDefaultQuant(4);
		// Generate sounds.
		bgmDrumSound = new Sound().setDrumMachine();
		endGameSound = new Sound().major().setMelody()
			.addTone(.3, 10, .7).addTone(.6, 10, .4).end();
		// Set the title.
		setTitle("BALL 28 IN SPACE");
	}
	public var ballLeft:Int;
	var nextBallCount:Int;
	var time:Int;
	// Begin the title/game.
	override function begin() {
		Ball.player = new Player();
		nextBallCount = 0;
		ballLeft = 28;
		time = 0;
		// Play the bgm.
		bgmDrumSound.play();
	}
	// Update every frame.
	override function update() {
		var sc = Std.int(time / 1000);
		var ms = '00${time % 1000}';
		ms = ms.substr(ms.length - 3);
		// Draw elapsed time at the upper right aligned right.
		new Text().setXy(.99, .01).alignRight().setText('TIME: $sc.$ms').draw();
		// If the game isn't begun then return.
		if (!Game.isInGame) return;
		time += 16;
		// Draw the number of left balls at the upper left.
		new Text().setXy(.01, .01).setText('LEFT: $ballLeft').draw();
		if (ballLeft <= 0) {
			// Play the game ending sound.
			endGameSound.play();
			// End the game.
			Game.endGame();
		// Get all ball actors and check a total of them.
		} else if (Actor.getActors("Ball").length <= 0) {
			nextBallCount++;
			for (i in 0...nextBallCount) new Ball();
		}
		// Instructions drawn only once.
		if (Game.ticks == 0) {
			new Text().setXy(.1, .1).setText("[urdl]: MOVE").setTicks(180).addOnce();
		}
		if (Game.ticks == 60) {
			new Text().setXy(.1, .15).setText("[Z]: BREAK").setTicks(180).addOnce();
		}
	}
}
// Player actor.
class Player extends Actor {
	static var tickSound:Sound;
	// Static initializer called only once.
	override function initialize() {
		// Generate the green shape.
		dotPixelArt = new DotPixelArt().setColor(Color.green).generateShape(.04, .05);
		// Set the hir rect.
		setHitRect(.04, .05);
		// Set the tick sound.
		tickSound = new Sound().minor().addTone(.5, 3, .3).end();
	}
	// Begin this actor.
	override function begin() {
		// Set the position to (.5, .5).
		position.setNumber(.5);
		// Create the fiber to play the tick sound every 30 frames.
		new Fiber(this).wait(30).doIt( { tickSound.play(); } );
	}
	// Update every frame.
	override function update() {
		// Get the joystick input and add to the velocity.
		velocity.add(Key.stick.multiply(.003)).multiply(Key.isButtonPressing ? .6 : .95);
		// Loop the position between -.05 and 1.05.
		position.setXy(position.x.loopRange(-.05, 1.05), position.y.loopRange(-.05, 1.05));
		// Set the way to the velocity way.
		way = v.way;
		// Add the reddish green particle from the position.
		new Particle().setPosition(position).setColor(Color.green.goRed())
			.setWay(way + 180, 45).setSpeed(velocity.length).add();
		// Check the hit to the Ball actors.
		isHit("Ball", function(ball) {
			// If the player hit the ball, erase the ball.
			ball.erase();
		});
	}
}
// Ball actor.
class Ball extends Actor {
	static public var main:Main;
	static public var player:Player;
	static var removeSound:Sound;
	override function initialize() {
		// Set the circle yellow shape.
		dotPixelArt = new DotPixelArt().setColor(Color.yellow).generateCircle(.04);
		setHitRect(.04);
		// Set the removing sound.
		removeSound = new Sound().minor().addTone(.7).addRest().addTone(.7).end();
	}
	override function begin() {
		for (i in 0...10) {
			// Set the random position from .1 to .9.
			position.setXy(.1.randomFromTo(.9), .1.randomFromTo(.9));
			// If the distance to the player is far enough then break.
			if (position.distanceTo(player.position) > .3) break;
		}
	}
	public function erase() {
		// Add 20 particles.
		new Particle().setPosition(position).setColor(Color.yellow.goRed())
			.setCount(20).setSize(.03).add();
		main.ballLeft--;
		// Play the removing sound.
		removeSound.play();
		// Remove this actor.
		remove();
	}
}
```

###Classes

A shortened form of a class/method name is described in ( ).

###Game (G)

A basic game loop handler. You have to override the initialize(), begin() and update() method.

##### Methods
* (static)isInGame():Bool (ig)
* (static)endGame():Bool (eg)
* (static)ticks:Int (t)
* (static)fillRect(x:Float, y:Float, width:Float, height:Float, color:C):Void (fr)
* (static)drawToForeground():Bool (df)
* (static)drawToBackground():Bool (db)
* setTitle(title:String, title2:String = ""):Game (tt)
* setVersion(version:Int = 1):Game (vr)
* decorateTitle(color:Color, seed:Int = -1):Game (dt)
* enableDebuggingMode():Game (dm)
* enableCaptureMode(scale:Float = 1, fromSec:Float = 5, toSec:Float = 8, intervalSec:Float = .1):Game (cm)
* setYRatio(ratio:Float):Game (yr)
* initializeEnd():Game (ie)

##### Overriden methods
* initialize():Void
* begin():Void
* update():Void
* updateBackground():Void
* initializeState():Void
* loadState(d:Dynamic):Void
* saveState(d:Dynamic):Void

####Actor (A)

An actor moves on a screen. An actor has a position, a velocity and a dot pixel art.

##### Variables
* position:Vector (p)
* z:Float = 0
* velocity:Vector (v)
* way:Float = 0 (w)
* speed:Float = 0 (s)
* dotPixelArt:DotPixelArt (d)

##### Methods
* (static)getActors(className:String):Array<Dynamic> (acs)
* (static)clearActors():Bool (cl)
* (static)clearSpecificActors(className:String):Void (cls)
* (static)scroll(className:String, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0,
	minY:Float = 0, maxY:Float = 0):Void (sc)
* (static)scrollActors(classNames:Array<String>, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0,
	minY:Float = 0, maxY:Float = 0):Void (scs)
* ticks:Int (t)
* remove():Bool (r)
* setHitRect(width:Float = -999, height:Float = -1):Actor (hr)
* setHitCircle(diameter:Float = -999):Actor (hc)
* isHit(className:String, onHit:Dynamic -> Void = null):Bool (ih)
* setDisplayPriority(priority:Int):Actor (dp)
* drawToForeground():Actor (df)
* drawToBackground():Actor (bf)
* sortByZ():Actor (sz)

##### Overriden methods
* initialize():Void
* begin():Void
* update():Void

###DotPixelArt (D)

A pixel art for an actor. You can write a rectangle, a circle and an auto generated shape.

##### Methods
* new():DotPixelArt (i)
* setColor(color:C):DotPixelArt (c)
* setColorSpot(color:C):DotPixelArt (cs)
* setColorBottom(color:C):DotPixelArt (cb)
* setColorBottomSpot(color:C):DotPixelArt (cbs)
* setSpotInterval(x:Float = 0, y:Float = 0, xy:Float = 0):DotPixelArt (si)
* setSpotThreshold(threshold:Float):DotPixelArt (st)
* setDotScale(dotScale:Int):DotPixelArt (ds)
* setOffset(x:Float = 0, y:Float = 0):DotPixelArt (o)
* fillRectangle(width:Float, height:Float, edgeWidth:Int = 0):DotPixelArt (fr)
* lineRectangle(width:Float, height:Float, edgeWidth:Int = 1):DotPixelArt (lr)
* generateRectangle(width:Float, height:Float, seed:Int = -1):DotPixelArt (gr)
* fillCircle(diameter:Float, edgeWidth:Int = 0):DotPixelArt (fc)
* lineCircle(diameter:Float, edgeWidth:Int = 1):DotPixelArt (lc)
* generateCircle(diameter:Float, seed:Int = -1):DotPixelArt (gc)
* generateShape(width:Float, height:Float = -1, seed:Int = -1):DotPixelArt (gs)
* setPosition(pos:V):DotPixelArt (p)
* setXy(x:Float, y:Float):DotPixelArt (xy)
* setZ(z:Float = 0):DotPixelArt (z)
* rotate(angle:Float = 0):DotPixelArt (rt)
* setScale(x:Float = 1, y:Float = -1):DotPixelArt (sc)
* enableDotScale():DotPixelArt (ed)
* disableDotScale():DotPixelArt (dd)
* enableRollingShape():DotPixelArt (er)
* setDrawColor(color:C = null):DotPixelArt (dc)
* draw():DotPixelArt (d)

###Sound (S)

A 8-bit era style sound effect.

##### Methods
* new():Sound (i)
* (static)fadeIn(second:Float = 1):Void (fi)
* (static)fadeOut(second:Float = 1):Void (fo)
* (static)stop:Bool (s)
* (static)setDefaultQuant(v:Int = 0):Void (dq)
* (static)setBpm(v:Float = 120):Void (b)
* major():Sound (mj)
* minor():Sound (mn)
* noise():Sound (n)
* noiseScale():Sound (ns)
* addTone(from:Float, time:Int = 1, to:Float = 0):Sound (t)
* setWave(width:Float = 0, interval:Float = 0):Sound (w)
* setMelody(maxLength:Int = 3, step:Int = 1, randomSeed:Int = -1):Sound (m)
* setMinMax(min:Float = -1, max:Float = 1):Sound (mm)
* addRest(v:Int = 0):Sound (r)
* setRepeat(v:Int = 1):Sound (rp)
* setRepeatRest(v:Int = 0):Sound (rr)
* setLength(v:Int = 64):Sound (l)
* setVolume(v:Float = 1):Sound (v)
* setQuant(v:Int = 0):Sound (q)
* setLoop():Sound (lp)
* end():Sound (e)
* setDrumMachine(seed:Int = -1,
	bassPattern:Int = -1, snarePattern:Int = -1, hihatPattern:Int = -1,
	bassVoice:Int = -1, snareVoice:Int = -1, hihatVoice:Int = -1):Sound (dm)
* play():Sound (p)

####Particle (P)

Particles splashed from a specified position.

##### Methods
* new():Particle (i)
* (static)scroll(className:String, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0,
	minY:Float = 0, maxY:Float = 0):Void (sc)
* setPosition(pos:V):Particle (p)
* setXy(x:Float, y:Float):Particle (xy)
* setZ(z:Float = 0):Particle (z)
* setColor(color:C):Particle (c)
* setCount(count:Int):Particle (cn)
* setSize(size:Float):Particle (sz)
* setSpeed(speed:Float):Particle (s)
* setTicks(ticks:Float):Particle (t)
* setWay(angle:Float, angleWidth:Float = 0):Particle (w)
* add():Particle (a)

####Text (T)

Showing a text on a screen in a certain duration ticks.

##### Methods
* new():Text (i)
* setText(text:String):Text (tx)
* setPosition(pos:V):Text (p)
* setXy(x:Float, y:Float):Text (xy)
* setColor(color:C):Text (c)
* setDotScale(dotScale:Float = -1):Text (ds)
* decorate(color:Color, seed:Int = -1):Text (dc)
* alignLeft():Text (al)
* alignRight():Text (ar)
* alignCenter():Text (ac)
* alignVerticalCenter():Text (avc)
* setVelocity(vel:V):Text (v)
* setVelocityXy(x:Float, y:Float):Text (vxy)
* setTicks(ticks:Int):Text (t)
* tickForever():Text (tf)
* addOnce():Text (ao)
* remove():Bool (r)
* draw():Text (d)

####Random (R)

Random number generator.

##### Methods
* new():Random (i)
* next(v:Float = 1, s:Float = 0):Float (n)
* nextInt(v:Int, s:Int = 0):Int (ni)
* nextFromTo(from:Float to:Float):Float (f)
* nextFromToInt(from:Float to:Float):Int (fi)
* nextPlusOrMinus:Int (pm)
* nextPlusMinus(v:Float = 1):Float (p)
* nextPlusMinusInt(v:Int):Int (pi)
* setSeed(v:Int = -0x7fffffff):Random (s)
* setDifficultyBasisStage(stage:Int):Random (bst)
* setStage(stage:Int, seedOffset:Int = 0):Random (st)
* nextDifficultyCorrected:Float (dc)

####Fiber (F)

Set the do block and the block runs constantly for a specified wait ticks.

##### Methods
* new(parent:Dynamic = null):Fiber (i, ip)
* (static)clear():Bool (cl)
* doIt(block:Expr):Fiber (d)
* wait(count:Float):Fiber (w)
* addWait(count:Float):Fiber (aw)
* decrementWait(count:Float):Fiber (dw)
* disableAutoDecrement():Fiber (dd)
* disableLoop():Fiber (dl)
* update():Fiber (u)
* loop():Fiber (l)
* remove():Fiber (r)
* count:Float (cn)

####Color (C)

RGB color.

##### Variables
* r:Int
* g:Int
* b:Int

##### Methods
* (static)transparent:Color (ti)
* (static)black:Color
* (static)dark:Color (di)
* (static)red:Color (ri)
* (static)green:Color (gi)
* (static)blue:Color (bi)
* (static)yellow:Color (yi)
* (static)magenta:Color (mi)
* (static)cyan:Color (ci)
* (static)white:Color (wi)
* int:Int (i)
* setValue(v:C):Color (v)
* goDark():Color (gd)
* goWhite():Color (gw)
* goRed():Color (gr)
* goGreen():Color (gg)
* goBlue():Color (gb)
* goBlink():Color (gbl)
* blend(color:C, ratio:Float):Color (bl)

####Key (K)

Key and joystick input status.

##### Variables
* (static)pressingKeys:Array<Bool> (s)

##### Methods
* (static)isUpPressing:Bool (iu)
* (static)isDownPressing:Bool (id)
* (static)isRightPressing:Bool (ir)
* (static)isLeftPressing:Bool (il)
* (static)isButtonPressing:Bool (ib)
* (static)isButton1Pressing:Bool (ib1)
* (static)isButton2Pressing:Bool (ib2)
* (static)isPressedUp:Bool (ipu)
* (static)isPressedDown:Bool (ipd)
* (static)isPressedRight:Bool (ipr)
* (static)isPressedLeft:Bool (ipl)
* (static)isPressedButton:Bool (ipb)
* (static)isPressedButton1:Bool (ipb1)
* (static)isPressedButton2:Bool (ipb2)
* (static)stick:Vector (st)

####Mouse (M)

Mouse input status.

##### Variables
* (static)position:Vector (p)
* (static)isButtonPressing:Bool (ip)
* (static)isPressedButton:Bool (ipb)

####Vector (V)

2D vector.

##### Variables
* x:Float = 0
* y:Float = 0

##### Methods
* new():Vector (i)
* setXy(x:Float = 0, y:Float = 0):Vector (xy)
* setNumber(n:Float = 0):Vector (n)
* setValue(v:V):Vector (v)
* length:Float (l)
* way:Float (w)
* xInt:Int (xi)
* yInt:Int (yi)
* distanceTo(pos:V):Float (dt)
* distanceToDistorted(pos:V, pixelWHRatio:Float = -1):Float (dtd)
* wayTo(pos:V):Float (wt)
* wayToDistorted(pos:V, pixelWHRatio:Float = -1):Float (wtd)
* add(v:V):Vector (a)
* sub(v:V):Vector (s)
* multiply(v:Float):Vector (m)
* divide(v:Float):Vector (d)
* addWay(angle:Float, speed:Float):Vector (aw)
* rotate(angle:Float):Vector (rt)
* isIn(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool (ii)

####Util (U)

Utility methods.

##### Methods
* (static)clamp(v:Float, min:Float = 0.0, max:Float = 1.0):Float (c)
* (static)clampInt(v:Int, min:Int, max:Int):Int (ci)
* (static)normalizeWay(v:Float):Float (nw)
* (static)aimWay(v:Float, targetAngle:Float, angleVel:Float):Float (aw)
* (static)loopRange(v:Float, min:Float, max:Float):Float (lr)
* (static)loopRangeInt(v:Int, min:Int, max:Int):Int (lri)
* (static)random(v:Float = 1, s:Float = 0):Float (rn)
* (static)randomInt(v:Int, s:Int = 0):Int (rni)
* (static)randomFromTo(from:Float, to:Float):Float (rf)
* (static)randomFromToInt(from:Int, to:Int):Int (rfi)
* (static)randomPlusMinus(v:Float = 1):Float (rp)
* (static)randomPlusMinusInt(v:Int):Int (rpi)
* (static)randomPlusOrMinus():Int (rpm)
* (static)getClassHash(o:Dynamic):Int (ch)

License
----------
Copyright &copy; 2013-2014 ABA Games

Distributed under the [MIT License][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php
