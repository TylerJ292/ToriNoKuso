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
	public var pullUp:Bool = false;
	 var sqTimer:FlxTimer;

	override public function create():Void
	{
    level.LevelManager.state = this;
    FlxG.camera.bgColor= FlxColor.BLUE;
	//SquirrelSpawn System created
    sqTimer = new FlxTimer().start(2, spawnSQ, 0);
		new FlxTimer().start(180, spawnBoss, 1);
    
    level.LevelManager.startLevelGen();
    _sqgroup = new FlxTypedGroup<Squirrel>(0);
		_player = new Bird(50,50);

		add(_player);
    
		super.create();
		//trace(FlxG.width, FlxG.height);

	}

	override public function update(elapsed:Float):Void
	{
		
		bossMovement();
		super.update(elapsed);
    playerMovement();
		collisionCheck();
		
		level.LevelManager.update(elapsed);
		for (members in _sqgroup)
		{
			members.checkdead();
			
		}
	}

	public function spawnBoss(Timer:FlxTimer):Void{
		bossSpawned = true;
		_boss = new Boss(FlxG.width -50, FlxG.height/3);
		add(_boss);
		// sqTimer.destroy();
	}
	
	public function bossMovement(){
		if (bossSpawned && !_boss.grounded){
			if (_boss.x <= 0 || _boss.x +32 >= FlxG.width){
				_boss.directedCharge = false;
				
				_boss.bossDirX = -_boss.bossDirX;
				_boss.x += _boss.bossDirX;
				
				var _ran:FlxRandom = new FlxRandom();
				bossAngle = Std.int(_ran.float(40, 70));
				
				var _ran:FlxRandom = new FlxRandom();
				bossPattern = Std.int(_ran.float(0, 5));
			}
			if (_boss.y <= 32 || _boss.y -32 >= FlxG.height - 200){
				_boss.bossDirY = -_boss.bossDirY;
				_boss.y += _boss.bossDirY;
			}
			
			_boss.bossMove(bossPattern, bossAngle, _player);
		}
		else if(bossSpawned && _boss.grounded && _boss.y >= 32){
			_boss.velocity.set(_boss.bossDirX * 100, 50);
		}
	}

	public function playerMovement(){

		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
			if(_player.x > 0){
				_player.x -= 2;
			}
			
		}
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
			if(_player.x < 600){
				_player.x += 2;
			}
			
		}
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
			if(_player.y > 0){
				_player.y -= 2;
			}
			
		}
		//288
		if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
			if(_player.y < 500){
				_player.y += 2;
			}
		}
		if(_player.dive){
			if(!pullUp){
				_player.velocity.set(150, 150);
			}
			else if(pullUp){
				_player.velocity.set(150, -150);
			}
			if(_player.y <= FlxG.height - 32){
				pullUp = true;
			}
			if(_player.y >= 288){
				_player.dive = false;
			}
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
			
			var _sq:Squirrel = new Squirrel(FlxG.width + 10 , _rNum * 20,  _rNum2 );
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
		// Need to make a poop group
		/* if(FlxG.overlap(_boss, _poopGroup) && !_boss.grounded){
			_boss.drop();
		} */
		if(bossSpawned && _boss.grounded && FlxG.overlap(_player, _boss)){
			_boss.damage();
		}
	}
	
}
