package level;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jay
 */
class PicnicTable extends LevelObject 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
		
	}
	
	override public function getWidth():Int 
	{
		return 96;
	}
	
	override public function graphicFilename():String{
		return "assets/images/Picnic Table.png";
	}
}