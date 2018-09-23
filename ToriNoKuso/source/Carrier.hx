package;
import flixel.FlxSprite;

/**
 * Really simple interface for anything that can carry anything (people, bird)
 * 
 * Essentially, just gives local X and Y co-ordinates of the thing to be carried.
 * 
 * @author Jay
 */
interface Carrier
{
	public var x(default, set):Float;
	var y(default, set):Float;
	var alive(default, set):Bool;
	
	public function getCarryX():Float;
	
	public function getCarryY():Float;
}