package;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
/**
 * Person who walks around and stuff
 * 
 * @author Jay
 */
enum Activity {
	Inactive;	//use for inactive state outside of screen
	Walking;
}

enum Direction {
	None;
	Left;	//use for inactive state outside of screen
	Right;
}
 
class Person extends Obstacle 
{
	public var state:Activity = Inactive;
	public var dir:Direction = None;
	public var walkSpeed:Float = 30;
	
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
			
			if (state == Inactive){
				state = Walking;
				velocity.x -= walkSpeed;
				dir = Left;
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
	
	public static function onOverlap(_person:Person, _obs:Obstacle){
		
		if (_person.state == Walking){
			if (_person.dir == Left){
				_person.velocity.x += _person.walkSpeed;
				_person.dir = Right;
			}else if (_person.dir == Right){
				_person.velocity.x -= _person.walkSpeed;
				_person.dir = Left;
			}
		}
	}
}