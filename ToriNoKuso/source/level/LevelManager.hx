package level;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import haxe.Timer;
import flixel.tile.FlxTilemap;

/**
 * The LevelManager keeps track of backgrounds, people, abd obstacles created, and generates new obstacles.
 * 
 * @author Jay
 */
class LevelManager
{
    public static var instance(default, null):LevelManager = new LevelManager();
	public static var state:PlayState = null;
	
	//width and height in tile units
	public static var segmentWidth = 15;
	public static var segmentHeight = 15;
	public static var unit = 32;
	
	//containers
	public static var LevelObjects:FlxTypedGroup<LevelObject> = new FlxTypedGroup<LevelObject>(); //all obstacles
	public static var BackgroundObjects:FlxGroup = new FlxGroup();	//default ordering is to place all level objects in background objects
	public static var ForegroundObjects:FlxGroup = new FlxGroup();
	public static var Obstacles:FlxTypedGroup<Obstacle> = new FlxTypedGroup<Obstacle>(); //all obstacles
	public static var Solids:FlxTypedGroup<LevelObject> = new FlxTypedGroup<LevelObject>(); //for things people collide with
	public static var People:FlxTypedGroup<Person> = new FlxTypedGroup<Person>();
	public static var FoodObjects:FlxTypedGroup<Food> = new FlxTypedGroup<Food>();
	public static var BuildingTiles:FlxTypedGroup<BuildingTile> = new FlxTypedGroup<BuildingTile>();
	
	//level gen
	public static var RightmostObject:LevelObject = null;
	
	public static var BuildingHeight0:Int;
	public static var BuildingHeightMax0:Int = 13;
	public static var BuildingHeightMin0:Int = 4;
	
	public static var BuildingHeight1:Int;
	public static var BuildingHeightMax1:Int = 16;
	public static var BuildingHeightMin1:Int = 8;
	
	public static var stopChance:Float = 0.8; //decreases by .1 every 20 seconds until it is .1
	public static var lampChance:Float = 0.2;  //increases by .1 every 20 seconds until it is .9
	
	//level
	public static var screenSpeed:Float = -50;
	
	private function new() { }
	
	public static function startLevelGen() {
		FlxG.worldBounds.set( -0.5 * FlxG.width, 0, FlxG.width * 1.55, FlxG.height);
		
		state.add(BackgroundObjects);
		state.add(People);
		state.add(ForegroundObjects);
		
		BuildingHeight0 = new FlxRandom().int(BuildingHeightMin0, BuildingHeightMax0);
		BuildingHeight1 = new FlxRandom().int(BuildingHeightMin1, BuildingHeightMax1);
		
		genSky();
		
		new FlxTimer().start(20, function(_t:FlxTimer){
			stopChance -= .1;
			lampChance += .1;
		},7);
		
		genSegment();
	}
	
	public static function update(elapsed:Float):Void
	{
		
		if (RightmostObject.getPosition().x < FlxG.width * 2){
			genSegment();
		}
		
		/**		COLLISION DETECTION WITH LEVEL OBJECTS GOES HERE	**/
		
		//bird vs. obstacle
		if (FlxG.overlap(state._player, Obstacles)) state._player.healthTracker(.25);
		
		//people physics
		FlxG.collide(People, Solids, Person.onCollision);
		//check for diving bird attacking person
		FlxG.overlap(state._player, People, function( _b:Bird, _p:Person){ _p.onDiveAttack(_b);});
		
		//food collision
		FlxG.overlap(state._player, FoodObjects, function( _b:Bird, _f:Food){ _f.takeFood(_b); });
		
		//kuso collision
		FlxG.overlap(state._Ammogroup, Obstacles, function(_a:Ammo, _o:Obstacle){
			_a.kill();
		});
		FlxG.overlap(state._Ammogroup, People, function(_a:Ammo, _p:Person){_p.onAmmoAttack(_a); });
		
		for (obj in LevelObjects){
			obj.update(elapsed);
			if (!obj.alive){
				LevelObjects.remove(obj);
				state.remove(obj);
				obj.destroy();
			}
		}
	}
	
	/**
	 * Spawn the next segment of the level (15x15 by default)
	 */
	public static  function genSegment():Void
	{
		
		var leftX:Float = 0;
		if (RightmostObject != null){
			leftX = RightmostObject.getPosition().x + RightmostObject.getWidth();
		}
		
		var _ran:FlxRandom = new FlxRandom();
		
		BuildingHeight1 = LevelManager.genBuilding(BuildingHeight1, BuildingHeightMin1, BuildingHeightMax1, leftX, BuildingTile.GREEN);
		BuildingHeight0 = LevelManager.genBuilding(BuildingHeight0, BuildingHeightMin0, BuildingHeightMax0, leftX, BuildingTile.BLUE);
		
		//streetlamp
		if (_ran.float() < lampChance)
		{
			var lampHeight:Int = 8;
			for (i in 2...lampHeight)
				new LampPole(leftX+(8*unit), (segmentHeight - i) * unit, screenSpeed);
			new StreetLamp(leftX+(8*unit), (segmentHeight - lampHeight) * unit, screenSpeed);
		}	
		
		//stop sign
		if (_ran.float() < stopChance)
		{
			var stopHeight:Int = _ran.int(4, 5);
			for (i in 2...stopHeight)
				Solids.add(new StopPole(leftX, (segmentHeight - i) * unit, screenSpeed));
			new StopSign(leftX, (segmentHeight - stopHeight) * unit, screenSpeed);
		}	
		
		//generate sidewalk
		for ( i in 0...segmentWidth) {
			
			//floor
			var _floor = new Sidewalk(leftX + (i * unit), (segmentHeight - 2) * unit, screenSpeed, Sidewalk.SIDEWALK);
			new Sidewalk(leftX + (i * unit), (segmentHeight - 1) * unit, screenSpeed, Sidewalk.ROAD);
			
			if (i == segmentWidth - 1){
				RightmostObject = _floor;
			}
		}
		
		//table
		if (_ran.float() <= 0.3)
		{
			new PicnicTable(leftX+unit*4, (segmentHeight-2.5) * unit, screenSpeed);
			new Food(leftX + unit*5, (segmentHeight - 3.4) * unit, screenSpeed, true);
		}	
		
		//people
		for(i in 1..._ran.int(1,3)){
			new Person(leftX + (_ran.int(2*i,4*i)*unit), (segmentHeight - 3.5) * unit, screenSpeed);
		}
	}
	
	public static function genBuilding(BuildingHeight:Int, BuildingHeightMin:Int, BuildingHeightMax:Int, leftX:Float, _color:Int = 0):Int{
		var _ran:FlxRandom = new FlxRandom();
			//generate building one column at a time, change height in middle
			
		var _heightChange:Int = _ran.int(2, segmentWidth - 2);
		//var _oldBuildingHeight:Int = BuildingHeight;
		for ( i in 0...segmentWidth) {
			
			if (i == _heightChange){
				BuildingHeight = _ran.int(BuildingHeightMin, BuildingHeightMax);
			}
			
			for (j in 0...segmentHeight){
				if (j == BuildingHeight){
					if (i == _heightChange-1){
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.RIGHT_TOP, _color);
					}
					else if (i == _heightChange){
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.LEFT_TOP, _color);
					}
					else{
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.CENTER_TOP, _color);
					}
				}
				else if (j < BuildingHeight){
					if (i == _heightChange-1){
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.RIGHT_WINDOW, _color);
					}
					else if (i == _heightChange){
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.LEFT_WINDOW, _color);
					}
					else{
						new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.CENTER_WINDOW, _color);
					}
				}
			}
		}
		
		return BuildingHeight;
	}
	public static function restart()
	{
		 state = null;
		
		//width and height in tile units
		 segmentWidth = 15;
		 segmentHeight = 15;
		 unit = 32;
		
		//containers
		 LevelObjects = new FlxTypedGroup<LevelObject>(); //all obstacles
		 BackgroundObjects = new FlxGroup();	//default ordering is to place all level objects in background objects
		 ForegroundObjects = new FlxGroup();
		 Obstacles = new FlxTypedGroup<Obstacle>(); //all obstacles
		 Solids = new FlxTypedGroup<LevelObject>(); //for things people collide with
		 People = new FlxTypedGroup<Person>();
		 FoodObjects = new FlxTypedGroup<Food>();
		 BuildingTiles = new FlxTypedGroup<BuildingTile>();
		
		//level gen
		 RightmostObject = null;
		
		 BuildingHeight0;
		 BuildingHeightMax0 = 13;
		 BuildingHeightMin0 = 4;
		
		 BuildingHeight1;
		 BuildingHeightMax1 = 16;
		 BuildingHeightMin1 = 8;
		
		 stopChance = 1; //decreases by .1 every 20 seconds until it is .1
		 lampChance = 0;  //increases by .1 every 20 seconds until it is .9
		
		//level
		 screenSpeed = -50;
	}
	
	static public function genSky():Void{
		var _map:Array<Array<Int> > = new Array<Array<Int>>();
		var _rand:FlxRandom = new FlxRandom();
		for (i in 0...15){
			_map[i] = new Array<Int>();
			for (j in 0...20)
				if (_rand.float() < .1) _map[i][j] = 0;
				else _map[i][j] = 1;
		}
		
		var _sky = new FlxTilemap();
		
		_sky.loadMapFrom2DArray(_map, "assets/images/Sky.png", 32, 32, 0, 0);
		_sky.y = (unit * 1) + 4;
		BackgroundObjects.add(_sky);
	}
}