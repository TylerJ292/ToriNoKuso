package;
import flixel.FlxSprite;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.math.FlxVelocity;
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
	
	public function move(player:Bird)
	{
		if (ActionRNG == 1 || ActionRNG == 4)
		{
			 
			movetoTarget(player, 2);
		}
		else if (ActionRNG == 2 || ActionRNG == 3)
		{
			velocity.set( -500,0 );
		}
		
	}
	
	public function movetoTarget(player:Bird, time:Float)
	{
	    var diffx:Float = player.x - this.x;
		var diffy:Float = player.y - this.y;
		velocity.set(diffx/ time, diffy/ time);
		
		
	}
	
}