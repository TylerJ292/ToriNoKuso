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
import flixel.math.FlxMath;

class PlayState extends FlxState
{

	public var _player:Bird;
	public var _sqgroup:FlxTypedGroup<Squirrel>;
	public var _Ammogroup:FlxTypedGroup<Ammo>;
	public var Rocks:FlxTypedGroup<Rock> = new FlxTypedGroup<Rock>();
	var _boss:Boss;
	var bossPattern:Int = 0;
	var bossSpawned:Bool = false;
	public var bossAngle:Float;
	public var canShoot:Bool = true;
	public var pullUp:Bool = false;
	var sqTimer:FlxTimer;
	public var dive:Bool = false;

	override public function create():Void
	{
    level.LevelManager.state = this;
    FlxG.camera.bgColor= FlxColor.BLUE;
	//SquirrelSpawn System created
    sqTimer = new FlxTimer().start(2, spawnSQ, 1);
		new FlxTimer().start(1, spawnBoss, 1);
    
    level.LevelManager.startLevelGen();
    _sqgroup = new FlxTypedGroup<Squirrel>(0);
		_Ammogroup = new FlxTypedGroup<Ammo>(0);

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
		Shoot();
		collisionCheck();
		if(dive){
			_player.diving();
			if(!_player.dive){
				dive = false;
			}
		}
		level.LevelManager.update(elapsed);
		for (members in _sqgroup)
		{
			members.checkdead();
			
		}
			FlxG.overlap(_Ammogroup, _sqgroup, sqgotHit);
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
			if(_boss.directedCharge){
				if(_boss.y <= 32){
					_boss.velocity.set(_boss.velocity.x, -_boss.velocity.y);
				}
				else if(_boss.y -32 >= FlxG.height - 200){
					_boss.velocity.set(_boss.velocity.x, -FlxMath.absInt(Std.int(_boss.velocity.y)));
				}
			}
			_boss.bossMove(bossPattern, bossAngle, _player);
		}
		else if(bossSpawned && _boss.grounded && _boss.y <= FlxG.height - 64){
			if(_boss.x < 0 || _boss.x > FlxG.width - 32){
				_boss.velocity.set(_boss.bossDirX * 50, 100);
				bossPattern = 5;
			}
			else{
				_boss.velocity.set(0, 100);
				bossPattern = 5;
			}
		}
		else if(bossSpawned){
			_boss.velocity.set(0, 0);
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
		if(FlxG.keys.pressed.X) {
			dive = true;
		}
	}

	
	public function Shoot(){
		if (FlxG.keys.pressed.Z && _player.ammo > 0 && canShoot == true) {
	
		canShoot = false;
		var _poop:Ammo = new Ammo(_player.x, _player.y);
		add(_poop);
		new FlxTimer().start(.5, shootreset, 1);
		_Ammogroup.add(_poop);
		}
	}
	public function shootreset(Timer:FlxTimer):Void{
		canShoot = true;
	}
	public function sqgotHit(poop:Ammo, sq:Squirrel):Void
	{
		sq.dropdead();
		poop.destroy();
		
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
		if(FlxG.overlap(_player, _sqgroup) || (FlxG.overlap(_player, _boss) && !_boss.grounded)) {
			_player.healthTracker();
		}
		if(bossSpawned && FlxG.overlap(_boss, _Ammogroup) && !_boss.grounded && !_boss.invincible){
			_boss.drop(_player);
		}
		if(bossSpawned && _boss.grounded && FlxG.overlap(_player, _boss) && !_boss.invincible){
			bossSpawned = _boss.damage();
		}
	}
	
}
