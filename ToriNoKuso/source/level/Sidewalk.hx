package level;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Sidewalk. To be overlayed over grass, hopefully
 * 
 * @author Jay
 */
class Sidewalk extends LevelObject 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
		
	}
	
	override public function graphicFilename():String{
		return "assets/images/Sidewalk.png";
	}
}