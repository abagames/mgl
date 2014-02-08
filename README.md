mgl (Mini Game programming Library)
======================
Mgl is a mini game programming library written in Haxe + OpenFL. Mgl is useful for creating a simple Flash game in short term. HTML5/Windows build targets are partially supported.

Using the [SiON](https://github.com/keim/SiON "SiON") synthesizer library.

####Sample game

[LEFT RIGHT HAND RULE](http://abagames.sakura.ne.jp/flash/lrh/)

[REFLECTOR SATELLITES](http://abagames.sakura.ne.jp/flash/rs/)

[SCAFFOLD NOW](http://abagames.sakura.ne.jp/flash/sn/)

[BALLOON BURROWER](http://abagames.sakura.ne.jp/flash/bb/)

[SATELLITE CATCH](http://abagames.sakura.ne.jp/flash/sc/)

[POLAR NS](http://abagames.sakura.ne.jp/flash/pns/)

[WASD THRUST](http://abagames.sakura.ne.jp/flash/wt/)

####Sample game (using the older version mgl)

[LONG EDGE WINS](http://abagames.sakura.ne.jp/flash/lew/)

[REVGRAV](http://abagames.sakura.ne.jp/flash/rg/)

[SPACE SHIPS CONTACT ACCIDENTAL](http://abagames.sakura.ne.jp/flash/ssca/)

[YOU HAVE ONE SHOT](http://abagames.sakura.ne.jp/flash/yhos/)

[SIDE SHOT BOOSTER](http://abagames.sakura.ne.jp/flash/ssb/)

[MAGNETIC ACTION](http://abagames.sakura.ne.jp/flash/ma/)

[LASER WINDER](http://wonderfl.net/c/pYeI)

[LOCK ON TO ALL OF THEM](http://wonderfl.net/c/rqvL)

[DUAL PISTOLS RG](http://wonderfl.net/c/ilHX)

[TOSSED HUMANS SPLIT OVER](http://wonderfl.net/c/d8Rm)

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
		// Generate sounds.
		bgmDrumSound = new Sound().setDrumMachine();
		endGameSound = new Sound().major().setMelody()
			.addTone(.3, 10, .7).addTone(.6, 10, .4).end();
		// Apply quarter-note quantization.
		Sound.setDefaultQuant(4);
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
			.setWay(way + 180, 45).setSpeed(v.l).add();
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
			if (position.distanceTo(player.p) > .3) break;
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
* (static)drawToForeground() (df)
* (static)drawToBackground() (db)
* setTitle(title:String, title2:String = ""):G (tt)
* setVersion(version:Int = 1):G (vr)
* enableDebuggingMode():G (dm)
* setYRatio(ratio:Float):G (yr)
* initializeEnd()e:G (ie)

##### Overriden methods
* initialize():Void (i)
* begin():Void (b)
* update():Void (u)
* initializeState():Void (is)
* loadState(d:Dynamic):Void (ls)
* saveState(d:Dynamic):Void (ss)

####Actor (A)

An actor moves on a screen. An actor has a position, a velocity and a dot pixel art.

##### Variables
* position:V (p)
* z:Float = 0
* velocity:V (v)
* way:Float = 0 (w)
* speed:Float = 0 (s)
* dotPixelArt:D (d)

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
* setHitRect(width:Float = -999, height:Float = -1):A (hr)
* setHitCircle(diameter:Float = -999):A (hc)
* isHit(className:String, onHit:Dynamic -> Void = null):Bool (ih)
* setDisplayPriority(priority:Int):A (dp)
* drawToForeground() (df)
* drawToBackground() (bf)

##### Overriden methods
* initialize():Void (i)
* begin():Void (b)
* update():Void (u)

###DotPixelArt (D)

A pixel art for an actor. You can write a rectangle, a circle and an auto generated shape.

##### Methods
* new():D (i)
* setColor(color:C):D (c)
* setColorSpot(color:C):D (cs)
* setColorBottom(color:C):D (cb)
* setColorBottomSpot(color:C):D (cbs)
* setSpotInterval(x:Float = 0, y:Float = 0, xy:Float = 0):D (si)
* setSpotThreshold(threshold:Float):D (st)
* setDotScale(dotScale:Int):D (ds)
* setOffset(x:Float = 0, y:Float = 0):D (o)
* fillRectangle(width:Float, height:Float, edgeWidth:Int = 0):D (fr)
* lineRectangle(width:Float, height:Float, edgeWidth:Int = 1):D (lr)
* generateRectangle(width:Float, height:Float, seed:Int = -1):D (gr)
* fillCircle(diameter:Float, edgeWidth:Int = 0):D (fc)
* lineCircle(diameter:Float, edgeWidth:Int = 1):D (lc)
* generateCircle(diameter:Float, seed:Int = -1):D (gc)
* generateShape(width:Float, height:Float = -1, seed:Int = -1):D (gs)
* setPosition(pos:V):D (p)
* setXy(x:Float, y:Float):D (xy)
* setZ(z:Float = 0):D (z)
* rotate(angle:Float = 0):D (rt)
* setScale(x:Float = 1, y:Float = -1):D (sc)
* enableDotScale():D (ed)
* disableDotScale():D (dd)
* enableRollingShape():D (er)
* setDrawColor(color:C = null):D (dc)
* draw():D (d)

###Sound (S)

A 8-bit era style sound effect.

##### Methods
* new():S (i)
* (static)fadeIn(second:Float = 1):S (fi)
* (static)fadeOut(second:Float = 1):S (fo)
* (static)stop:S (s)
* major():S (mj)
* minor():S (mn)
* noise():S (n)
* noiseScale():S (ns)
* addTone(from:Float, time:Int = 1, to:Float = 0):S (t)
* setWave(width:Float = 0, interval:Float = 0):S (w)
* setMelody(maxLength:Int = 3, step:Int = 1, randomSeed:Int = -1):S (m)
* setMinMax(min:Float = -1, max:Float = 1):S (mm)
* addRest(v:Int = 0):S (r)
* setRepeat(v:Int = 1):S (rp)
* setRepeatRest(v:Int = 0):S (rr)
* setLength(v:Int = 64):S (l)
* setVolume(v:Float = 1):S (v)
* setQuant(v:Int = 0):S (q)
* setLoop():S (lp)
* end():S (e)
* setDrumMachine(seed:Int = -1,
	bassPattern:Int = -1, snarePattern:Int = -1, hihatPattern:Int = -1,
	bassVoice:Int = -1, snareVoice:Int = -1, hihatVoice:Int = -1):S (dm)
* play():S (p)

####Particle (P)

Particles splashed from a specified position.

##### Methods
* new():P (i)
* (static)scroll(className:String, vx:Float, vy:Float = 0,
	minX:Float = 0, maxX:Float = 0,
	minY:Float = 0, maxY:Float = 0):Void (sc)
* setPosition(pos:V):P (p)
* setXy(x:Float, y:Float):P (xy)
* setZ(z:Float = 0):P (z)
* setColor(color:C):P (c)
* setCount(count:Int):P (cn)
* setSize(size:Float):P (sz)
* setSpeed(speed:Float):P (s)
* setTicks(ticks:Float):P (t)
* setWay(angle:Float, angleWidth:Float = 0):P (w)
* add():P (a)

####Text (T)

Showing a text on a screen in a certain duration ticks.

##### Methods
* new():T (i)
* setText(text:String):T (tx)
* setPosition(pos:V):T (p)
* setXy(x:Float, y:Float):T (xy)
* setColor(color:C):T (c)
* setDotScale(dotScale:Float = -1):T (ds)
* alignLeft():T (al)
* alignRight():T (ar)
* alignCenter():T (ac)
* alignVerticalCenter():T (avc)
* setVelocity(vel:V):T (v)
* setVelocityXy(x:Float, y:Float):T (vxy)
* setTicks(ticks:Int):T (t)
* tickForever():T (tf)
* addOnce():T (ao)
* remove():Bool (r)
* draw():T (d)

####Random (R)

Random number generator.

##### Methods
* new():R (i)
* next(v:Float = 1, s:Float = 0):Float (n)
* nextInt(v:Int, s:Int = 0):Int (ni)
* nextFromTo(from:Float to:Float):Float (f)
* nextFromToInt(from:Float to:Float):Int (fi)
* nextPlusOrMinus:Int (pm)
* nextPlusMinus(v:Float = 1):Float (p)
* nextPlusMinusInt(v:Int):Int (pi)
* setSeed(v:Int = -0x7fffffff):R (s)
* setDifficultyBasisStage(stage:Int):R (bst)
* setStage(stage:Int, seedOffset:Int = 0):R (st)
* nextDifficultyCorrected:Float (dc)

####Fiber (F)

Set the do block and the block runs constantly for a specified wait ticks.

##### Methods
* new(parent:Dynamic = null):F (i, ip)
* (static)clear():Bool (cl)
* doIt(block:Expr):F (d)
* wait(count:Float):F (w)
* addWait(count:Float):F (aw)
* decrementWait(count:Float):F (dw)
* disableAutoDecrement():F (dd)
* disableLoop():F (dl)
* update():F (u)
* loop():F (l)
* remove():F (r)
* count:Float (cn)

####Color (C)

RGB color.

##### Variables
* r:Int
* g:Int
* b:Int

##### Methods
* (static)transparent:C (ti)
* (static)black:C
* (static)dark:C (di)
* (static)red:C (ri)
* (static)green:C (gi)
* (static)blue:C (bi)
* (static)yellow:C (yi)
* (static)magenta:C (mi)
* (static)cyan:C (ci)
* (static)white:C (wi)
* int:Int (i)
* setValue(v:C):C (v)
* goDark():C (gd)
* goWhite():C (gw)
* goRed():C (gr)
* goGreen():C (gg)
* goBlue():C (gb)
* goBlink():C (gbl)
* blend(color:C, ratio:Float):C (bl)

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
* (static)stick:V (st)

####Mouse (M)

Mouse input status.

##### Variables
* (static)position:V (p)
* (static)isButtonPressing:Bool (ip)
* (static)isPressedButton:Bool (ipb)

####Vector (V)

2D vector.

##### Variables
* x:Float = 0
* y:Float = 0

##### Methods
* (static)i:V // instance
* setXy(x:Float = 0, y:Float = 0):V (xy)
* setNumber(n:Float = 0):V (n)
* setValue(v:V):V (v)
* length:Float (l)
* way:Float (w)
* xInt:Int (xi)
* yInt:Int (yi)
* distanceTo(pos:V):Float (dt)
* distanceToDistorted(pos:V, pixelWHRatio:Float = -1):Float (dtd)
* wayTo(pos:V):Float (wt)
* add(v:V):V (a)
* sub(v:V):V (s)
* multiply(v:Float):V (m)
* divide(v:Float):V (d)
* addWay(angle:Float, speed:Float):V (aw)
* rotate(angle:Float):V (rt)
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
