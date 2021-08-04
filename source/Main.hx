package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1280, 720, PlayState, 1, 240, 240, true));

		FlxG.autoPause = false;
	}
}
