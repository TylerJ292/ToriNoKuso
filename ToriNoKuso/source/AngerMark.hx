package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
import level.LevelManager;
import level.Person;

/**
 * Used by a person for expressing their anger
 * ...
 * @author Jay
 */
class AngerMark extends FlxSprite
{

	public var filename:String = "assets/images/Angry.png";
	public var imageWidth = 16;
	public var imageHeight = 16;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		velocity.x = LevelManager.screenSpeed;
		loadGraphic(filename, true, imageWidth, imageHeight);
		
		animation.add("main", [0, 1], 5, true);
		animation.play("main");
		
		new FlxTimer().start(1, function(_t:FlxTimer){
			this.destroy();
		}, 1);
	}
	
}