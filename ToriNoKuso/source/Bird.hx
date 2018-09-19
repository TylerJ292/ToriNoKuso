package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bird extends FlxSprite {

  var speed:Float = 200;
  var _up:Bool = false;
  var _down:Bool = false;
  var _left:Bool = false;
  var _right:Bool = false;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);

		loadGraphic("assets/images/squirrels1.png", true, 16, 16);

	}

	public function movement():Void
  {
    _up = FlxG.keys.anyPressed([UP, W]);
    _down = FlxG.keys.anyPressed([DOWN, S]);
    _left = FlxG.keys.anyPressed([LEFT, A]);
    _right = FlxG.keys.anyPressed([RIGHT, D]);

    // cancel out opposing directions
    if (_up && _down){
     _up = _down = false;
    }
    if (_left && _right){
     _left = _right = false;
    }

  }
}
