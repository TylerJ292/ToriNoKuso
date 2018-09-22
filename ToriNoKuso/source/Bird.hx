package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bird extends FlxSprite {


  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);


		loadGraphic("assets/images/squirrels1.png", true, 16, 16);

    var health:Int = 5;
    var dead:Bool = false;
    //var ammo:Ammo = 0;

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

  pubic function diveForFood() {
    //on button press, move player vertically down the screen
  }

}
