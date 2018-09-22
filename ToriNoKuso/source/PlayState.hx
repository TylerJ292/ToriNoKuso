package;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxCollision;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import level.LevelManager;

class PlayState extends FlxState
{

	public var _player:Bird;
	public var _sqgroup:FlxTypedGroup<Squirrel>;
	
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
    _sqgroup = new FlxTypedGroup<Squirrel>(0);
		_player = new Bird(50,50);

		add(_player);
		
		_boss = new Boss(FlxG.width -50, FlxG.height/3);
		add(_boss);
    
		super.create();
		//trace(FlxG.width, FlxG.height);

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
    playerMovement();
		collisionCheck();
		
		level.LevelManager.update(elapsed);
	}

	public function spawnBoss(Timer:FlxTimer):Void{
		bossSpawned = true;
		// sqTimer.destroy();
	}

	public function playerMovement(){

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
	
	//need to add delay so that there is a couple seconds of "invincibility" after
	//the first instance of a collision
	public function collisionCheck(){
		if(FlxG.overlap(_player, _sqgroup)) {
			_player.healthTracker();
		}
	}
	
}
