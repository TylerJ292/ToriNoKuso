package;
import flixel.FlxState;
import flixel.animation.FlxAnimation;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class EndScene extends FlxState 
{

override public function create():Void
	{
		var story:FlxText = new flixel.text.FlxText(0, 0, 0, "After the long and arduous journey", 20);
		var story1:FlxText = new flixel.text.FlxText(0, 0, 0, "The Bird had done it.", 20);
		var story2:FlxText = new flixel.text.FlxText(0, 0, 0, "He defeated the squirrel army and ", 20);
		var story3:FlxText = new flixel.text.FlxText(0, 0, 0, "took his fridge back from the king.", 20);
		var story4:FlxText = new flixel.text.FlxText(0, 0, 0, "Now there was only one question left.", 20);
		var story5:FlxText = new flixel.text.FlxText(0, 0, 0, "After the long and arduous journey", 20);
		var story6:FlxText = new flixel.text.FlxText(0, 0, 0, "How was he gonna get this thing home?", 20);
		story.screenCenter();
		story1.screenCenter();
		story2.screenCenter();
		story3.screenCenter();
		story4.screenCenter();
		story5.screenCenter();
		story6.screenCenter();
		story.y -= 200;
		story1.y -= 160;
		story2.y -= 120;
		story3.y -= 80;
		story4.y -= 40;
		story6.y += 40;
		add(story);
		add(story1);
		add(story2);
		add(story3);
		add(story4);
		add(story5);
		add(story6);
		var _end: FlxSprite =  new FlxSprite(500, 350);
		_end.loadGraphic("assets/images/ReturnHome.png", true, 32, 64);	
		_end.animation.add("BirdWin", [0, 1], 10, true);
		_end.animation.play("BirdWin");
		_end.velocity.x = -15;
		add(_end);
		new FlxTimer().start(10, EndtheGame, 1);
		super.create();
	}
	public function EndtheGame(Timer:FlxTimer):Void{
		FlxG.switchState(new WinState());
	}
}