package;

import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var inEditor:Bool = false;
	public var noteType:Int = 0;

	public var psychicAbility:String = '';
	public var psychicVal1:String = '';
	public var psychicVal2:String = '';
	public var vibrantNum:Int = FlxG.random.int(0, 3);

	public var colorSwap:ColorSwap;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var daStage:String = PlayState.curStage;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false, ?noteSkin:String = 'vibrant')
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.inEditor = inEditor;

		x += PlayState.STRUM_X + 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (!inEditor) this.strumTime += ClientPrefs.noteOffset;

		this.noteData = noteData;

		//Bob and Bosip source code saved me here.
		if (!inEditor) {
			frames = Paths.getSparrowAtlas(noteSkin + 'Notes');	
			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');
	
			if (isSustainNote)
			{
				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
	
				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
			}
		} else {
			frames = Paths.getSparrowAtlas('vibrantNotes');	
			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');
	
			if (isSustainNote)
			{
				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
	
				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
			}
		}
		
		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		antialiasing = ClientPrefs.globalAntialiasing;

		if (noteType == 3) {
			loadGraphic(Paths.image('starNote'));
			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = ClientPrefs.globalAntialiasing;
			//x -= 30;
		}

		if (noteData > -1) {
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;
			for (i in 0...3) {
				colorSwap.update(ClientPrefs.arrowHSV[noteData % 4][i], i);
			}

			x += swagWidth * (noteData % 4);
			if (!isSustainNote) {
				var animToPlay:String = '';
				switch (noteData % 4) {
					case 0:
						animToPlay = 'purple';
					case 1:
						animToPlay = 'blue';
					case 2:
						animToPlay = 'green';
					case 3:
						animToPlay = 'red';
				}
				animation.play(animToPlay + 'Scroll');
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			if (ClientPrefs.downScroll) {
				flipY = true;
			}
			
			x += width / 2;

			noteType = prevNote.noteType;
			vibrantNum = prevNote.vibrantNum;

			switch (noteData)
			{
				case 0:
					animation.play('purpleholdend');
				case 1:
					animation.play('blueholdend');
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	var done = false;

	override function update(elapsed:Float)
	{
		if (!done && !inEditor) {
			if (noteType == 3) {
				switch (daStage) {
					case 'school' | 'schoolEvil': {
						loadGraphic(Paths.image('starNote-pixel'));
						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					}
					default: {
						if (PlayState.storyWeek == 1 || PlayState.SONG.song == 'Presto' || PlayState.SONG.song == 'Harmony (Violastro Mix)') {
							loadGraphic(Paths.image('starNote'));
						} else {
							loadGraphic(Paths.image('simulNote'));
						}
						setGraphicSize(Std.int(width * 0.7));
						antialiasing = ClientPrefs.globalAntialiasing;
					}
				}
				updateHitbox();
			}

			if (noteType == 4) {
				frames = Paths.getSparrowAtlas('shieldNote');
				animation.addByPrefix('shield', 'shield', 24, true);
				animation.play('shield');
		//		loadGraphic(Paths.image('greg'));
				setGraphicSize(Std.int(width * 0.7));
				antialiasing = ClientPrefs.globalAntialiasing;
			}
			done = true;
		}

		if (isSustainNote && prevNote.noteType == 3) {
			this.kill();
		}

		if (mustPress)
		{
			if (noteType == 3) {
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.3)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2))
					canBeHit = true;
				else
					canBeHit = false;
			} else {
				// The * 0.5 is so that it's easier to hit them too late, instead of too early
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}

		super.update(elapsed);
	}
}
