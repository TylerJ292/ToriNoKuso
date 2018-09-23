package level;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jay
 */
class StopSign extends Obstacle 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
	}
	
	override public function graphicFilename():String{
		return "assets/images/Stop Sign.png";
	}
	
	override function getWidth():Int{
		return 32;
	}
	
	override function getHeight():Int{
		return 32;
	}
}