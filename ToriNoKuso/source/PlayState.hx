package;

import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{

	var _player:Bird;
	var _sqgroup:FlxTypedGroup<Squirrel>;
	override public function create():Void
	{
		
		new FlxTimer().start(2, spawnSQ, 0);
		_sqgroup = new FlxTypedGroup<Squirrel>(0);

		_player = new Bird(50,50);
		add(_player);

		super.create();
		//trace(FlxG.width, FlxG.height);

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
			_player.x-=2;
		}
		if(FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
			_player.x+=2;
		}
		if(FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
			_player.y-=2;
		}
		if(FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
			_player.y+=2;
		}
		
		for (members in _sqgroup)
		{
			members.checkdead();
			
		}
		FlxG.overlap(_player, _sqgroup, sqgotHit);
		
	
	}

	public function sqgotHit(player:Bird, sq:Squirrel):Void
	{
		sq.dropdead();
		
	}
	public function spawnSQ(Timer:FlxTimer):Void
	{

		var _ran:FlxRandom = new FlxRandom();
		var _rSpawn:Int = Std.int(_ran.float(1, 3));
		
		for (i in 0..._rSpawn )
		{
			var _rNum:Int = Std.int(_ran.float(2, 10));
			var _rNum2:Int = Std.int(_ran.float(1, 7));
			
			var _sq:Squirrel = new Squirrel(FlxG.width + 10 , _rNum * 20, 1, _rNum2 );
			add(_sq);
			_sqgroup.add(_sq);
			_sq.move(_player);
		}
	}
	
}
