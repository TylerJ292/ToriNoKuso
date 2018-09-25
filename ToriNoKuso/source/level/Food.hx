package level;

import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Jay
 */
class Food extends LevelObject 
{
	public static inline var RANDOM_FOOD = -1; //invalid foodType, only use for initialization
	public static inline var EMPTY_PLATE = 0;
	public static inline var PIZZA = 1;
	public static inline var SANDWICH  = 2;
	public static inline var BURGER = 3;
	
	public static var FOODS:Array<Int> = [EMPTY_PLATE, PIZZA, SANDWICH, BURGER]; //remember to update this if adding a new kind of food
	
	public var foodType:Int;
	public var plate:Bool;
	public var carrier:Carrier = null;	//person carrying the food, null for none
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float, ?_carrier:Carrier, ?_foodType = RANDOM_FOOD, ?_plated = true) 
	{
		LevelManager.FoodObjects.add(this);
		
		carrier = _carrier;
		plate = _plated;
		if (_foodType == RANDOM_FOOD){
			foodType = new FlxRandom().int(1, FOODS.length - 1);
		}
		else
			foodType = _foodType;
			
		//TODO: Adjust hitbox based on food sprite
			
		super(X, Y, SimpleGraphic, initSpeed);
		
		for(i in FOODS){
			animation.add(Std.string(FOODS[i]), [i], 1, false);
		}
		animation.play(Std.string(foodType));
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (carrier != null){
			if (!carrier.alive){
				carrier = null;
				this.kill();
			}
			else{
				this.x = carrier.x + carrier.getCarryX();
				this.y = carrier.y + carrier.getCarryY();
			}
		}
	}
	
	override public function graphicFilename():String{
		if (plate)	return "assets/images/Food.png";
		else 		return "assets/images/Food Unplated.png";
	}
	
	override public function getWidth():Int{
		return 32;
	}
	
	override public function getHeight():Int{
		return 32;
	}
	
	/**
	 * If food is taken
	 * 
	 * Override in children for custom behavior
	 */
	public function takeFood(_bird:Bird){
	
		if (foodType != EMPTY_PLATE && carrier != _bird){
			
			//TODO: increase bird ammo
			
			var _food = new Food(_bird.x + _bird.getCarryX(), _bird.y + _bird.getCarryY(), LevelManager.screenSpeed, _bird, this.foodType, false);
			new FlxTimer().start(1, function(_t:FlxTimer){
				_food.kill();
			}, 1);
			
			if (plate){
				foodType = EMPTY_PLATE;
				animation.play(Std.string(EMPTY_PLATE));
			}
			else{
				this.kill();
			}
			
			if (carrier != null){
				carrier.foodTaken();
				carrier = null;
			}

		}
	
	}
}