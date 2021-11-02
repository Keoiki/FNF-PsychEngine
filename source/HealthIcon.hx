package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var sprTrackerBehind:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
			flipX = true;
		}

		if (sprTrackerBehind != null) {
			setPosition(sprTrackerBehind.x - 160, sprTrackerBehind.y - 30);
		}
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public function changeIcon(char:String) {
		if(char != 'bf-pixel' && char != 'bf-old' && char != 'bf-vio' && char != 'pgf-vio' && char != 'duo-viobotgf' && char != 'duo-bfgf') {
			char = (char.split('-')[0]).trim();
		}

		if(this.char != char) {
			var file:String = Paths.image('icons/icon-' + char);
			if(!OpenFlAssets.exists(file)) file = Paths.image('icons/icon-face'); //Prevents crash from missing icon

			loadGraphic(file, true, 150, 150);
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			switch(char) {
				case 'bf-pixel' | 'senpai' | 'spirit':
					antialiasing = false;

				default:
					antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}
}