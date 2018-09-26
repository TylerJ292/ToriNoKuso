package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxPoint;
import flixel.FlxG;
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
		#if flash
			FlxG.sound.play(AssetPaths.am__mp3);
		#else
			FlxG.sound.play(AssetPaths.am__wav);
		#end
		this.width = 16;
		this.height = 16;
		this.offset = new FlxPoint(8, 8);
		velocity.set(0, 300);
		scale.set(3, 3);
	}

	public function checkdead(){
		if ( this.y > 680)
		{
			destroy();
		}
	}
}
