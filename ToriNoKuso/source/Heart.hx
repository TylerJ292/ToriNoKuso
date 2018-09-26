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
		heartID = type;
		if(heartID != 5){
		loadGraphic("assets/images/Hearts.png", true, 32, 32);
		animation.add("Hearty", [heartID], false);
		animation.play("Hearty");
		}
		else
		{
			loadGraphic("assets/images/Kuso.png", true , 32, 32);
			animation.add("poop", [3], false);
			animation.play("poop");
			scale.set(3, 3);
		}
		
	}
	
}