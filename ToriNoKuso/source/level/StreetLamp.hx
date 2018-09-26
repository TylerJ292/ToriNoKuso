package level;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Jay
 */
class StreetLamp extends Obstacle 
{
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X+8, Y+8, SimpleGraphic, initSpeed);
		
		set_immovable(true);
		
		width = 16;
		height = 16;
		offset = new FlxPoint(8, 8);
	}
	
	override public function graphicFilename():String{
		return "assets/images/StreetLight.png";
	}
	
	override function getWidth():Int{
		return 32;
	}
	
	override function getHeight():Int{
		return 32;
	}
}