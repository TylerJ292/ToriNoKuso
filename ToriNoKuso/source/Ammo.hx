package;

import flixel.FlxSprite;
/**
 * ...
 * @author ...
 */
class Ammo extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/Kuso.png", true, 32, 32);
		animation.add("PoopDrop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 10, true);
		animation.play("PoopDrop");
	}
	
}