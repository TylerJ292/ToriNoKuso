package;

import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
	
	override public function create():Void
	{
		new FlxTimer().start(2, spawnSQ, 0);
		
		super.create();
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
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
