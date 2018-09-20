package;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
/**
 * Person who walks around and stuff
 * 
 * @author Jay
 */
enum Activity {
	Inactive;	//use for inactive state outside of screen
	Walking;
}
 
class Person extends Obstacle 
{
	public var state:Activity = Inactive;
	public var walkSpeed:Float = 10;
	
	override public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//is active
		if (getPosition().x < FlxG.width){
			
			if (state == Inactive){
				state = Walking;
				velocity.x -= walkSpeed;
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
	
}