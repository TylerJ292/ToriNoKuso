package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import level.*;
import flixel.util.FlxTimer;
/**
 * Rock projectile thrown by people
 * 
 * @author Jay
 */
class Rock extends FlxSprite
{

	public var gravity:Float = 350;
	
	public var imageHeight:Int = 16;
	public var imageWidth:Int = 16;
	public var filename = "assets/images/rock.png";
	
	override public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(filename, true, imageWidth, imageHeight);
		
		LevelManager.state.add(this);
		LevelManager.state.Rocks.add(this);
		
		acceleration.y = gravity;
		
		set_immovable(false);
		
		new FlxTimer().start(5, function(_t:FlxTimer){this.kill(); });
	}
	
}