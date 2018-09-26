package level;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jay
 */
class StopPole extends LevelObject 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X+12, Y, SimpleGraphic, initSpeed);
		animation.add("pole", [1], 10, false);
		animation.play("pole");
		
		set_immovable(true);
		
		width = 8;
		offset = new FlxPoint(12,0);
	}
	
	override public function graphicFilename():String{
		return "assets/images/Stop Sign.png";
	}
	
}