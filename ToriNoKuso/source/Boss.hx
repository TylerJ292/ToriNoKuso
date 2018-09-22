package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;

class Boss extends FlxSprite
{
	public var bossDirX:Int = -1;			// Direction boss is moving in
	public var bossDirY:Int = -1;			// Direction boss is moving in
	public var bossSpd:Float = 150;	// Boss movement speed
	public var chargeBoost:Float = 50;	// Boss movement speed boost for charge attack
	public var bossPattern:Int;			// Boss movement pattern
	public var crapCounter:Int = 0;	// Amount of bird poop on the fridge
	public var crapCap:Int = 3;			// Amount of bird poop needed to ground the fridge
	public var directedCharge:Bool = false;
	public var grounded:Bool = false;
	public var hp:Int = 6;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/red32.png");
	}
	
	public function drop(){
		crapCounter++;
		if (crapCounter >= crapCap){
			grounded = true;
			crapCounter = 0;
		}
	}
	
	public function bossMove(pattern:Int, angle:Float = 42){
		// Charge Attack
		if (pattern == 0){
			velocity.set(bossDirX * (bossSpd + chargeBoost), 0);
		} 
		// Sin Wave
		else if (pattern == 1){
			velocity.set(bossDirX * bossSpd, bossDirY * bossSpd * FlxMath.fastSin(this.x/angle));
		}
		// Cos Wave
		else if (pattern == 2){
			velocity.set(bossDirX * bossSpd, bossDirY * bossSpd * FlxMath.fastCos(this.x/angle));
		}
		// Directed Charge
		/* else if (pattern == 3 && !directedCharge){
			var angle:Float = FlxAngle.angleBetween(this , player, false);
      velocity.set((bossSpd + chargeBoost) * FlxMath.fastCos(angle), Sspeed * FlxMath.fastSin(angle));
			directedCharge = true;
		} */
		
	}
	
}