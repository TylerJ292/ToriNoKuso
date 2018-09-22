package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bird extends FlxSprite {

  //public var x:Int;
  //public var y:Int;

  public var speed:Float = 200;
  //public var _up:Bool = false;
  //public var _down:Bool = false;
  //public var _left:Bool = false;
  //public var _right:Bool = false;


  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);


		loadGraphic("assets/images/squirrels1.png", true, 16, 16);

	}

	public function movement():Void
  {
	  /*
    _up = FlxG.keys.anyPressed([UP, W]);
    _down = FlxG.keys.anyPressed([DOWN, S]);
    _left = FlxG.keys.anyPressed([LEFT, A]);
    _right = FlxG.keys.anyPressed([RIGHT, D]);
*/
	/*
    // cancel out opposing directions
    if (_up && _down){
     _up = _down = false;
    }
    if (_left && _right){
     _left = _right = false;
    }
*/
  }
}
