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
	public static var Obstacles:FlxTypedGroup<Obstacle> = new FlxTypedGroup<Obstacle>(); //all obstacles
	public static var Solids:FlxTypedGroup<LevelObject> = new FlxTypedGroup<LevelObject>(); //for things people collide with
	public static var People:FlxTypedGroup<Person> = new FlxTypedGroup<Person>();
	
	public static var RightmostObject:Obstacle = null;
	
	public static var screenSpeed:Float = -50;
	
	private function new() { }
	
	
	public static function startLevelGen() {
		genSegment();
	}
	
	public static function update(elapsed:Float):Void
	{
		
		if (RightmostObject.getPosition().x < FlxG.width * 2){
			genSegment();
		}
		
		FlxG.collide(People, Solids, Person.onCollision);

		FlxG.overlap(state._player, People, function( _b:Bird, _p:Person){ _p.onDiveAttack(_b);});
		///*testing only:*/ FlxG.overlap(People, People, function( _b:Person, _p:Person){ _p.onDiveAttack(state._player);});
		
		for (obj in LevelObjects){
			obj.update(elapsed);
			if (!obj.alive){
				//LevelObjects.remove(obj);
				//state.remove(obj);
			}
		}
	}
	
	/**
	 * Spawn the next segment of the level
	 */
	public static  function genSegment():Void
	{
		
		var leftX:Float = 0;
		if (RightmostObject != null){
			leftX = RightmostObject.getPosition().x + RightmostObject.getWidth();
		}
		
		var _ran:FlxRandom = new FlxRandom();
		
		//marker
		for (i in 1...3){
			var _marker:Obstacle = new Obstacle(leftX, (segmentHeight-i)*unit, screenSpeed);
			Solids.add(_marker);
		}
		
		//generate each column
		for ( i in 0...segmentWidth) {
			
			//floor
			var _floor:Obstacle = new Obstacle(leftX+(i * unit), (segmentHeight-1) * unit, screenSpeed);
			Solids.add(_floor);
			
			if (i == segmentWidth - 1){
				RightmostObject = _floor;
			}
		}
		
		//people
		for(i in 1..._ran.int(1,3)){
			new Person(leftX + (_ran.int(2*i,4*i)*unit), (segmentHeight - 3) * unit, screenSpeed);
		}
	}
}