package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
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
			velocity.set( -100, 0);
		}
		else if (ActionRNG <= 2 && ActionRNG >= 3)
		{
			velocity.set( -75, 10);
		}
		else if (ActionRNG == 4)
		{
			velocity.set( -75, -10);
		}
	}
	/*
	public function movetoTarget(Player player)
	{
		var xtarget:Int = player.x;
		var ytarget:Int = player.y;
	FlxTween.tween(this, {x : xtarget, y : ytarget}, 2)
		
		
	}
	*/
}