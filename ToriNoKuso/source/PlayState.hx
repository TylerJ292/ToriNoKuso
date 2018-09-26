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
import flixel.text.FlxText;
import flixel.math.FlxMath;

class PlayState extends FlxState
{

	public var _score:Int = 0;
	public var trackSCORE:Int = 0;
	public var trackscore2:Int = 0;
	public var trackCount:Array<FlxText> = new Array<FlxText>();
	
	public var _player:Bird;
	public var playerSpd:Int = 3;
	public var _sqgroup:FlxTypedGroup<Squirrel>;
	public var _Ammogroup:FlxTypedGroup<Ammo>;
	public var _HPgroup:FlxTypedGroup<Heart> = new FlxTypedGroup<Heart>();
	public var Rocks:FlxTypedGroup<Rock> = new FlxTypedGroup<Rock>();
	public var ammoCount:Array<FlxText> = new Array<FlxText>();
	
	var _boss:Boss;
	var bossPattern:Int = 0;
	var bossSpawned:Bool = false;
	public var bossAngle:Float;
	public var canShoot:Bool = true;
	public var pullUp:Bool = false;
	var sqSpawnTimer:FlxTimer;
	var sqTimer:FlxTimer;
	var sqTimeNum:Int = 0;
	public var dive:Bool = false;
	public var trackHP:Float = 0;
	public var trackAMMO:Int = 0;
	
	
	override public function create():Void
	{
		
		
		FlxG.fullscreen = true;
    level.LevelManager.state = this;
    FlxG.camera.bgColor = FlxColor.BLACK;
	FlxG.fixedTimestep = false;
	
	//SquirrelSpawn System created
		new FlxTimer().start(10, spawnSpawnSQ, 1);
		new FlxTimer().start(70, SQIncreaseDifficulty, 1);
		new FlxTimer().start(130, SQIncreaseDifficulty, 1);
		new FlxTimer().start(180, spawnBoss, 1);
   
    level.LevelManager.startLevelGen();
    _sqgroup = new FlxTypedGroup<Squirrel>(0);
		_Ammogroup = new FlxTypedGroup<Ammo>(0);
		_player = new Bird(50, 50);
		trackscore2 = trackSCORE;
		add(_player);
		trackHP = _player.health;
		trackAMMO = _player.ammo;
		convertArrayToHealth(_player.hpbarList);
		var _poopicon:Heart = new Heart( 225 , 10, 5);
		add(_poopicon);
	  var disammo:FlxText = new flixel.text.FlxText(260, 7, 0, "X " + Std.string(_player.ammo), 20);
		var disscore:FlxText = new flixel.text.FlxText(400, 7, 0, Std.string(trackSCORE), 20);
		add(disammo);
		add(disscore);
		ammoCount[0] = disammo;
		trackCount[0] = disscore;
		super.create();
		trace(FlxG.width, FlxG.height);

	}

	override public function update(elapsed:Float):Void
	{
		
		bossMovement();
		super.update(elapsed);
		if(_player.dead == false){
		playerMovement();
		Shoot();
		}
		collisionCheck();
		if(_player.dead == false){
		if(dive){
			_player.diving();
			if(!_player.dive){
				dive = false;
			}
		}
		}
		level.LevelManager.update(elapsed);
		
		for (members in _sqgroup)
		{
			members.checkdead();
			
		}
		for (members in _Ammogroup)
		{
			members.checkdead();
			
		}
			FlxG.overlap(_Ammogroup, _sqgroup, sqgotHit);
			if (trackHP != _player.health)
			{
				convertArrayToHealth(_player.hpbarList);
			}
			if (trackAMMO != _player.ammo)
			{
				trackAMMO = _player.ammo;
				var temp:FlxText = ammoCount.pop();
				temp.destroy();
				var disammo:FlxText = new flixel.text.FlxText(260, 7, 0, "X " + Std.string(_player.ammo), 20);
				add(disammo);
				ammoCount[0] = disammo;
			}
			if (trackscore2 != trackSCORE)
			{
				trackscore2 = trackSCORE;
				var temp:FlxText = trackCount.pop();
				temp.destroy();
				var nscore:FlxText = new flixel.text.FlxText(400, 7, 0, Std.string(trackSCORE), 20);
				add(nscore);
				trackCount[0] = nscore;
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
				_boss.flipX = !_boss.flipX;
				
				var _ran:FlxRandom = new FlxRandom();
				bossAngle = Std.int(_ran.float(40, 70));
				
				var _ran:FlxRandom = new FlxRandom();
				bossPattern = Std.int(_ran.float(0, 5));
			}
			if (_boss.y <= 16 || _boss.y -64 >= FlxG.height - 200){
				_boss.bossDirY = -_boss.bossDirY;
				_boss.y += _boss.bossDirY;
			}
			if(_boss.directedCharge){
				if(_boss.y <= 64){
					_boss.velocity.set(_boss.velocity.x, -_boss.velocity.y);
				}
				else if(_boss.y -64 >= FlxG.height - 200){
					_boss.velocity.set(_boss.velocity.x, -FlxMath.absInt(Std.int(_boss.velocity.y)));
				}
			}
			_boss.bossMove(bossPattern, bossAngle, _player);
		}
		else if(bossSpawned && _boss.grounded && _boss.y <= FlxG.height - 98){
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
			if(_player.x > 18){
				_player.x -= playerSpd;
			}
			
		}
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
			if(_player.x < FlxG.width - 48){
				_player.x += playerSpd;
			}
			
		}
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
			if(_player.y > 0){
				_player.y -= playerSpd;
			}
		}
		//288
		if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
			if(_player.y < FlxG.height - 232){
				_player.y += playerSpd;
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
		if(_player.ammo > 0){
		_player.ammo -= 1;
		
		}
		}
	}
	public function shootreset(Timer:FlxTimer):Void{
		canShoot = true;
	}
	public function sqgotHit(poop:Ammo, sq:Squirrel):Void
	{
		sq.dropdead();
		poop.destroy();
		trackSCORE += 500;
	}
	
	public function spawnSQ(Timer:FlxTimer):Void
	{

		var _ran:FlxRandom = new FlxRandom();
		var _rSpawn:Int = Std.int(_ran.float(1 + sqTimeNum, 3 + sqTimeNum));
		
		for (i in 0..._rSpawn )
		{
			var _rNum:Int = Std.int(_ran.float(2, 10));
			var _rNum2:Int = Std.int(_ran.float(1, 7));
			var _rNum3:Float = _ran.float(0, 2);
			var _sq:Squirrel = new Squirrel(FlxG.width + 10 , _rNum * 20,  _rNum2 , _player);
			add(_sq);
			_sqgroup.add(_sq);
			_sq.delayMove(_player, _rNum3);
			
		}
	}
	
	public function spawnSpawnSQ(Timer:FlxTimer):Void{
		sqTimer = new FlxTimer().start(2, spawnSQ, 0);
		
	}
	public function SQIncreaseDifficulty(Timer:FlxTimer):Void{
		sqTimeNum += 1;
		
	}
	//need to add delay so that there is a couple seconds of "invincibility" after
	//the first instance of a collision
	public function collisionCheck(){
		if(FlxG.overlap(_player, _sqgroup) ) {
			_player.healthTracker(.5);
		}
		if (FlxG.overlap(_player, _boss) && !_boss.grounded){
			_player.healthTracker(1);
		}
		if ( FlxG.overlap(_player, Rocks)){
			_player.healthTracker(.5);
		}
		if (bossSpawned && FlxG.overlap(_boss, _Ammogroup) && !_boss.grounded && !_boss.invincible){
			_boss.drop(_player);
			
		}
		if(bossSpawned && _boss.grounded && FlxG.overlap(_player, _boss) && !_boss.invincible){
			bossSpawned = _boss.damage();
		}
	}
	
	public function convertArrayToHealth(HPArray:Array<Int>)
	{
		trackHP = _player.health;
		_HPgroup.clear();
		for (i in _HPgroup)
		{
			i.destroy();
		}
		var num:Int = 0;
		for (i in HPArray)
		{
			var _heart:Heart = new Heart( 40 * (num),0, i);
			num += 1;
			add(_heart);
			_HPgroup.add(_heart);
			
		}
		
		
	}

}

