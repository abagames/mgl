mgl (Mini Game programming Library)
======================
Mgl is a flash mini game programming library for my own use. Mgi is useful for creating a mini game with a terrible unreadable code.

Using the [SiON](https://github.com/keim/SiON "SiON") synthesizer library.

####Sample game

[LASER WINDER](http://wonderfl.net/c/pYeI)

####Sample game (using the older version mgl)

[LOCK ON TO ALL OF THEM](http://wonderfl.net/c/rqvL)

[DUAL PISTOLS RG](http://wonderfl.net/c/ilHX)

[TOSSED HUMANS SPLIT OVER](http://wonderfl.net/c/d8Rm)

[WASD THRUST](http://wonderfl.net/c/cUIn)

###Classes

####A // Actor

##### Variables
* p:V // position
* v:V // velocity
* a:Float // angle
* s:Float // speed

##### Methods
* i:A // instance
* u:A // update
* c(radius:Float):A // set hit circle
* r(width:Float, height:Float = -1):A // set hit rectangle
* ic(actors:Array<Dynamic>, hitInstance:Dynamic = null):Bool // is hit circle
* ir(actors:Array<Dynamic>, hitInstance:Dynamic = null):Bool // is hit rectangle

####C // Color

##### Variables
* r:Int // red
* g:Int // green
* b:Int // blue

##### Methods
* ti:C // transparent instance
* di:C // dark (black) instance
* ri:C // red instance
* gi:C // green instance
* bi:C // blue instance
* yi:C // yellow instance
* mi:C // magenta instance
* ci:C // cyan instance
* wi:C // white instance
* i:Int; // integer value
* v(v:C):C // set value
* gd:C // go dark
* gw:C // go white
* gr:C // go red
* gg:C // go green
* gb:C // go blue
* gbl:C // go blink
* bl(color:C, ratio:Float):C // blend

####D // DotShape

##### Methods
* i:D // instance
* sz(dotSize:Int):D // set dot size
* c(color:C):D // set color
* cs(color:C):D // set color spot
* cb(color:C):D // set color bottom
* cbs(color:C):D // set color bottom spot
* si(x:Float = 0, y:Float = 0, xy:Float = 0):D // set spot interval
* st(threshold:Float):D // set spot threshold
* o(x:Float = 0, y:Float = 0):D // set offset
* fr(width:Float, height:Float, edgeWidth:Int = 0) // fill rectangle
* lr(width:Float, height:Float, edgeWidth:Int = 1):D // line rectangle
* fc(radius:Float, edgeWidth:Int = 0):D // fill circle
* lc(radius:Float, edgeWidth:Int = 1):D // line circle
* p(pos:V):D // set pos
* r(angle:Float):D // rotate
* s(x:Float = 1, y:Float = -1):D // set scale
* ed:D // enable dot scale
* dd:D // disable dot scale
* dc(color:C = null):D // set draw color
* d:D // draw

####G // Game

##### Methods
* tt(title:String, title2:String = ""):G // set title
* dm:G // debugging mode
* pl(platform:Dynamic):G // set platform
* b:G // begin
* ig:Bool // is in game
* tc:Int // ticks
* ua(actors:Array<Dynamic>):G // update actors
* dp:G // draw particles
* fr(x:Float, y:Float, width:Float, height:Float, color:C):G // fill rectangle
* cb(color:C):G // clear background
* frb(x:Float, y:Float, width:Float, height:Float, color:C):G // fill background rectangle
* sc(score:Int):G // add score
* e:Bool // end

####K // Key

##### Variables
* s:Array<Bool> // pressed keys

##### Methods
* iu:Bool // is up pressed
* id:Bool // is down pressed
* ir:Bool // is right pressed
* il:Bool // is left pressed
* ib:Bool // is button pressed
* ib1:Bool // is button1 pressed
* ib2:Bool // is button2 pressed
* st:V // stick
* r:K // reset

####L // Letter

##### Methods
* i:L // instance
* t(text:String):L // set text
* p(pos:V):L // set position
* xy(x:Float, y:Float):L // set xy
* al:L // align left
* ar:L // align right
* ac:L // align center
* s(dotSize:Int):L // set dot size
* c(color:C):L // set color
* d:L // draw

####M // Mouse

##### Variables
* p:V // pos
* ip:Bool // is pressing

####P // Particle

##### Methods
* i:P // instance
* p(pos:V):P // set position
* c(color:C):P // set color
* cn(count:Int):P // set count
* sz(size:Float):P // set size
* s(speed:Float):P // set speed
* t(ticks:Float):P // set ticks
* an(angle:Float, angleWidth:Float):P // set angle
* a:P // add

####R // Random

##### Methods
* ni(v:Int):R // new instance
* n(v:Float = 1, s:Float = 0):Float // number
* i(v:Int, s:Int = 0):Int // int
* p():Int // plus minus
* pn(v:Float = 1):Float // plus minus number
* s(v:Int = -0x7fffffff):R // set seed

####S // SoundEffect

##### Methods
* i:S // instance
* mj:S // major
* mn:S // minor
* n:S // noise
* ns:S // noise scale
* t(from:Float, time:Int = 1, to:Float = 0) // add tone
* w(width:Float = 0, interval:Float = 0):S // set wave
* m(randomSeed:Int = 0, maxLength:Int = 3, step:Int = 1):S // set melody
* mm(min:Float = -1, max:Float = 1):S // set min max
* r(v:Int = 0):S // add rest
* rp(v:Int = 1):S // set repeat
* rr(v:Int = 0):S // set repeat rest
* l(v:Int = 64):S // set length
* v(v:Int = 16):S // set volume
* lp:S // loop
* e:S // end
* p:S // play
* fi(second:Float = 1):S // fade in
* fo(second:Float = 1):S // fade out
* s:S // stop

####T // Text

##### Methods
* i:T // instance
* p(pos:V):T // set position
* xy(x:Float, y:Float):T // set xy
* t(text:String):T // set text
* v(vel:V):T // set velocity
* tc(ticks:Int):T // set ticks
* a:T // add
* ao:T // add once

####U // Utility

##### Methods
* c(v:Float, min:Float, max:Float):Float // clamp
* ci(v:Int, min:Int, max:Int):Int // clamp int
* na(v:Float):Float // normalize angle
* aa(v:Float, targetAngle:Float, angleVel:Float):Float // aim angle
* cr(v:Float, min:Float, max:Float):Float // circle range

####V // Vector

##### Variables
* x:Float // x
* y:Float // y

##### Methods
* i:V // instance
* xy(x:Float = 0, y:Float = 0):V // set xy
* n(n:Float = 0):V // set number
* v(v:V):V // set value
* l:Float // length
* an:Float // angle
* xi:Int // x int
* yi:Int // y int
* dt(pos:V):Float // distance to
* wt(pos:V):Float // way to
* a(v:V):V // add
* s(v:V):V // sub
* m(v:Float):V // multiply
* d(v:Float):V // divide
* aa(angle:Float, speed:Float):V // add angle
* r(angle:Float):V // rotate
* ii(spacing:Float = 0, minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool // is in

License
----------
Copyright &copy; 2013 ABA Games

Distributed under the [MIT License][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php
