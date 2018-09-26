package;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG; 
import level.LevelManager;
import flash.system.System;
import flixel.text.FlxText;

/**
 * ...
 * @author ...
 */
class WinState extends FlxState
{
	var _playagainButton : FlxButton;
	var _menuButton: FlxButton;
	var _quitButton: FlxButton;
	var _win: FlxSprite =  new FlxSprite(0, 0);
	var _win1: FlxSprite =  new FlxSprite(0, 0);
	var _win2: FlxSprite =  new FlxSprite(0, 0);
	var _win3: FlxSprite =  new FlxSprite(0,0);
	override public function create():Void
	{
		var score:Float = LevelManager.state.trackSCORE;
		_win.loadGraphic("assets/images/ReturnHome.png", true, 32, 64);	
		_win.animation.add("BirdWin", [0, 1], 10, true);
		_win.animation.play("BirdWin");
		_win.screenCenter();
		_win.scale.set(2, 2);
		_win.y -= 50;
		_win.x -= 200;
		_win.flipX = true;
		_win1.loadGraphic("assets/images/Pigeon.png", true, 32, 32);	
		_win1.screenCenter();
		_win1.animation.add("BirdWin1", [1], 10, true);
		_win1.animation.play("BirdWin1");
		_win1.y -= 50;
		_win1.x += 150;
		_win1.flipX = true;
		_win2.loadGraphic("assets/images/Pigeon.png", true, 32, 32);	
		_win2.screenCenter();
		_win2.animation.add("BirdWin1", [1], 10, true);
		_win2.animation.play("BirdWin1");
		_win2.x += 200;
		_win2.y -= 50;
		_win2.flipX = true;
		_win3.loadGraphic("assets/images/Pigeon.png", true, 32, 32);
		_win3.screenCenter();
		_win3.animation.add("BirdWin1", [1], 10, true);
		_win3.animation.play("BirdWin1");
		_win3.y -= 50;
		_win3.x += 250;
		_win3.flipX = true;
		var sign:FlxText = new flixel.text.FlxText(400, 7, 0, "YOU WIN!", 60);
		sign.screenCenter();
		sign.y -= 160;
		var disscore:FlxText = new flixel.text.FlxText(400, 7, 0, Std.string(score), 60);
		disscore.screenCenter();
		disscore.y -= 70;
		_playagainButton = new FlxButton(20, 20, "", playagain);
		_playagainButton.loadGraphic("assets/images/Playagainbutton.png");
		_playagainButton.screenCenter();
		_playagainButton.y += 100;
		_menuButton = new FlxButton(20, 20, "", menu);
		_menuButton.loadGraphic("assets/images/Menubutton.png");
		_menuButton.screenCenter();
		_menuButton.y += 30;
		_quitButton = new FlxButton(20, 20, "", quit);
		_quitButton.loadGraphic("assets/images/Quitbutton.png");
		_quitButton.screenCenter();
		_quitButton.y += 170;
		add(_playagainButton);
		add(_menuButton);
		add(_quitButton);
		add(disscore);
		add(_win);
		add(_win1);
		add(_win2);
		add(_win3);
		add(sign);
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function playagain():Void
	{
		LevelManager.restart();
		FlxG.switchState(new PlayState());
	}
	
	function menu():Void
	{
		
		FlxG.switchState(new MenuState());
	}
	
	function quit():Void
	{
		System.exit(0);
	}
}