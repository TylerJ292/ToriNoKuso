package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
/**
 * ...
 * @author ...
 */
class Heart extends FlxSprite 
{
	var heartID:Int;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, type:Int)
	{
		
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/Hearts.png", true, 32, 32);
		heartID = type;
		animation.add("Hearty", [heartID], false);
		animation.play("Hearty");
		
	}
	
}