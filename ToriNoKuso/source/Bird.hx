package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bird extends FlxSprite {

	public var dive:Bool = false;
	public var dead:Bool = false;
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
	
}
