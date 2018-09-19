package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
/**
 * ...
 * @author ...
 */
class Squirrel extends FlxSprite 
{

	//Speed of the Squirrel
	public var Sspeed:Float;
	//Random number that determines the action of the Squirrel
	public var ActionRNG:Int;
	public var stype(default, null):Int;
	 
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, SType:Int, AIMove:Int) 
	{
		super(X, Y, SimpleGraphic);
		stype = SType;
		ActionRNG = AIMove;
		
		loadGraphic("assets/images/squirrels" + stype + ".png", true, 16, 16);
		
	}
	
	public function move()
	{
		if (ActionRNG == 1)
		{
			velocity.set( -30, 0);
		}
		else if (ActionRNG == 2)
		{
			velocity.set( -30, 15);
		}
		else if (ActionRNG == 3)
		{
			velocity.set( -30, -15);
		}
	}
	
}