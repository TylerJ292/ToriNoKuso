package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
/**
 * 
 * base class, obstacles should be extended from this
 * 
 * @author Jay
 */
class Obstacle extends FlxSprite 
{
	 
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(graphicFilename(), true, getWidth(), getHeight());
		
		velocity.x = initSpeed;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function graphicFilename():String{
		return "assets/images/obstacle.png";
	}
	
	public function getWidth():Int{
		return 32;
	}
	
	public function getHeight():Int{
		return 32;
	}
	
}