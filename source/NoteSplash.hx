package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var curSkin:String = PlayState.boyfriend.noteSkin;
	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		frames = Paths.getSparrowAtlas(curSkin + 'Splashes');
		animation.addByPrefix("note1", "note splash yellow", 24, false);
		animation.addByPrefix("note2", "note splash red", 24, false);
		animation.addByPrefix("note0", "note splash green", 24, false);
		animation.addByPrefix("note3", "note splash blue", 24, false);

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, ?note:Int = 0) {
		setPosition(x, y);
		alpha = 0.6;
		animation.play('note' + note, true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		updateHitbox();
		offset.set(Std.int(0.3 * width), Std.int(0.35 * height));
		if(colorSwap == null) {
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;
		}
		for (i in 0...3) {
			colorSwap.update(ClientPrefs.arrowHSV[note % 4][i], i);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();
		super.update(elapsed);
	}
}