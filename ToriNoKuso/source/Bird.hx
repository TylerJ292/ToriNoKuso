package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxTimer;

class Bird extends FlxSprite implements Carrier{

	public var dive:Bool = false;
	public var dead:Bool = false;
	public var pullUp:Bool = false;
	public var ammo:Int = 10;
	public var invinc:Bool = false;
	//public var health:Int = 5;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);


		loadGraphic("assets/images/Pigeon.png", true, 32, 32);
		health = 5;

		animation.add("BirdFly", [0, 1, 2, 3, 4], 10, true);
		animation.play("BirdFly");
	}

  public function healthTracker() {
    if (health > 0 && invinc == false ) {
      health--;
	  invinc = true;
	  new FlxTimer().start(2, invincframe, 1); 
      trace("Player health now at ", health);
    }
	else if( health <= 0){
    dead = true;
    trace("Player died");
	}
    //game over, screen freezes and text appears
  }
  public function invincframe(Timer:FlxTimer):Void{
	  invinc = false;
	  
  }

  public function diveForFood() {
    //on button press, move player vertically down the screen
  }

	public function getCarryX():Float{
		return 8;
	}
	
	public function diving(){
		if(!dive){
			dive = true;
		}
		if(dive){
			if(!pullUp){
				velocity.set(150, 150);
			}
			else if(pullUp){
				velocity.set(150, -150);
			}
			if(this.y >= FlxG.height - 32){
				pullUp = true;
			}
			if(this.y <= FlxG.height - 288){
				dive = false;
				velocity.set(0, 0);
				pullUp = false;
			}
		}
	}
	public function getCarryY():Float{
		return -4;
	}
}
