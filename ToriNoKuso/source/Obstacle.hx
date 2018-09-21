package;
import flixel.FlxSprite;
import flixel.FlxG;
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
		
		LevelManager.state.add(this);
		LevelManager.Obstacles.add(this);
		
		set_immovable(true);
		
		velocity.x = initSpeed;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (destroyIfOutOfBounds()){
			this.kill();
		}
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
	
	/* This function returns true if the object should be destroyed if out of bounds.
	 * 
	 * If it should not be, override to return false.
	 */
	public function destroyIfOutOfBounds():Bool{
		return getPosition().x < FlxG.width * -1 || getPosition().x > FlxG.width * 3.5
		    || getPosition().y < FlxG.height * -1 || getPosition().y > FlxG.height * 2;
	}
	
}