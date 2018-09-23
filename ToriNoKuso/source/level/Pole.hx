package level;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jay
 */
class Pole extends Obstacle 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
		animation.add("pole", [1], 10, false);
		animation.play("pole");
	}
	
	override public function graphicFilename():String{
		return "assets/images/Stop Sign.png";
	}
	
}