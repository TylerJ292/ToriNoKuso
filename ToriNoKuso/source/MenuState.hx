package;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flash.system.System;
import level.LevelManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;

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

		var sign:FlxText = new flixel.text.FlxText(400, 7, 0, "Snack", 70);
		var sign2:FlxText = new flixel.text.FlxText(400, 7, 0, "Snatcher", 70);
		sign.screenCenter();
		sign.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		sign2.screenCenter();
		sign.y -= 180;
		sign2.y -= 80;
		sign2.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
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
		add(sign);
		add(sign2);
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
