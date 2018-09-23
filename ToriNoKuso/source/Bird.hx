package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bird extends FlxSprite implements Carrier{

	public var dive:Bool = false;
	public var dead:Bool = false;
	public var ammo:Int = 10;
	//public var health:Int = 5;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);


		loadGraphic("assets/images/Pigeon.png", true, 32, 32);
	
		animation.add("BirdFly", [0, 1, 2, 3, 4], 10, true);
		animation.play("BirdFly");
	}

  public function healthTracker() {
    if (health > 0) {
      health--;
      trace("Player health now at ", health);
    }
    dead = true;
    trace("Player died");
    //game over, screen freezes and text appears
  }

  public function diveForFood() {
    //on button press, move player vertically down the screen
  }

	public function getCarryX():Float{
		return 8;
	}
	
	public function getCarryY():Float{
		return -4;
	}
}
