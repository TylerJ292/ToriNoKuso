package level;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;

/**
 * Building tile
 * 
 * @author Jay
 */
class BuildingTile extends LevelObject 
{

	//if adding a new tile be SURE to add to TILES array
	public static inline var LEFT_WINDOW = 0;
	public static inline var CENTER_WINDOW = 1;
	public static inline var RIGHT_WINDOW = 2;
	public static inline var LEFT_TOP = 4;
	public static inline var CENTER_TOP = 3;
	public static inline var RIGHT_TOP = 5;
	
	public static var TILES:Array<Int> = [LEFT_WINDOW, CENTER_WINDOW, RIGHT_WINDOW, LEFT_TOP, CENTER_TOP, RIGHT_TOP];
	
	public var colorPallete:Int = 0;
	public static inline var BLUE = 0;
	public static inline var GREEN = 1;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float, Tile:Int, ?_color:Int = BLUE ) 
	{
		colorPallete = _color;
		initSpeed+= _color * 20;
		super(X, Y, SimpleGraphic, initSpeed);
		
		for(i in TILES){
			animation.add(Std.string(TILES[i]), [TILES[i]], 0, false);
		}
		animation.play(Std.string(Tile));
		
		LevelManager.LevelObjects.remove(this);
		
		new FlxTimer().start(5 + new FlxRandom().float(0,5), function(_t:FlxTimer) {
			if (this.destroyIfOutOfBounds()){
				this.kill();
				LevelManager.state.remove(this);
				this.destroy();
			}
		}, 0);
	}
	
	override public function graphicFilename():String{
		if (colorPallete == BLUE) return "assets/images/Building.png";
		else return "assets/images/Building 2.png";
	}
	
	public function play(Tile:Int){
				for(i in TILES){
			animation.add(Std.string(TILES[i]), [TILES[i]], 0, false);
		}
		animation.play(Std.string(Tile));
		
		return this;
	}
	
	static public function getNew(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, initSpeed:Float, Tile:Int):BuildingTile {
		var _t = LevelManager.BuildingTiles.recycle(function(){return new BuildingTile(X, Y, SimpleGraphic, initSpeed, Tile); });
		
		
		_t.loadGraphic(_t.graphicFilename(), true, _t.getWidth(), _t.getHeight());
		
		_t.play(Tile);
		
		_t.getOrderingGroup().add(_t);
		LevelManager.LevelObjects.add(_t);
		
		_t.velocity.x = initSpeed;
		_t.velocity.x = initSpeed;
		
		return _t;
	}
}