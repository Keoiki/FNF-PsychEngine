package;

import flixel.addons.ui.FlxUIMouse;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.mouse.FlxMouse;
import flixel.FlxObject;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.FlxCamera;

using StringTools;

class StoryBookState extends MusicBeatState
{
	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;
	var camFollow:FlxObject;
    var curPage:Int = 0; //0 = Tutorial, 1 = Violastro, 2 = Vibrants
    var pageTxt:FlxText;
    var pageCheck:Bool = false;

    var easy:FlxSprite;
    var normal:FlxSprite;
    var hard:FlxSprite;
    var vibrant:FlxSprite;
    var weekPlay:FlxSprite;
    var diffCheck:FlxSprite;
    var weekTitle:FlxSprite;

    private var leftCheck:FlxSprite;
    private var rightCheck:FlxSprite;

	var camFollowPos:FlxObject;

    var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bwehehe', 'Stupefy', 'Supernova'],
		['Harmony', 'Corruption', 'Eclipse']
	];
    var curDifficulty:Int = 1;

    override function create() {
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];

        FlxG.mouse.visible = true;

		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);

        leftCheck = new FlxSprite(0, 0).makeGraphic(100, FlxG.height, FlxColor.ORANGE);
        leftCheck.alpha = 0.25;
        leftCheck.scrollFactor.set(0, 0);
        add(leftCheck);
        rightCheck = new FlxSprite(FlxG.width - 100, 0).makeGraphic(100, FlxG.height, FlxColor.YELLOW);
        rightCheck.alpha = 0.25;
        rightCheck.scrollFactor.set(0, 0);
        add(rightCheck);

        pageTxt = new FlxText(15, FlxG.height / 2, 32, "FUCK", 32);
        pageTxt.scrollFactor.set(0, 0);
        add(pageTxt);

        var book:FlxSprite = new FlxSprite(154, 16).loadGraphic(Paths.image("storybook/StoryBook"));
        book.antialiasing = ClientPrefs.globalAntialiasing;
        book.scrollFactor.set(0.2, 0.4);
		book.screenCenter();
        add(book);

        var book:FlxSprite = new FlxSprite(154, 16).loadGraphic(Paths.image("storybook/StoryBook"));
        book.antialiasing = ClientPrefs.globalAntialiasing;
        book.scrollFactor.set(0.2, 0.4);
		book.screenCenter();
        add(book);
    
        easy = new FlxSprite(253, 415).loadGraphic(Paths.image("storybook/diff0"));
        easy.antialiasing = ClientPrefs.globalAntialiasing;
        easy.scrollFactor.set(0.2, 0.4);
        add(easy);
    
        normal = new FlxSprite(427, 414).loadGraphic(Paths.image("storybook/diff1"));
        normal.antialiasing = ClientPrefs.globalAntialiasing;
        normal.scrollFactor.set(0.2, 0.4);
        add(normal);
    
        hard = new FlxSprite(272, 515).loadGraphic(Paths.image("storybook/diff2"));
        hard.antialiasing = ClientPrefs.globalAntialiasing;
        hard.scrollFactor.set(0.2, 0.4);
        add(hard);
    
        vibrant = new FlxSprite(433, 508).loadGraphic(Paths.image("storybook/diff3"));
        vibrant.antialiasing = ClientPrefs.globalAntialiasing;
        vibrant.scrollFactor.set(0.2, 0.4);
        add(vibrant);
    
        diffCheck = new FlxSprite(normal.x + 120, normal.y + 50).loadGraphic(Paths.image("storybook/selDiff"));
        diffCheck.antialiasing = ClientPrefs.globalAntialiasing;
        diffCheck.scrollFactor.set(0.2, 0.4);
        add(diffCheck);
    
        weekPlay = new FlxSprite(712, 496).loadGraphic(Paths.image("storybook/playWeek"));
        weekPlay.antialiasing = ClientPrefs.globalAntialiasing;
        weekPlay.scrollFactor.set(0.2, 0.4);
        add(weekPlay);

        var ui_tex = Paths.getSparrowAtlas('storybook/weekNames');
        weekTitle = new FlxSprite(302, 107);
        weekTitle.frames = ui_tex;
		weekTitle.animation.addByPrefix('bruh', 'weekTitles', 0);
        weekTitle.animation.play('bruh');
        weekTitle.antialiasing = ClientPrefs.globalAntialiasing;
        weekTitle.scrollFactor.set(0.2, 0.4);
		weekTitle.animation.curAnim.curFrame = 0;
        add(weekTitle);

        leftCheck.cameras = [camHUD];
        rightCheck.cameras = [camHUD];
        
        FlxG.sound.music.fadeOut(1.5, 0, function(bruh) {
            FlxG.sound.music.stop();
        });

        // god fucking hell
		CoolUtil.precacheSound('pageFlip0');
		CoolUtil.precacheSound('pageFlip1');
		CoolUtil.precacheSound('pageFlip2');
		CoolUtil.precacheSound('pageFlip3');
		CoolUtil.precacheSound('pageFlip4');
    }

    override function update(elapsed) {
        pageTxt.text = "" + curPage;
        camFollowPos.x = FlxG.mouse.screenX;
        camFollowPos.y = FlxG.mouse.screenY;

        if (FlxG.mouse.overlaps(leftCheck) && !pageCheck && (curPage != 0)) {
            curPage -= 1;
            pageCheck = true;
            FlxG.sound.play(Paths.soundRandom('pageFlip', 0, 4), FlxG.random.float(0.9, 1));
            new FlxTimer().start(0.7, function(tmr:FlxTimer) {
                pageCheck = false;
            });
        } else if (FlxG.mouse.overlaps(rightCheck) && !pageCheck && (curPage != 2)) {
            curPage += 1;
            pageCheck = true;
            FlxG.sound.play(Paths.soundRandom('pageFlip', 0, 4), FlxG.random.float(0.9, 1));
            new FlxTimer().start(0.7, function(tmr:FlxTimer) {
                pageCheck = false;
            });
        }

        if (curPage >= 3) {
            weekTitle.animation.curAnim.curFrame = 2;
        } else {
            weekTitle.animation.curAnim.curFrame = curPage;
        }

        if (FlxG.mouse.overlaps(weekPlay) && FlxG.mouse.justPressed) {
            playWeek();
        }

        if (!pageCheck) {
            if (FlxG.mouse.overlaps(easy) && FlxG.mouse.justPressed) {
                curDifficulty = 0;
                diffCheck.setPosition(easy.x + 140, easy.y + 50);
            } else if (FlxG.mouse.overlaps(normal) && FlxG.mouse.justPressed) {
                curDifficulty = 1;
                diffCheck.setPosition(normal.x + 120, normal.y + 50);
            } else if (FlxG.mouse.overlaps(hard) && FlxG.mouse.justPressed) {
                curDifficulty = 2;
                diffCheck.setPosition(hard.x + 120, hard.y + 50);
            } else if (FlxG.mouse.overlaps(vibrant) && FlxG.mouse.justPressed) {
                curDifficulty = 3;
                diffCheck.setPosition(vibrant.x + 120, vibrant.y + 50);
            }
        }
    }

    function playWeek() {
        pageCheck = true;

        FlxG.sound.play(Paths.sound('confirmMenu'));

        PlayState.storyPlaylist = weekData[curPage];
		PlayState.isStoryMode = true;
        var diffic = "";
        switch (curDifficulty)
        {
            case 0:
                diffic = '-easy';
            case 2:
                diffic = '-hard';
            case 3:
                diffic = '-vibrant';
        }

        PlayState.storyDifficulty = curDifficulty;
        PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
        PlayState.storyWeek = curPage;
        PlayState.campaignScore = 0;
        PlayState.campaignMisses = 0;
        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            LoadingState.loadAndSwitchState(new PlayState(), true);
            FreeplayState.destroyFreeplayVocals();
        });
    }
}