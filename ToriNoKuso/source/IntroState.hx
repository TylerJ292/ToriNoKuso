package;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxG;
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
		sq1 = new Squirrel(150, 50, 7, bird);
		sq1.flipX = true;
		sq2 = new Squirrel(182, 50, 7, bird);
		fridge = new Fridge(150, 82);
		sq2.flipX = true;
		add(bird);
		add(sq1);
		add(sq2);
		add(fridge);
		//240
		//160
		var story:FlxText = new flixel.text.FlxText(0, 0, 0, "One day The Bird was minding his", 20);
		var story1:FlxText = new flixel.text.FlxText(0, 0, 0, " own business when suddenly, flying.", 20);
		var story2:FlxText = new flixel.text.FlxText(0, 0, 0, " squirrels break into his house ", 20);
		var story3:FlxText = new flixel.text.FlxText(0, 0, 0, " and steal his fridge. ", 20);
		var story4:FlxText = new flixel.text.FlxText(0, 0, 0, " The Bird must seek out revenge on the", 20);
		var story5:FlxText = new flixel.text.FlxText(0, 0, 0, " squirrel king and take back his fridge.", 20);
		story.screenCenter();
		story1.screenCenter();
		story2.screenCenter();
		story3.screenCenter();
		story4.screenCenter();
		story5.screenCenter();
		story.y -= 80;
		story1.y -= 50;
		story2.y -= 20;
		story3.y += 10;
		story4.y += 40;
		story5.y += 70;
		add(story);
		add(story1);
		add(story2);
		add(story3);
		add(story4);
		add(story5);
		new FlxTimer().start(5, StartGame, 1);
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		sq1.velocity.set(50, 0);
		sq2.velocity.set(50, 0);
		fridge.velocity.set(50, 0);
		super.update(elapsed);
	}
	
	public function StartGame(Timer:FlxTimer):Void{
		FlxG.switchState(new PlayState());
	}

}