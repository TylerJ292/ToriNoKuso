package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxTimer;

class Bird extends FlxSprite implements Carrier{

	public var dive:Bool = false;
	public var dead:Bool = false;
	public var pullUp:Bool = false;
	public var ammo:Int = 20;
	public var invinc:Bool = false;
	public var hpbarList = new Array<Int>();
	//public var health:Int = 5;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);


		loadGraphic("assets/images/Pigeon.png", true, 32, 32);
		health = 5;

		animation.add("BirdFly", [0, 1, 2, 3, 4], 10, true);
		animation.play("BirdFly");
		scale.set(1.5, 1.5);
		for (i in 0 ... 5)
		{
			hpbarList[i] = 0;
		}
	}

  public function healthTracker() {
    if (health > 0 && invinc == false ) {
      health--;
	  invinc = true;
	  new FlxTimer().start(2, invincframe, 1); 
	  convertHPtoHeart(health);
    }
	if( health <= 0 ){
		dead = true;
		
		trace("Player died");
		
	}
    //game over, screen freezes and text appears
  }
  
  public function ConsumeFood() {

	if (health < 5)
	{
		health += .25;
		convertHPtoHeart(health);
	}
	if (ammo < 20 )
	{
		var reload:Int = 5;
		while (ammo < 20)
		{
		
			ammo += 1;
			reload -= 1;
			if (reload == 0)
			{
				break;
			}
		}
	}
  }
  public function invincframe(Timer:FlxTimer):Void{
	  invinc = false;
	  
  }

  public function diveForFood() {
    //on button press, move player vertically down the screen
  }

  public function convertHPtoHeart(health:Float){
	  var convert:Float = health;
	  var tracker:Int = 0;
	  while (convert != 0)
	  {
		  if (convert >= 1)
		  {
			  convert -= 1;
			  hpbarList[tracker] = 0;
			  tracker += 1;
		  }
		  else if (convert == .75)
		  {
			  convert -= .75;
			  hpbarList[tracker] = 4;
			  tracker += 1;
		  }
		  else if (convert == .5)
		  {
			  convert -= .5;
			  hpbarList[tracker] = 3;
			  tracker += 1;
		  }
		  else if (convert == .25)
		  {
			  convert -= .25;
			  hpbarList[tracker] = 2;
			  tracker += 1;
		  }
		  else if (convert < 0)
		  {
			  convert = 0;
		  }
	  }
	  if (tracker < 5)
	  {
		  for (i in tracker ... 5)
		  {
			  hpbarList[i] = 1;
		  }
	  }
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
