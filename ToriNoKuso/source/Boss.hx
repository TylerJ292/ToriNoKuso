package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.util.FlxTimer;

class Boss extends FlxSprite
{
	public var bossDirX:Int = -1;			// Direction boss is moving in
	public var bossDirY:Int = -1;			// Direction boss is moving in
	public var bossSpd:Float = 200;	// Boss movement speed
	public var chargeBoost:Float = 50;	// Boss movement speed boost for charge attack
	public var bossPattern:Int;			// Boss movement pattern
	public var crapCounter:Int = 0;	// Amount of bird poop on the fridge
	public var crapCap:Int = 3;			// Amount of bird poop needed to ground the fridge
	public var directedCharge:Bool = false;
	public var grounded:Bool = false;
	public var invincible:Bool = false;
	public var hp:Int = 6;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/Squirrel King.png", true, 32, 64);
		animation.add("bossFly", [0, 1], 9, true);
		animation.play("bossFly");
		scale.set(1.5, 1.5);
		updateHitbox();
	}
	
	public function drop(player:Bird){
		crapCounter++;
		invincible = true;
		new FlxTimer().start(.25, iFrames, 1);
		if (crapCounter >= crapCap){
			grounded = true;
			crapCounter = 0;
			new FlxTimer().start(6, liftOff, 1);
		}
	}
	
	public function damage(){
		hp--;
		invincible = true;
		new FlxTimer().start(.5, iFrames, 1);
		if (hp == 4){
			bossSpd += 50;
		}
		else if (hp == 2){
			bossSpd += 100;
		}
		else if (hp == 0){
			trace("You WIN!");
			return false;
		}
		return true;
	}
	
	public function iFrames(Timer:FlxTimer):Void{
		invincible = false;
	}
	
	public function liftOff(Timer:FlxTimer):Void{
		trace("liftOff");
		grounded = false;
	}
	
	public function bossMove(pattern:Int, angle:Float = 42, player:Bird){
		// Charge Attack
		if (pattern == 0){
			velocity.set(bossDirX * (bossSpd + chargeBoost), 0);
		} 
		// Sin Wave
		else if (pattern == 1 || pattern == 2){
			velocity.set(bossDirX * bossSpd, bossDirY * bossSpd * FlxMath.fastSin(this.x/angle));
		}
		// Cos Wave
		else if (pattern == 3 || pattern == 4){
			velocity.set(bossDirX * bossSpd, bossDirY * bossSpd * FlxMath.fastCos(this.x/angle));
		}
		// Directed Charge
		else if (pattern == 5 && !directedCharge){
			var angle:Float = FlxAngle.angleBetween(this , player, false);
      velocity.set((bossSpd + chargeBoost) * FlxMath.fastCos(angle), (bossSpd + chargeBoost) * FlxMath.fastSin(angle));
			directedCharge = true;
		}
	}
}