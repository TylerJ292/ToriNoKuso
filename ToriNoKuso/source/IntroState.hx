package;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class IntroState extends FlxState
{

	var bird:Bird;
	var sq1:Squirrel;
	var sq2:Squirrel;
	var fridge:Fridge;
	
	override public function create():Void
	{
		bird = new Bird(50, 50);
		sq1 = new Squirrel(150,50, 7, bird);
		sq2 = new Squirrel(182, 50, 7, bird);
		fridge = new Fridge(150, 82);
		
		new FlxTimer().start(15, play, 1);
		
		new FlxText(20, 300, "One day The Bird was minding his own business when suddenly, flying squirrels break into his house and steal his fridge.
			 Now, The Bird must seek out revenge on the squirrel king and take back his fridge.", 12);
	}
	
	override public function update(elapsed:Float):Void
	{
		sq1.velocity.set(50, 0);
		sq2.velocity.set(50, 0);
		fridge.velocity.set(50, 0);
		super.update(elapsed);
	}
	
	public function play(Timer:FlxTimer):Void{
		FlxG.switchState(new PlayState());
	}
	
}