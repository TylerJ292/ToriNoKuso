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
class GameOverState extends FlxState
{
	var _playagainButton : FlxButton;
	var _menuButton: FlxButton;
	var _quitButton: FlxButton;
	var _win: FlxSprite =  new FlxSprite(0,0);
	override public function create():Void
	{
		var score:Float = LevelManager.state.trackSCORE;
		_win.loadGraphic("assets/images/ReturnHome.png", true, 32, 64);	
		_win.animation.add("BirdWin", [0, 1, 2, 3, 4], 10, true);
		_win.animation.play("BirdWin");
		_win.screenCenter();
		_win.scale.set(2, 2);
		_win.y -= 30;
		var disscore:FlxText = new flixel.text.FlxText(400, 7, 0, Std.string(score), 50);
		disscore.screenCenter();
		disscore.y -= 150;
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