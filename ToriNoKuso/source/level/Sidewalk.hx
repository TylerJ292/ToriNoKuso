package level;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Sidewalk. To be overlayed over grass, hopefully
 * 
 * @author Jay
 */
class Sidewalk extends LevelObject 
{
	public static inline var SIDEWALK = 0;
	public static inline var ROAD     = 1;
	
	public var anim:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float, ?_anim=SIDEWALK) 
	{
		super(X, Y, SimpleGraphic, initSpeed);
		
		anim = _anim;
		
		animation.add(Std.string(SIDEWALK), [SIDEWALK], 0);
		animation.add(Std.string(ROAD), [ROAD], 0);
		
		animation.play(Std.string(anim));
		
		set_immovable(true);
		
	}
	
	override public function graphicFilename():String{
		return "assets/images/Sidewalk.png";
	}
}