package;

import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
	var _player:Bird;
	
	override public function create():Void
	{
		
		new FlxTimer().start(2, spawnSQ, 0);

		_player = new Bird(50,50);
		add(_player);

		super.create();


	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_player.movement();
	}


	public function spawnSQ(Timer:FlxTimer):Void
	{

		var _ran:FlxRandom = new FlxRandom();
		var _rSpawn:Int = Std.int(_ran.float(1, 5));
		trace("new");
		for (i in 0..._rSpawn )
		{
			var _rNum:Int = Std.int(_ran.float(2, 10));
			var _rNum2:Int = Std.int(_ran.float(1, 5));
			trace(_rNum2);
			var _sq:Squirrel = new Squirrel(FlxG.width + 10 , _rNum * 20, 1, _rNum2 );
			add(_sq);
			_sq.move(_player);
		}
	}

}
