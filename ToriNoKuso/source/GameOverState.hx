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
	var _dead: FlxSprite =  new FlxSprite(0,0);
	override public function create():Void
	{
		var score:Float = LevelManager.state.trackSCORE;
		_dead.loadGraphic("assets/images/Dead.png", true, 32, 32);
		_dead.screenCenter();
		_dead.scale.set(2, 2);
		_dead.y -= 30;
		var sign:FlxText = new flixel.text.FlxText(400, 7, 0, "GAME OVER", 60);
		sign.screenCenter();
		sign.y -= 180;
		var disscore:FlxText = new flixel.text.FlxText(400, 7, 0, Std.string(score), 45);
		disscore.screenCenter();
		disscore.y -= 110;
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
		add(_dead);
		add(sign);
		super.create();

		#if flash
			FlxG.sound.playMusic(AssetPaths.menu_music__mp3);
		#else
			FlxG.sound.playMusic(AssetPaths.menu_music__wav);
		#end
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
