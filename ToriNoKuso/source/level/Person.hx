package level;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import level.LevelManager;
import level.LevelObject;
import level.Obstacle;
import flixel.util.FlxTimer;

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

class Person extends level.Obstacle
{
	//AI VALUES
	public var state:State = INACTIVE;
	public var dir:Direction = NONE;

	public var startY:Float;

	//PHYSICS VALUES
	//these variables are not static or constants so that children may modify them for custom behavior
	public var walkSpeed:Float = 30; //speed to casually walk at
	public var runSpeed:Float = 70;  //speed to run at after dived at / food stolen
	public var shockTime:Float = 1; //amount of time (seconds) to stare at sky in abject horror after food is stolen or poop

	public var rockPeriod:Float = 2.5; //amount of time (seconds) between rock throws
	public var throwSpeedY:Float = 300;
	public var throwSpeedX:Float = 60;

	public var jumpSpeed:Float = 150;//when angry and reached a stopping point, will jump up and down at this speed
	public var gravity:Float = 200;//gravity acceleration: only used when jumping, otherwise irrelevant

	override public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float)
	{
		super(X, Y, SimpleGraphic, initSpeed);

		LevelManager.People.add(this);

		set_immovable(false);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//is active
		if (getPosition().x < FlxG.width){

			if (state == INACTIVE){
				state = NEUTRAL;
				velocity.x -= walkSpeed;
				dir = LEFT;
			}

			else if (state == ANGRY){
				if(dir == RIGHT){
					if ( LevelManager.state._player.x < this.x + (LevelManager.unit * 3) )
						velocity.x = LevelManager.screenSpeed + walkSpeed;
					else{
						velocity.x = LevelManager.screenSpeed + runSpeed;
					}
				}else if (dir == NONE && y > startY){
					y = startY;
					velocity.y = 0;
					acceleration.y = 0;

					dir = RIGHT;
				}
			}
		}
	}

	override public function graphicFilename():String{
		return "assets/images/person.png";
	}

	override function getWidth():Int{
		return 32;
	}

	override function getHeight():Int{
		return 64;
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

			new FlxTimer().start(shockTime, function(_t:FlxTimer) {
				this.state = ANGRY;
				this.dir = RIGHT;
				velocity.x = LevelManager.screenSpeed + this.runSpeed;

				new FlxTimer().start(rockPeriod, this.throwRock, 0);
			}, 1);
		}
	}

	/**
	 * Called when a person throws a rock
	 * @param	_t
	 */
	public function throwRock(_t:FlxTimer) {
		var _rock:Rock = new Rock(this.x, this.y);

		_rock.velocity.x = throwSpeedX;
		_rock.velocity.y = -throwSpeedY;
		FlxG.sound.play("assets/sounds/throw.wav");
	}

	public static function onCollision(_person:Person, _obj:LevelObject){

		if (_person.state == NEUTRAL){
			if (_person.dir == LEFT){
				_person.velocity.x += _person.walkSpeed;
				_person.dir = RIGHT;
			}else if (_person.dir == RIGHT){
				_person.velocity.x -= _person.walkSpeed;
				_person.dir = LEFT;
			}
		}

		if (_person.state == ANGRY){
			if (_person.dir == RIGHT){
				//hit a wall, jumps up and down
				//_person.velocity.x = LevelManager.screenSpeed;
				_person.dir = NONE;

				_person.startY = _person.y;
				_person.acceleration.y = _person.gravity;
				_person.velocity.y = -_person.jumpSpeed;
			}
		}
	}
}
