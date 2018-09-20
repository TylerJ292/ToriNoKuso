package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;

/**
 * The LevelManager keeps track of obstacles created, and generates new obstacles.
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
	
	public static var Obstacles:List<Obstacle> = new List<Obstacle>();
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
		
		for (o in Obstacles){
			o.update(elapsed);
			if (!o.alive){
				Obstacles.remove(o);
				state.remove(o);
			}
		}
	}
	
	/**
	 * Spawn the next segment of the level
	 * 
	 * 
	 * @param	Timer
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
			state.add(_marker);
			Obstacles.add(_marker);
		}
		
		//generate each column
		for ( i in 0...segmentWidth) {
			
			//floor
			var _floor:Obstacle = new Obstacle(leftX+(i * unit), (segmentHeight-1) * unit, screenSpeed);
			state.add(_floor);
			Obstacles.add(_floor);
			
			if (i == segmentWidth - 1){
				RightmostObject = _floor;
				trace("sdfg");
			}
		}
		
		//people
		var _person:Person = new Person(leftX + (Std.int(_ran.float(2, 10))*unit), (segmentHeight - 3) * unit, screenSpeed);
		state.add(_person);
		Obstacles.add(_person);
	}
}