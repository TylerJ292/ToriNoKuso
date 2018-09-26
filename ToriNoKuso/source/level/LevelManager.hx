package level;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;

/**
 * The LevelManager keeps track of backgrounds, people, abd obstacles created, and generates new obstacles.
 * 
 * @author Jay
 */
class LevelManager
{
  // read-only property
    public static var instance(default, null):LevelManager = new LevelManager();
	public static var state:PlayState = null;
	
	//width and height in tile units
	public static var segmentWidth = 15;
	public static var segmentHeight = 15;
	public static var unit = 32;
	
	//containers
	public static var LevelObjects:FlxTypedGroup<LevelObject> = new FlxTypedGroup<LevelObject>(); //all obstacles
	public static var BackgroundObjects:FlxGroup = new FlxGroup();	//default ordering is to place all level objects in background objects
	public static var Obstacles:FlxTypedGroup<Obstacle> = new FlxTypedGroup<Obstacle>(); //all obstacles
	public static var Solids:FlxTypedGroup<LevelObject> = new FlxTypedGroup<LevelObject>(); //for things people collide with
	public static var People:FlxTypedGroup<Person> = new FlxTypedGroup<Person>();
	public static var FoodObjects:FlxTypedGroup<Food> = new FlxTypedGroup<Food>();
	public static var BuildingTiles:FlxTypedGroup<BuildingTile> = new FlxTypedGroup<BuildingTile>();
	
	//level gen
	public static var RightmostObject:LevelObject = null;
	
	public static var BuildingHeight:Int;
	public static var BuildingHeightMax:Int = 10;
	public static var BuildingHeightMin:Int = 0;
	
	public static var screenSpeed:Float = -50;
	
	private function new() { }
	
	public static function startLevelGen() {
		FlxG.worldBounds.set( -0.5 * FlxG.width, 0, FlxG.width * 1.55, FlxG.height);
		
		state.add(BackgroundObjects);
		state.add(People);
		state.add(FoodObjects);
		
		BuildingHeight = new FlxRandom().int(BuildingHeightMin, BuildingHeightMax);
		
		genSegment();
	}
	
	public static function update(elapsed:Float):Void
	{
		
		if (RightmostObject.getPosition().x < FlxG.width * 2){
			genSegment();
		}
		
		/**		COLLISION DETECTION WITH LEVEL OBJECTS GOES HERE	**/
		
		//bird vs. obstacle
		if (FlxG.overlap(state._player, Obstacles)) state._player.healthTracker();
		
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
		
		if(false){
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
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.RIGHT_TOP);
						}
						else if (i == _heightChange){
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.LEFT_TOP);
						}
						else{
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.CENTER_TOP);
						}
					}
					else if (j < BuildingHeight){
						if (i == _heightChange-1){
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.RIGHT_WINDOW);
						}
						else if (i == _heightChange){
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.LEFT_WINDOW);
						}
						else{
							new BuildingTile(leftX + (i * unit), (segmentHeight - j) * unit, screenSpeed, BuildingTile.CENTER_WINDOW);
						}
					}
				}
			}
		}
		
		//generate sidewalk
		for ( i in 0...segmentWidth) {
			
			//floor
			var _floor = new Sidewalk(leftX + (i * unit), (segmentHeight - 1.5) * unit, screenSpeed);
			//Solids.add(_floor);
			
			if (i == segmentWidth - 1){
				RightmostObject = _floor;
			}
		}
		
		//stop sign
		if (_ran.int(0, 5) >= 4)
		{
			var stopHeight:Int = _ran.int(4, 5);
			for (i in 2...stopHeight)
				Solids.add(new Pole(leftX, (segmentHeight - i) * unit, screenSpeed));
			new StopSign(leftX, (segmentHeight - stopHeight) * unit, screenSpeed);
		}	
		
		//table
		if (_ran.float() <= 0.3)
		{
			new PicnicTable(leftX+unit*4, (segmentHeight-2) * unit, screenSpeed);
			new Food(leftX + unit*5, (segmentHeight - 3) * unit, screenSpeed, true);
		}	
		
		//people
		for(i in 1..._ran.int(1,3)){
			new Person(leftX + (_ran.int(2*i,4*i)*unit), (segmentHeight - 3) * unit, screenSpeed);
		}
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
	 Obstacles = new FlxTypedGroup<Obstacle>(); //all obstacles
	 Solids= new FlxTypedGroup<LevelObject>(); //for things people collide with
	People = new FlxTypedGroup<Person>();
	 FoodObjects = new FlxTypedGroup<Food>();
	 BuildingTiles= new FlxTypedGroup<BuildingTile>();
	
	//level gen
	 RightmostObject = null;
	
	BuildingHeight;
	 BuildingHeightMax = 10;
	 BuildingHeightMin = 0;
	
	 screenSpeed = -50;
	
	}
}