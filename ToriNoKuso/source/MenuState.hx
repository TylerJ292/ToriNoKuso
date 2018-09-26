package;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flash.system.System;
/**
 * ...
 * @author ...
 */
class MenuState extends FlxState
{

	var _playButton : FlxButton;
	var _quitButton: FlxButton;
	override public function create():Void
	{
		_playButton = new FlxButton(20, 20, "", clickPlay);
		_playButton.loadGraphic("assets/images/Playbutton.png");
		_playButton.screenCenter();
		_playButton.y += 30;
		_quitButton = new FlxButton(20, 20, "", quit);
		_quitButton.loadGraphic("assets/images/Quitbutton.png");
		_quitButton.screenCenter();
		_quitButton.y += 130;
		add(_playButton);
		add(_quitButton);
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	function quit():Void
	{
		System.exit(0);
	}
}