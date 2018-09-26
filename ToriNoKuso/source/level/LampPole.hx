package level;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxPoint;
/**
 * ...
 * @author Jay
 */
class LampPole extends LevelObject 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X+14, Y, SimpleGraphic, initSpeed);
		animation.add("pole", [1], 0);
		animation.play("pole");
		
		width = 4;
		offset = new FlxPoint(14,0);
	}
	
	override public function graphicFilename():String{
		return "assets/images/StreetLight.png";
	}
	
}