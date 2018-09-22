package level;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import level.LevelManager;
import level.LevelObject;
/**
 * An "obstacle" is any LevelObject that damages the player when the player collides with it.
 * Extend dangerous objects from this class.
 * 
 * @author Jay
 */
 
class Obstacle extends LevelObject 
{
	
	override public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
		
		LevelManager.Obstacles.add(this);
		
		set_immovable(true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	override public function graphicFilename():String{
		return "assets/images/obstacle.png";
	}
	
	override function getWidth():Int{
		return 32;
	}
	
	override function getHeight():Int{
		return 32;
	}
}