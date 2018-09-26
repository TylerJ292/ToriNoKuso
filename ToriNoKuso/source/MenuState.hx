package;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flash.system.System;
import level.LevelManager;
/**
 * ...
 * @author ...
 */
class MenuState extends FlxState
{

	var _playButton : FlxButton;
	var _quitButton: FlxButton;
	var _frontpic: FlxSprite = new FlxSprite(0,0);
	override public function create():Void
	{

		_frontpic.loadGraphic("assets/images/Title Screen.png", true, 640, 480);
		_frontpic.screenCenter();
		_playButton = new FlxButton(20, 20, "", clickPlay);
		_playButton.loadGraphic("assets/images/Playbutton.png");
		_playButton.screenCenter();
		_playButton.y += 30;
		_quitButton = new FlxButton(20, 20, "", quit);
		_quitButton.loadGraphic("assets/images/Quitbutton.png");
		_quitButton.screenCenter();
		_quitButton.y += 130;
		add(_frontpic);
		add(_playButton);
		add(_quitButton);
		super.create();

		#if flash
			FlxG.sound.playMusic(AssetPaths.menu_music__mp3);
		#else
			FlxG.sound.playMusic(AssetPaths.menu_music__wav);
		#end

		// #if flash
		// 	FlxG.sound.playMusic("assets/music/menu_music__mp3");
		// #else
		// 	FlxG.sound.playMusic("assets/music/menu_music__wav");
		// #end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		
	}

	function clickPlay():Void
	{
		LevelManager.restart();
		FlxG.switchState(new PlayState());
	}

	function quit():Void
	{
		System.exit(0);
	}
}
