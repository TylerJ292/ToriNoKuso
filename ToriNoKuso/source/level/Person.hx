package level;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import level.LevelManager;
import level.LevelObject;
import level.Obstacle;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.FlxObject;
import flixel.group.*;

/**
 * Person who walks around and stuff
 *
 * @author Jay
 */
enum State {
	INACTIVE;	//use for inactive state outside of screen
	NEUTRAL;	//base state (walking casually)
	HIT;		//just attacked
	ANGRY;		//angry, throwing rocks occasionally
	DEPRESSED; 	//covered in crap, does not want to throw rocks
}

enum Direction {
	NONE;
	LEFT;
	RIGHT;
}
 
class Person extends LevelObject implements Carrier
{
	//AI VALUES
	public var state:State = INACTIVE;
	public var dir:Direction = NONE;

	public var startY:Float;
	
	public var food:Food = null;// reference to food object person is carrying
	public var foodRightX:Float = 0;// X coord of food, relative to when facing right
	public var foodLeftX:Float = -16;// X coord of food, relative to when facing left
	public var foodY:Float = 18;// Y coord of food, relative
	public var foodChance:Float = 0.50;//percentage chance of carrying food
	
	public var throwRange:Float = 3;	//tries to be [0, throwRange] units behind the player when throwing rocks, init value used for standardization
	public var throwRangeMin:Float = 1; //randomly calculate throwRange to be between min and max
	public var throwRangeMax:Float = 5; 
	
	//PHYSICS VALUES
	//these variables are not static or constants so that children may modify them for custom behavior
	public var walkSpeed:Float = 30; //speed to casually walk at
	public var runSpeed:Float = 80;  //speed to run at after dived at / food stolen
	public var sadSpeed:Float = 10;  //speed to walk at after spirit is broken
	public var shockTime:Float = 1; //amount of time (seconds) to stare at sky in abject horror after food is stolen or poop

	public var rockPeriod:Float = 2.5; //amount of time (seconds) between rock throws
	public var throwSpeedY:Float = 350;
	public var throwSpeedX:Float = 130;//if throwRange == init. Modified based on how throwRange chnges
	
	public var jumpSpeed:Float = 150;//when angry and reached a stopping point, will jump up and down at this speed
	public var gravity:Float = 200;//gravity acceleration: only used when jumping, otherwise irrelevant
	
	//ANIMATION VALUES
	//frame rate, etc
	public var walkRate = 4;
	public var runRateSlow = 6;
	public var runRateFast = 8;
	public var slowRate = 2;
	
	public var emoticon:AngerMark = null;

	override public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float)
	{
		super(X, Y, SimpleGraphic, initSpeed);

		LevelManager.People.add(this);

		set_immovable(false);
		
		determineFood();
		refreshAnimation();
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		//so that not everyone is the same
		var _rand = new FlxRandom().float(throwRangeMin, throwRangeMax);
		throwSpeedX *= (_rand / throwRange);
		throwRange = _rand;
		
		startY = Y;
	}

	/**
	 * Called when new graphic should be loaded
	 */
	public function refreshAnimation():Void{
		loadGraphic(graphicFilename(), true, getWidth(), getHeight());
		
		animation.add("walk", [1, 2, 3, 4, 5, 6, 7, 8], walkRate, true);
		animation.add("run", [1, 2, 3, 4, 5, 6, 7, 8], runRateFast, true);
		animation.add("slow", [1, 2, 3, 4, 5, 6, 7, 8], slowRate, true);
		animation.add("hit", [3], 1, true);
		
		width = 16;
		this.offset = new FlxPoint(8, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//is active
		if (getPosition().x < FlxG.width){

			if (state == INACTIVE){
				state = NEUTRAL;
				animation.play("walk");
				velocity.x -= walkSpeed;
				dir = LEFT;
				facing = FlxObject.LEFT;
			}
			
			if (state == ANGRY || state == HIT){
				if (dir == NONE && y > startY){
					y = startY;
					velocity.y = 0;
					acceleration.y = 0;
					dir = RIGHT;
					facing = FlxObject.RIGHT;
				}
			}
			
			if (state == ANGRY){
				//if in a sweet spot from player
				if (LevelManager.state._player.x < this.x + (LevelManager.unit * throwRange) ){
					//this if needs to be separate from the other if due to else statement below, do not combine
					if(animation.curAnim.frameRate != runRateSlow){
						velocity.x = LevelManager.screenSpeed + walkSpeed;
						animation.curAnim.frameRate = runRateSlow;
						dir = RIGHT;
						facing = FlxObject.RIGHT;
					}
				}
				//if far behind player (not in sweet spot defined above)
				else if (LevelManager.state._player.x > this.x){
					if(animation.curAnim.frameRate != runRateFast){
						velocity.x = LevelManager.screenSpeed + runSpeed;
						animation.curAnim.frameRate = runRateFast;
						dir = RIGHT;
						facing = FlxObject.RIGHT;
					}
				}
				//if too far ahead of player (disabled, enable with LevelManager.state._player.x > this.x &&  in the first if)
				else{
					if(animation.curAnim.frameRate != 0){
						velocity.x = LevelManager.screenSpeed;
						animation.curAnim.curIndex = 3;
						animation.curAnim.frameRate = 0;	//in future just use a standing anim, if one exists?
						dir = NONE;
						facing = FlxObject.LEFT;
					}
				}
			}
			
			if (emoticon != null){
				if (facing == FlxObject.RIGHT) emoticon.x = x-8;
				else if(facing == FlxObject.LEFT) emoticon.x = x+8;
				emoticon.y = y;
			}
			
			if (y > FlxG.height)
				y = startY;
		}
	}

	override public function graphicFilename():String{
		if (food == null) return "assets/images/PersonTemplate.png";
		else return "assets/images/PersonHoldTemplate.png";
	}
	
	override public function getWidth():Int{
		return 32;
	}
	
	override public function getHeight():Int{
		return 64;
	}
	
	//since this returns people, people are rendered over tables, ground, etc.
	override public function getOrderingGroup():FlxGroup{
		return cast LevelManager.People;
	}
	

	/**
	 * Called in constructor. Use this to determine if a person is carrying food.
	 * If a person is carrying food, default behavior is to randomly select the type.
	 */
	function determineFood():Void{
		
		var _ran:FlxRandom = new FlxRandom();
		if(_ran.float(0,1) <= foodChance){
			food = new Food(x + getCarryX(), y + getCarryY(), LevelManager.screenSpeed, this, Food.RANDOM_FOOD, false);
		}
		
	}
	
	/**
	 * Called when this person is hit with a dive (by _obj).
	 *
	 * Override in children of Person to have custom behavior.
	 */
	public function onDiveAttack(_bird:Bird){
		if (this.state != HIT && this.state != DEPRESSED){
			velocity.x = LevelManager.screenSpeed;
			this.state = HIT;
			animation.play("hit");
			
			if (facing == FlxObject.RIGHT) emoticon = new AngerMark(x-8, y);
			else if(facing == FlxObject.LEFT) emoticon = new AngerMark(x+8, y);
			LevelManager.state.add(emoticon);
			
			new FlxTimer().start(shockTime, function(_t:FlxTimer) {
				this.state = ANGRY;
				refreshAnimation();
				animation.play("run");
				this.dir = RIGHT;
				facing = FlxObject.RIGHT;
				velocity.x = LevelManager.screenSpeed + this.runSpeed;
				
				new FlxTimer().start(rockPeriod - shockTime, this.throwRock, 1);
			}, 1);
		}
	}
	
	/**
	 * Called when this person is hit with ammo.
	 *
	 * Override in children of Person to have custom behavior.
	 */
	public function onAmmoAttack(_ammo:Ammo){
		if (this.state != DEPRESSED){
			velocity.x = LevelManager.screenSpeed;
			this.state = HIT;
			animation.play("hit");
			LevelManager.state.trackSCORE += 500;
			//should they drop any food they are carrying?
			
			if (facing == FlxObject.RIGHT) emoticon = new DepressionMark(x-8, y);
			else if(facing == FlxObject.LEFT) emoticon = new DepressionMark(x+8, y);
			LevelManager.state.add(emoticon);

			new FlxTimer().start(shockTime, function(_t:FlxTimer) {
				this.state = DEPRESSED;
				animation.play("slow");
				this.dir = LEFT;
				facing = FlxObject.LEFT;
				
				velocity.x = LevelManager.screenSpeed - this.sadSpeed;
			}, 1);
		}
		
		_ammo.kill();
	}

	/**
	 * Called when a person throws a rock
	 * @param	_t
	 */
	public function throwRock(_t:FlxTimer) {
		if (!this.alive || state != ANGRY) _t.cancel();
		else{
			var _rock:Rock = new Rock(this.x, this.y);
			
			var _ran:FlxRandom = new FlxRandom();
			
			var _dirMult:Int = 1;
			if (facing == FlxObject.LEFT) _dirMult = -1;
			
			_rock.velocity.x = (throwSpeedX * _ran.float(0.8,1.2) * _dirMult) + LevelManager.screenSpeed;
			_rock.velocity.y = -throwSpeedY * _ran.float(0.8, 1.2);
			
			trace(facing, _dirMult, _rock.velocity.x);
			
			_t.start(rockPeriod * _ran.float(0.8, 1.2), this.throwRock, 1);
			
			FlxG.sound.play("assets/sounds/throw.wav");
		}
	}

	public static function onCollision(_person:Person, _obj:LevelObject){

		if (_person.state == NEUTRAL){
			if (_person.dir == LEFT){
				_person.velocity.x += _person.walkSpeed;
				_person.dir = RIGHT;
				_person.facing = FlxObject.RIGHT;
			}else if (_person.dir == RIGHT){
				_person.velocity.x -= _person.walkSpeed;
				_person.dir = LEFT;
				_person.facing = FlxObject.LEFT;
			}
		}

		if (_person.state == ANGRY){
			if (_person.dir == RIGHT){
				//hit a wall, jumps up and down
				//_person.velocity.x = LevelManager.screenSpeed;
				_person.dir = NONE;

				_person.acceleration.y = _person.gravity;
				_person.velocity.y = -_person.jumpSpeed;
			}
		}
		
		if (_person.state == DEPRESSED){
			if (_person.dir == LEFT){
				_person.velocity.x += _person.sadSpeed;
				_person.dir = RIGHT;
				_person.facing = FlxObject.RIGHT;
			}else if (_person.dir == RIGHT){
				_person.velocity.x -= _person.sadSpeed;
				_person.dir = LEFT;
				_person.facing = FlxObject.LEFT;
			}
		}
	}
	
	//in the future these should change depending on animation, maybe
	public function getCarryX(){
		if (facing == FlxObject.LEFT) return foodLeftX;
		else return foodRightX;
	}
	
	public function getCarryY(){
		return foodY;
	}
	
	/**
	 * Called from within food, when food is taken
	 * 
	 * Does not actually contain logic for food, only for
	 * the carrier's reaction
	 * 
	 * In other words, don't delete food or anything, that
	 * is taken care of in Food.takeFood()
	 */
	public function foodTaken():Void{
		this.food = null;
		refreshAnimation();
		
		if (state != HIT || state != ANGRY){
			//this ensures they still get react even if you dont collide with the person
			this.onDiveAttack(LevelManager.state._player);
		}
	}
}
