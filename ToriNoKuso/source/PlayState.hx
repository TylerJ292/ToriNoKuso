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
	var _boss:Boss;
	var bossPattern:Int = 0;
	var bossSpawned:Bool = false;
	public var bossAngle:Float;

	override public function create():Void
	{
    level.LevelManager.state = this;
    FlxG.camera.bgColor= FlxColor.BLUE;
		
    var sqTimer:FlxTimer = new FlxTimer().start(2, spawnSQ, 0);
		new FlxTimer().start(180, spawnBoss, 1);
    
    level.LevelManager.startLevelGen();
    
		var _player:Bird = new Bird(50,50);
		add(_player);
		
		_boss = new Boss(FlxG.width -50, FlxG.height/3);
		add(_boss);
    
		super.create();

	}

	override public function update(elapsed:Float):Void
	{
		if (bossSpawned && !_boss.grounded){
			if (_boss.x <= 0 || _boss.x +48 >= FlxG.width){
				_boss.directedCharge = false;
				
				_boss.bossDirX = -_boss.bossDirX;
				
				var _ran:FlxRandom = new FlxRandom();
				bossAngle = Std.int(_ran.float(40, 70));
				
				var _ran:FlxRandom = new FlxRandom();
				bossPattern = Std.int(_ran.float(0, 5));
			}
			if (_boss.y <= 32 || _boss.y -48 >= FlxG.height){
				_boss.bossDirY = -_boss.bossDirY;
			}
			
			_boss.bossMove(bossPattern, bossAngle);
		}
			
		super.update(elapsed);
		
		level.LevelManager.update(elapsed);
	}

	public function spawnBoss(Timer:FlxTimer):Void{
		bossSpawned = true;
		// sqTimer.destroy();
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
