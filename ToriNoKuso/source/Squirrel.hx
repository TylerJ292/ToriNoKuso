package;
import flixel.FlxSprite;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
/**
 * ...
 * @author ...
 */
class Squirrel extends FlxSprite 
{

	//Speed of the Squirrel
	public var Sspeed:Float = 350;
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
		if (ActionRNG == 1 || ActionRNG == 2)
		{
			 
			movetoTarget(player);
		}
		else if (ActionRNG == 3 || ActionRNG == 4)
		{
			velocity.set( -1 * Sspeed, 0 );
		}
		
		
	}
	
	public function movetoTarget(player:Bird)
	{
		var angle:Float = FlxAngle.angleBetween(this , player, false);
		velocity.set( Sspeed * FlxMath.fastCos(angle), Sspeed * FlxMath.fastSin(angle));
		
		
	}
	
	public function waitAttack()
	{
		new FlxTimer().start(2 , 1);
	}
	
	public function checkdead():Void
	{
		if (this.x < -20)
		{
			destroy();
		}
		
	}

	
}