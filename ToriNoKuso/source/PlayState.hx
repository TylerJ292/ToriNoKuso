package;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import level.LevelManager;

class PlayState extends FlxState
{
	public var _player:Bird;
	
	public var Rocks:FlxTypedGroup<Rock> = new FlxTypedGroup<Rock>();
	
	override public function create():Void
	{
		level.LevelManager.state = this;
		
		FlxG.camera.bgColor= FlxColor.BLUE;
		
		new FlxTimer().start(2, spawnSQ, 0);
		level.LevelManager.startLevelGen();
		
		_player = new Bird(50,50);
		add(_player);
		
		super.create();

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		level.LevelManager.update(elapsed);
	}
	
	public function spawnSQ(Timer:FlxTimer):Void
	{
		var _ran:FlxRandom = new FlxRandom();
		var _rNum:Int = Std.int(_ran.float(2, 10));
		var _rNum2:Int = Std.int(_ran.float(1, 4));
		var _sq:Squirrel = new Squirrel(FlxG.width + 10 , _rNum * 20, 1, _rNum2 );
		add(_sq);
		_sq.move();
	}

}
