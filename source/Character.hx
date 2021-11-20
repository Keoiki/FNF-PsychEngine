package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxSort;
import Section.SwagSection;
import openfl.utils.Assets as OpenFlAssets;
import flixel.util.FlxTimer;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = ClientPrefs.globalAntialiasing;

		var library:String = null;
		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/GF_assets');
				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');

			case 'gf-viobot':
				frames = Paths.getSparrowAtlas('characters/GF_assets_VioBot');
				quickAnimAdd('cheer', 'GF Cheer');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');

			case 'gf-viobot-bomb':
				frames = Paths.getSparrowAtlas('characters/GF_assets_VioBot_BOMB');
				quickAnimAdd('danceRight', 'GF VioBot Bomb');
				quickAnimAdd('danceLeft', 'GF VioBot Bomb');

				playAnim('danceRight');

			case 'gf-pillow':
				frames = Paths.getSparrowAtlas('characters/GF_assets_PILLOW');
				quickAnimAdd('cheer', 'GF Cheer');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

			case 'gf-vio-speaker':
				frames = Paths.getSparrowAtlas('characters/GF_assets_Violastro');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

			case 'pgf-vio':
				frames = Paths.getSparrowAtlas('characters/GF-Violastro');
				quickAnimAdd('idle', 'GF Idle');
				animation.addByIndices('idleHair', 'GF Idle', [10, 11, 12, 13], "", 24, true);
				quickAnimAdd('singUP', 'GF Note Up');
				quickAnimAdd('singDOWN', 'GF Note Down');
				quickAnimAdd('singLEFT', 'GF Note Right');
				quickAnimAdd('singRIGHT', 'GF Note Left');

				playAnim('idle');
				flipX = true;

			case 'gf-empty':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/GF_assets');
				quickAnimAdd('cheer', 'GF Cheer');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				visible = false;
				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				quickAnimAdd('idle', 'Dad idle dance');
				quickAnimAdd('singUP', 'Dad Sing Note UP');
				quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
				quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');
				singDuration = 6.1;

				playAnim('idle');

			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'preload');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				quickAnimAdd('firstDeath', "BF dies");
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				quickAnimAdd('deathConfirm', "BF Dead confirm");

				animation.addByPrefix('scared', 'BF idle shaking', 24, true);

				quickAnimAdd('damaged', 'BF hit');

				playAnim('idle');
				library = 'preload';

				flipX = true;

			case 'bf-shades':
				frames = Paths.getSparrowAtlas('characters/bfShades');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');
				quickAnimAdd('damaged', 'BF hit');

				playAnim('idle');
				flipX = true;

			case 'bf-vio':
				frames = Paths.getSparrowAtlas('characters/bfViolastro');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');
				quickAnimAdd('damaged', 'BF hit');
				quickAnimAdd('laughing', 'BF laugh');
				quickAnimAdd('smack', 'BF mic smack');

				playAnim('idle');
				flipX = true;

			case 'violastro':
				frames = Paths.getSparrowAtlas('characters/violastro_assets');
				quickAnimAdd('idle', 'Violastro Idle');
				
				quickAnimAdd('singLEFT', 'Violastro Left Note');
				animation.addByIndices('singLEFT-start', 'Violastro Left Note', [0, 1], "", 24, false);
				animation.addByIndices('singLEFT-loop', 'Violastro Left Note', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singDOWN', 'Violastro Down Note');
				animation.addByIndices('singDOWN-start', 'Violastro Down Note', [0, 1], "", 24, false);
				animation.addByIndices('singDOWN-loop', 'Violastro Down Note', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singUP', 'Violastro Up Note');
				animation.addByIndices('singUP-start', 'Violastro Up Note', [0, 1], "", 24, false);
				animation.addByIndices('singUP-loop', 'Violastro Up Note', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singRIGHT', 'Violastro Right Note');
				animation.addByIndices('singRIGHT-start', 'Violastro Right Note', [0, 1], "", 24, false);
				animation.addByIndices('singRIGHT-loop', 'Violastro Right Note', [2, 3, 4, 5], "", 24, false);

				singDuration = 6.1;

				playAnim('idle');

			case 'violastrobot':
				frames = Paths.getSparrowAtlas('characters/violastrobot');
				quickAnimAdd('idle', 'VioBot Idle');
				animation.addByIndices('idleHair', 'VioBot Idle', [7, 8, 9, 10], "", 24, true);
				
				quickAnimAdd('singLEFT', 'VioBot Note Left');
				animation.addByIndices('singLEFT-start', 'VioBot Note Left', [0, 1], "", 24, false);
				animation.addByIndices('singLEFT-loop', 'VioBot Note Left', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singDOWN', 'VioBot Note Down');
				animation.addByIndices('singDOWN-start', 'VioBot Note Down', [0, 1], "", 24, false);
				animation.addByIndices('singDOWN-loop', 'VioBot Note Down', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singUP', 'VioBot Note Up');
				animation.addByIndices('singUP-start', 'VioBot Note Up', [0, 1], "", 24, false);
				animation.addByIndices('singUP-loop', 'VioBot Note Up', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singRIGHT', 'VioBot Note Right');
				animation.addByIndices('singRIGHT-start', 'VioBot Note Right', [0, 1], "", 24, false);
				animation.addByIndices('singRIGHT-loop', 'VioBot Note Right', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('powerOut', 'VioBot Power Out');
				quickAnimAdd('riseUp', 'VioBot Rise Up');

				playAnim('idle');

			case 'violastrobotPlayer':
				frames = Paths.getSparrowAtlas('characters/violastrobot');
				quickAnimAdd('idle', 'VioBot Idle');
				animation.addByIndices('idleHair', 'VioBot Idle', [7, 8, 9, 10], "", 24, true);
				
				quickAnimAdd('singLEFT', 'VioBot Note Left');
				animation.addByIndices('singLEFT-start', 'VioBot Note Left', [0, 1], "", 24, false);
				animation.addByIndices('singLEFT-loop', 'VioBot Note Left', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singDOWN', 'VioBot Note Down');
				animation.addByIndices('singDOWN-start', 'VioBot Note Down', [0, 1], "", 24, false);
				animation.addByIndices('singDOWN-loop', 'VioBot Note Down', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singUP', 'VioBot Note Up');
				animation.addByIndices('singUP-start', 'VioBot Note Up', [0, 1], "", 24, false);
				animation.addByIndices('singUP-loop', 'VioBot Note Up', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('singRIGHT', 'VioBot Note Right');
				animation.addByIndices('singRIGHT-start', 'VioBot Note Right', [0, 1], "", 24, false);
				animation.addByIndices('singRIGHT-loop', 'VioBot Note Right', [2, 3, 4, 5], "", 24, false);

				quickAnimAdd('powerOut', 'VioBot Power Out');
				quickAnimAdd('riseUp', 'VioBot Rise Up');

				playAnim('idle');
//				flipX = true;

			case 'viobot-dancin':
				frames = Paths.getSparrowAtlas('characters/violastrobot_dancin');
				//animation.addByPrefix('idle', 'ViolastroBot Dance', 24, true);
				animation.addByIndices('danceLeft', 'ViolastroBot Dance', [14, 15, 16, 17, 18, 19, 20, 21], "", 24, false);
				animation.addByIndices('danceRight', 'ViolastroBot Dance', [22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

			case 'venturers':
				frames = Paths.getSparrowAtlas('characters/violastro_assets');
				quickAnimAdd('idle', 'Violastro Idle');

				visible = false;

				playAnim('idle');

			case 'pistachio':
				frames = Paths.getSparrowAtlas('characters/pistachio_assets');
				quickAnimAdd('idle', 'Pistachio Idle');
				quickAnimAdd('singLeaf0', 'Pistachio Sing Left');
				quickAnimAdd('singLeaf1', 'Pistachio Sing Down');
				quickAnimAdd('singLeaf2', 'Pistachio Sing Up');
				quickAnimAdd('singLeaf3', 'Pistachio Sing Right');
				quickAnimAdd('singLEFT', 'Pistachio Sing Left');
				quickAnimAdd('singDOWN', 'Pistachio Sing Down');
				quickAnimAdd('singUP', 'Pistachio Sing Up');
				quickAnimAdd('singRIGHT', 'Pistachio Sing Right');
				//	quickAnimAdd('glance', 'Pistachio Look Up');

				playAnim('idle');
				singDuration = 5;

			case 'banana':
				frames = Paths.getSparrowAtlas('characters/banana_assets');
				quickAnimAdd('idle', 'Banana Idle');
				quickAnimAdd('singEarth0', 'Banana Sing Left');
				quickAnimAdd('singEarth1', 'Banana Sing Down');
				quickAnimAdd('singEarth2', 'Banana Sing Up');
				quickAnimAdd('singEarth3', 'Banana Sing Right');
				quickAnimAdd('singLEFT', 'Banana Sing Left');
				quickAnimAdd('singDOWN', 'Banana Sing Down');
				quickAnimAdd('singUP', 'Banana Sing Up');
				quickAnimAdd('singRIGHT', 'Banana Sing Right');
				//	quickAnimAdd('glance', 'Banana Look Up');

				playAnim('idle');
				singDuration = 5;

			case 'cardinal':
				frames = Paths.getSparrowAtlas('characters/cardinal_assets');
				quickAnimAdd('idle', 'Cardinal Idle');
				quickAnimAdd('singFire0', 'Cardinal Sing Left');
				quickAnimAdd('singFire1', 'Cardinal Sing Down');
				quickAnimAdd('singFire2', 'Cardinal Sing Up');
				quickAnimAdd('singFire3', 'Cardinal Sing Right');
				quickAnimAdd('singLEFT', 'Cardinal Sing Left');
				quickAnimAdd('singDOWN', 'Cardinal Sing Down');
				quickAnimAdd('singUP', 'Cardinal Sing Up');
				quickAnimAdd('singRIGHT', 'Cardinal Sing Right');
				//	quickAnimAdd('glance', 'Cardinal Look Up');

				playAnim('idle');
				singDuration = 5;

			case 'azura':
				frames = Paths.getSparrowAtlas('characters/azura_assets');
				quickAnimAdd('idle', 'Azura Idle');
				quickAnimAdd('singWater0', 'Azura Sing Left');
				quickAnimAdd('singWater1', 'Azura Sing Down');
				quickAnimAdd('singWater2', 'Azura Sing Up');
				quickAnimAdd('singWater3', 'Azura Sing Right');
				quickAnimAdd('singLEFT', 'Azura Sing Left');
				quickAnimAdd('singDOWN', 'Azura Sing Down');
				quickAnimAdd('singUP', 'Azura Sing Up');
				quickAnimAdd('singRIGHT', 'Azura Sing Right');
				//	quickAnimAdd('glance', 'Azura Look Up');

				playAnim('idle');
				singDuration = 5;

			case 'psychic':
				frames = Paths.getSparrowAtlas('characters/Psychic');
				quickAnimAdd('idle', 'PSYCHIC IDLE');
				animation.addByIndices('idleHair', 'PSYCHIC IDLE', [6, 7, 8, 9, 10, 11, 12, 13], "", 24, true);
				quickAnimAdd('singLEFT', 'PSYCHIC LEFT');
				quickAnimAdd('singLEFT-alt', 'PSYCHIC left ALT');
				quickAnimAdd('singDOWN', 'PSYCHIC DOWN');
				quickAnimAdd('singDOWN-alt', 'PSYCHIC down ALT');
				quickAnimAdd('singUP', 'PSYCHIC UP');
				quickAnimAdd('singUP-alt', 'PSYCHIC up ALT');
				quickAnimAdd('singRIGHT', 'PSYCHIC RIGHT');
				quickAnimAdd('singRIGHT-alt', 'PSYCHIC right ALT');
				quickAnimAdd('ability', 'PSYCHIC POWERS');
				singDuration = 4.4;

/*
			case 'duo-bfgf':
				frames = Paths.getSparrowAtlas('characters/violastro_assets');
				quickAnimAdd('idle', 'Violastro Idle');

				visible = false;

				playAnim('idle');
*/
		}

		loadOffsetFile(curCharacter, library);

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!debugMode && animation.curAnim != null) {
			if (heyTimer > 0) {
				heyTimer -= elapsed;
				if (heyTimer <= 0) {
					if(specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer') {
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if (specialAnim && animation.curAnim.finished) {
				specialAnim = false;
				dance();
			}
		}

		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			if (holdTimer >= Conductor.stepCrochet * 0.001 * singDuration)
			{
				dance();
				holdTimer = 0;
			}
		}

		if (!debugMode) {
			switch (curCharacter)
			{
				case 'gf':
					if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
						playAnim('danceRight');
				case 'bf-car' | 'mom-car' | 'violastrobot' | 'psychic' | 'pgf-vio':
					if(animation.curAnim.finished) {
						if(animation.curAnim.name == 'idle')
							playAnim('idleHair');
						else if(animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.startsWith('miss')) {
							var framesToGoBack:Int = 4;
							playAnim(animation.curAnim.name, false, false, animation.curAnim.frames.length - framesToGoBack);
						}
					}
			}
			switch (curCharacter) {
				case 'violastro' | 'violastrobot': {
					if (animation.curAnim.finished) {
						switch (animation.curAnim.name) {
							case 'singLEFT':
								playAnim('singLEFT-loop');
							case 'singRIGHT':
								playAnim('singRIGHT-loop');
							case 'singUP':
								playAnim('singUP-loop');
							case 'singDOWN':
								playAnim('singDOWN-loop');
							default:

						}
					}
					switch (animation.curAnim.name) {
						case 'singLEFT-start':
							new FlxTimer().start(0.05, function(tmr:FlxTimer) {
								playAnim('singLEFT-loop');
							});

						case 'singRIGHT-start':
							new FlxTimer().start(0.05, function(tmr:FlxTimer) {
								playAnim('singRIGHT-loop');
							});

						case 'singUP-start':
							new FlxTimer().start(0.05, function(tmr:FlxTimer) {
								playAnim('singUP-loop');
							});

						case 'singDOWN-start':
							new FlxTimer().start(0.05, function(tmr:FlxTimer) {
								playAnim('singDOWN-loop');
							});
					}
				}
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && !specialAnim)
		{
			if (curCharacter.startsWith('gf')) {
				if (!animation.curAnim.name.startsWith('hair'))
				{
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				}
			} else {
				switch (curCharacter)
				{
					case 'viobot-dancin':
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');

					default:
						playAnim('idle');
				}
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		specialAnim = false;
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}

	function loadOffsetFile(fileName:String, library:String = null)
	{
		var path:String = Paths.getPath('images/characters/' + fileName + 'Offsets.txt', TEXT, library);
		if (!OpenFlAssets.exists(path)) {
			return;
		}

		var file:Array<String> = CoolUtil.coolTextFile(path);
		for (i in 0...file.length) {
			var offset:Array<String> = file[i].split(' ');
			addOffset(offset[0], Std.parseInt(offset[1]), Std.parseInt(offset[2]));
		}
	}
}
