package;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG; 
import level.LevelManager;
import flash.system.System;


/**
 * ...
 * @author ...
 */
class WinState extends FlxState
{
	var _playagainButton : FlxButton;
	var _menuButton: FlxButton;
	var _quitButton: FlxButton;
	override public function create():Void
	{
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