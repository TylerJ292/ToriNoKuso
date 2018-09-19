package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
/**
 * 
 * base class, obstacles should be extended from this
 * 
 * @author Jay
 */
class Obstacle extends FlxSprite 
{

	//public var Int screenSpeed
	 
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, SType:Int, AIMove:Int) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(graphicFilename(), true, getWidth(), getHeight());
		
	}
	
	public function move()
	{

	}
	
	public String function graphicFilename(){
		return "assets/images/obstacle";
	}
	
	public Int function getWidth(){
		return 16;
	}
	
	public Int function getHeight(){
		return 16;
	}
	
}