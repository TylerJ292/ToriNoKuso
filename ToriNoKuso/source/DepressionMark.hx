package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * The fact that this extends anger mark is just a sign of my own laziness, really
 * ...
 * @author Jay
 */
class DepressionMark extends AngerMark 
{

	public var Filename:String = "assets/images/Sad.png";
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(Filename, true, imageWidth, imageHeight);
		
		animation.add("main", [0], 5, true);
		animation.play("main");
		
		new FlxTimer().start(10, function(_t:FlxTimer){
			this.destroy();
		}, 1);
	}
	
}