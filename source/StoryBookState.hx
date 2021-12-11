package;

import flixel.addons.ui.FlxInputText;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import Discord.DiscordClient;
import flixel.group.FlxSpriteGroup;
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
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class StoryBookState extends MusicBeatState
{
    /*

    Pages:
    0 - Main Menu, QUICK ACCESS TO: Story Mode (Page 1), Freeplay (Page 3), Awards (Page 5), Credits (Page 6), Donate and Options
    1 - Story Mode: Violastro's Week
    2 - Story Mode: Vibrants' Week
    3 - Freeplay
    4 - Awards
    5 - Credits

    */
	private var achievementIndex:Array<Int> = [];

    var yourWord:String = "";
    var typingShit:FlxInputText;

    var ass:FlxSprite;

	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;
	var camFollow:FlxObject;
    var curPage:Int = 0;
    var pageTxt:FlxText;
    var pageName:FlxText;
    var pageCheck:Bool = false;
    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;

    var mainMenu:FlxSpriteGroup;
    var storyMode:FlxSpriteGroup;
    var freePlay:FlxSpriteGroup;
    var awards:FlxSpriteGroup;
    var credits:FlxSprite;

	var storyScoreText:FlxText;
//  var sdifficultyIndicator:FlxSprite;
    var sEasy:FlxSprite;
    var sNormal:FlxSprite;
    var sHard:FlxSprite;
    var sVibrant:FlxSprite;
    var weekPlay:FlxSprite;
    var weekTitle:FlxSprite;
    var playerDrawing:FlxSprite;
    var opponentDrawing:FlxSprite;
    var stickyNote:FlxSprite;
    var weekTracks:FlxSprite;
    var storyScore:Int = 0;

	var freeplayScoreText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
    var songIndicator:FlxSprite;
    var fdifficultyIndicator:FlxSprite;
    var easy:FlxSprite;
    var normal:FlxSprite;
    var hard:FlxSprite;
    var vibrant:FlxSprite;
    var songPlay:FlxSprite;

//////////////////////////////////////////

    var diffCheck:FlxSprite;

    var bwehehe:FlxSprite;

    private var leftCheck:FlxSprite;
    private var rightCheck:FlxSprite;

	var camFollowPos:FlxObject;

    var weekData:Array<Dynamic> = [
		['Tutorial'], // RIP
		['Bwehehe', 'Stupefy', 'Supernova'],
		['Harmony', 'Corruption', 'Eclipse']
	];
    var curDifficulty:Int = 1;
    var curStoryDiff:Int = 1;

    var curPageName:Array<String> = ["Main", "Violastro", "Vibrants", "Freeplay", "Awards", "Credits 1", "Credits 2"];

	var freeplaySongThings:FlxSpriteGroup;

    var freeplaySongs:Array<Dynamic> = [ // [Song, Week]
        ["Bwehehe", 1],
        ["Stupefy", 1],
        ["Supernova", 1],
        ["Harmony", 2],
        ["Corruption", 2],
        ["Eclipse", 2],
        ["The-Ups-and-Downs", 1],
        ["Presto", 2],
        ["Harmony (Violastro Mix)", 2],
        ["Psychic", 1]
    ];

    var selectedFreeplaySong:Array<Dynamic> = [];

    public function new(page:Int) {
        curPage = page;
        super();
    }

    override function create() {
        Achievements.loadAchievements();

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];

        selectedFreeplaySong = freeplaySongs[0];

        FlxG.mouse.visible = true;

		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);

        leftCheck = new FlxSprite(0, 0).makeGraphic(175, FlxG.height, FlxColor.ORANGE);
        leftCheck.alpha = 0.25;
        leftCheck.scrollFactor.set(0, 0);
        add(leftCheck);

        rightCheck = new FlxSprite(FlxG.width - 175, 0).makeGraphic(175, FlxG.height, FlxColor.YELLOW);
        rightCheck.alpha = 0.25;
        rightCheck.scrollFactor.set(0, 0);
        add(rightCheck);

        leftArrow = new FlxSprite(15, 0).loadGraphic(Paths.image("storybook/sideArrow"));
        leftArrow.screenCenter(Y);
        leftArrow.scrollFactor.set(0, 0);
        add(leftArrow);

        rightArrow = new FlxSprite(0, 0).loadGraphic(Paths.image("storybook/sideArrow"));
        rightArrow.x = FlxG.width - rightArrow.width - 15;
        rightArrow.screenCenter(Y);
        rightArrow.scrollFactor.set(0, 0);
        rightArrow.flipX = true;
        add(rightArrow);

        pageTxt = new FlxText(15, FlxG.height / 2, 32, "FUCK", 32);
        pageTxt.scrollFactor.set(0, 0);
        add(pageTxt);

        pageName = new FlxText(15, FlxG.height / 2 + 48, 1280, "FUCK", 32);
        pageName.scrollFactor.set(0, 0);
        add(pageName);

        var ground:FlxSprite = new FlxSprite(-393, -284).loadGraphic(Paths.image("storybook/Ground"));
        ground.antialiasing = ClientPrefs.globalAntialiasing;
        ground.scrollFactor.set(0.05, 0.1);
		ground.screenCenter();
        add(ground);

        var people:FlxSprite = new FlxSprite(-413, -444).loadGraphic(Paths.image("storybook/Background People"));
        people.antialiasing = ClientPrefs.globalAntialiasing;
        people.scrollFactor.set(0.1, 0.2);
		people.screenCenter();
        people.y -= 100;
        add(people);

        var book:FlxSprite = new FlxSprite(154, 16).loadGraphic(Paths.image("storybook/StoryBook"));
        book.antialiasing = ClientPrefs.globalAntialiasing;
        book.scrollFactor.set(0.2, 0.4);
		book.screenCenter();
        add(book);

//        var book:FlxSprite = new FlxSprite(154, 16).loadGraphic(Paths.image("storybook/StoryBook"));
//        book.antialiasing = ClientPrefs.globalAntialiasing;
//        book.scrollFactor.set(0.2, 0.4);
//	      book.screenCenter();
//        add(book);

        // MAIN

        addMain();

        // STORY MODE
    
        addStory();

        // FREEPLAY

        addFreeplay();

        // AWARDS

        addAwards();

        // CREDITS

        addCredits();

        leftCheck.cameras = [camHUD];
        rightCheck.cameras = [camHUD];
        pageTxt.cameras = [camHUD];
        pageName.cameras = [camHUD];
        leftArrow.cameras = [camHUD];
        rightArrow.cameras = [camHUD];
        
        FlxG.sound.music.fadeOut(1.5, 0.5);

        // god fucking hell
		CoolUtil.precacheSound('pageFlip0');
		CoolUtil.precacheSound('pageFlip1');
		CoolUtil.precacheSound('pageFlip2');
		CoolUtil.precacheSound('pageFlip3');
		CoolUtil.precacheSound('pageFlip4');

        freeplayScoreText.alpha = 0;
        storyScoreText.alpha = 0;

        mainMenu.kill();
        storyMode.kill();
        freePlay.kill();
        freeplaySongThings.kill();
        awards.kill();
        credits.alpha = 0;
        typingShit.alpha = 0;

        pageFlip(0);
        getFreeplayScore();

        FlxTween.tween(leftArrow, { alpha: 0.15 }, 5);
        FlxTween.tween(rightArrow, { alpha: 0.15 }, 5);

        super.create();
    }

    var curSongID:Dynamic = 0;
    var overlapping:Bool = false;

    var letter:String;

    override function update(elapsed:Float) {
        #if debug
        pageTxt.text = "" + curPage;
        pageName.text = "" + curPageName[curPage];
        leftCheck.alpha = 0.25;
        rightCheck.alpha = 0.25;
        #else
        leftCheck.alpha = 0;
        rightCheck.alpha = 0;
        pageTxt.visible = false;
        pageName.visible = false;
        #end

        camFollowPos.x = FlxG.mouse.screenX;
        camFollowPos.y = FlxG.mouse.screenY;

        if (FlxG.mouse.overlaps(leftCheck) && !pageCheck) {
            pageFlip(-1);
        } else if (FlxG.mouse.overlaps(rightCheck) && !pageCheck) {
            pageFlip(1);
        }

        if (curPage == 0) {
            if (FlxG.mouse.justPressed ) {
                for (i in 0...6) {
                    if (FlxG.mouse.overlaps(mainMenu.members[i])) {
                        switch (i) {
                            case 0: pageFlip(1);
                            case 1: pageFlip(3);
                            case 2: pageFlip(4);
                            case 3: pageFlip(5);
                            case 4: CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
                            case 5: FlxG.switchState(new OptionsState());
                        }
                    }
                }
            }
        }

        if (curPage == 1 || curPage == 2) {
            weekTitle.animation.curAnim.curFrame = curPage - 1;
            opponentDrawing.animation.curAnim.curFrame = curPage - 1;
            playerDrawing.animation.curAnim.curFrame = curPage - 1;
            stickyNote.animation.curAnim.curFrame = curPage - 1;
            weekTracks.animation.curAnim.curFrame = curPage - 1;

            if (FlxG.mouse.justPressed && !pageCheck) {
                if (FlxG.mouse.overlaps(sEasy) && curPage == 1) {
                    curStoryDiff = 0;
                    diffCheck.setPosition(sEasy.x + 70, sEasy.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } else if (FlxG.mouse.overlaps(sNormal) && curPage == 1) {
                    curStoryDiff = 1;
                    diffCheck.setPosition(sNormal.x + 70, sNormal.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } else if (FlxG.mouse.overlaps(sHard) && curPage == 1) {
                    curStoryDiff = 2;
                    diffCheck.setPosition(sHard.x + 70, sHard.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } /* else if (FlxG.mouse.overlaps(vibrant) && FlxG.mouse.justPressed) {
                    curStoryDiff = 3;
                    diffCheck.setPosition(vibrant.x + 120, vibrant.y + 50);
                }*/

                if (FlxG.mouse.overlaps(weekPlay)) {
                    playWeek();
                }

                getStoryScore();
            }
            
            if (curPage == 2) {
                sEasy.alpha = 0.35;
                sNormal.alpha = 0.35;
                sHard.alpha = 0.35;
                sVibrant.alpha = 1;
            } else {
                sEasy.alpha = 1;
                sNormal.alpha = 1;
                sHard.alpha = 1;
                sVibrant.alpha = 0.35;
            }
        }

        if (curPage == 3 && !pageCheck) {
            if (FlxG.mouse.justPressed) {
                for (i in 0...8) {
                    if (FlxG.mouse.overlaps(freeplaySongThings.members[i])) {
                        selectedFreeplaySong = freeplaySongs[i];
                        songIndicator.setPosition(freeplaySongThings.members[i].x + 290, freeplaySongThings.members[i].y + 20);
                        if (selectedFreeplaySong[1] == 1 && curDifficulty == 3) {
                            curDifficulty = 2;
                            fdifficultyIndicator.setPosition(hard.x + 70, hard.y + 20);
                        }
                        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                    }
                }

                if (FlxG.mouse.overlaps(easy) && selectedFreeplaySong[1] == 1) {
                    curDifficulty = 0;
                    fdifficultyIndicator.setPosition(easy.x + 70, easy.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } else if (FlxG.mouse.overlaps(normal) && selectedFreeplaySong[1] == 1) {
                    curDifficulty = 1;
                    fdifficultyIndicator.setPosition(normal.x + 70, normal.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } else if (FlxG.mouse.overlaps(hard) && selectedFreeplaySong[1] == 1) {
                    curDifficulty = 2;
                    fdifficultyIndicator.setPosition(hard.x + 70, hard.y + 20);
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                } /* else if (FlxG.mouse.overlaps(vibrant) && selectedFreeplaySong[1] == 2) {
                    curDifficulty = 3;
                } */

                if (FlxG.mouse.overlaps(songPlay)) {
                    playSong();
                }

                if (selectedFreeplaySong[1] == 2) {
                    curDifficulty = 3;
                    fdifficultyIndicator.setPosition(vibrant.x + 260, vibrant.y + 20);
                }
                getFreeplayScore();
            }

            if (curDifficulty == 3) {
                easy.alpha = 0.35;
                normal.alpha = 0.35;
                hard.alpha = 0.35;
                vibrant.alpha = 1;
            } else {
                easy.alpha = 1;
                normal.alpha = 1;
                hard.alpha = 1;
                vibrant.alpha = 0.35;
            }

 //           if (FlxG.keys.justPressed.V) {
 //               selectedFreeplaySong = freeplaySongs[8];
 //               curDifficulty = 3;
 //               playSong();
 //           }
        }

        if (curPage == 5 && !pageCheck) {
            typingShit.hasFocus = true;
            switch (typingShit.text.toLowerCase()) {
                case 'violastro': {
                    selectedFreeplaySong = freeplaySongs[8];
                    curDifficulty = 3;
                    playSong();
                }
                case 'mind games': {
                    selectedFreeplaySong = freeplaySongs[9];
                    curDifficulty = 2;
                    playSong();
                }
                case "video games": {
                    ClientPrefs.swappedUpsDowns = !ClientPrefs.swappedUpsDowns;
                    ClientPrefs.saveSettings();
                    typingShit.text = "";
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    typingShit.hasFocus = false;
                }
                case "hard mode": {
                    ClientPrefs.hardMode = !ClientPrefs.hardMode;
                    ClientPrefs.saveSettings();
                    typingShit.text = "";
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    typingShit.hasFocus = false;
                }
                case "violasstro": {
                    ass.alpha = 1;
                    FlxTween.tween(ass, { alpha: 0 }, 2.2);
                    FlxG.sound.play(Paths.sound('boom'));
                    FlxG.sound.music.volume = 0;
                    FlxG.sound.music.fadeIn(4);
                    typingShit.text = "";
                    typingShit.hasFocus = false;
                }
                case "null": {
                    FlxG.switchState(new NullScene());
                }
            }
        } else {
            typingShit.hasFocus = false;
        }

        FlxG.watch.addQuick("Current Song:", selectedFreeplaySong);
        FlxG.watch.addQuick("Your Word:", typingShit.text);
        FlxG.watch.addQuick("Swapped?:", ClientPrefs.swappedUpsDowns);

        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		freeplayScoreText.text = lerpScore + ' (' + Math.floor(lerpRating * 100) + '%)';
		storyScoreText.text = Std.string(storyScore);

        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
        }

        if (controls.BACK && !typingShit.hasFocus)
        {
            FlxG.switchState(new TitleState());
        }

        super.update(elapsed);
    }

    function getStoryScore() {
        storyScore = Highscore.getWeekScore(curPage, curStoryDiff);
    }

    function getFreeplayScore() {
        intendedScore = Highscore.getScore(selectedFreeplaySong[0], curDifficulty);
		intendedRating = Highscore.getRating(selectedFreeplaySong[0], curDifficulty);
    }

    function pageFlip(num:Int) {
        curPage += num;
        pageCheck = true;
        FlxG.sound.play(Paths.soundRandom('pageFlip', 0, 4), FlxG.random.float(0.9, 1));
        new FlxTimer().start(0.7, function(tmr:FlxTimer) {
            pageCheck = false;
        });
        if (curPage < 0)
            curPage = 5;
        else if (curPage > 5)
            curPage = 0;

        switch (curPage) {
            case 0:
                storyMode.kill();
                mainMenu.revive();
                credits.alpha = 0;
                typingShit.alpha = 0;
                storyScoreText.alpha = 0;
                #if desktop
                DiscordClient.changePresence("Menu Book Page 1", "Main Menu");
                #end
            case 1:
                mainMenu.kill();
                storyMode.revive();
                #if desktop
                DiscordClient.changePresence("Menu Book Page 2", "Story: Violastro");
                #end
                curStoryDiff = 2;
                storyScoreText.alpha = 1;
                diffCheck.setPosition(sHard.x + 70, sHard.y + 20);
                getStoryScore();
            case 2:
                freePlay.kill();
                freeplaySongThings.kill();
                storyMode.revive();
                #if desktop
                DiscordClient.changePresence("Menu Book Page 3", "Story: Vibrants");
                #end
                freeplayScoreText.alpha = 0;
                curStoryDiff = 3;
                storyScoreText.alpha = 1;
                diffCheck.setPosition(sVibrant.x + 260, sVibrant.y + 20);
                getStoryScore();
            case 3:
                mainMenu.kill();
                storyMode.kill();
                awards.kill();
                freePlay.revive();
                freeplaySongThings.revive();
                #if desktop
                DiscordClient.changePresence("Menu Book Page 4", "Freeplay");
                #end
                freeplayScoreText.alpha = 1;
                storyScoreText.alpha = 0;
            case 4:
                mainMenu.kill();
                freePlay.kill();
                freeplaySongThings.kill();
                awards.revive();
                credits.alpha = 0;
                typingShit.alpha = 0;
                #if desktop
                DiscordClient.changePresence("Menu Book Page 5", "Awards");
                #end
                freeplayScoreText.alpha = 0;
            case 5:
                mainMenu.kill();
                awards.kill();
                credits.alpha = 1;
                typingShit.alpha = 1;
                #if desktop
                DiscordClient.changePresence("Menu Book Page 6", "Credits");
                #end  
        }
    }

    function playWeek() {
        pageCheck = true;
        FlxTween.tween(leftArrow, { alpha: 0 }, 1);
        FlxTween.tween(rightArrow, { alpha: 0 }, 1);
        FlxG.sound.play(Paths.sound('confirmMenu'));

        PlayState.storyPlaylist = weekData[curPage];
		PlayState.isStoryMode = true;
        var diffic = "";
        switch (curStoryDiff)
        {
            case 0:
                diffic = '-easy';
            case 2:
                diffic = '-hard';
            case 3:
                diffic = '-vibrant';
        }

        PlayState.storyDifficulty = curStoryDiff;
        PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
        PlayState.storyWeek = curPage;
        PlayState.campaignScore = 0;
        PlayState.campaignMisses = 0;
        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            LoadingState.loadAndSwitchState(new PlayState(), true);
        });

        FlxG.sound.music.volume = 0;
    }

    function playSong() {
        pageCheck = true;
        FlxTween.tween(leftArrow, { alpha: 0 }, 1);
        FlxTween.tween(rightArrow, { alpha: 0 }, 1);
        FlxG.sound.play(Paths.sound('confirmMenu'));

        var songLowercase:String = selectedFreeplaySong[0].toLowerCase();
        var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
        if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
            poop = songLowercase;
            curDifficulty = 1;
            trace('Couldnt find file');
        }
        trace(poop);

        PlayState.SONG = Song.loadFromJson(poop, songLowercase);
        PlayState.isStoryMode = false;
        PlayState.storyDifficulty = curDifficulty;

        PlayState.storyWeek = selectedFreeplaySong[1];
        trace('CUR WEEK' + PlayState.storyWeek);
        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            LoadingState.loadAndSwitchState(new PlayState(), true);
        });

        FlxG.sound.music.volume = 0;
    }

    function addMain() {
        var story = new FlxSprite(267, 136).loadGraphic(Paths.image("storybook/main/Story"));
        var freeplay = new FlxSprite(266, 299).loadGraphic(Paths.image("storybook/main/Freeplay"));
        var awards = new FlxSprite(272, 454).loadGraphic(Paths.image("storybook/main/Awards"));
        var credits = new FlxSprite(712, 100).loadGraphic(Paths.image("storybook/main/Credits"));
        var donate = new FlxSprite(690, 285).loadGraphic(Paths.image("storybook/main/Donate"));
        var options = new FlxSprite(713, 447).loadGraphic(Paths.image("storybook/main/Options"));

        mainMenu = new FlxSpriteGroup(0, 0);
        mainMenu.add(story);
        mainMenu.add(freeplay);
        mainMenu.add(awards);
        mainMenu.add(credits);
        mainMenu.add(donate);
        mainMenu.add(options);
        mainMenu.scrollFactor.set(0.2, 0.4);
        for (i in 0...mainMenu.length) {
            mainMenu.members[i].antialiasing = ClientPrefs.globalAntialiasing;
        }
        add(mainMenu);
    }

    function addStory() {
        sEasy = new FlxSprite(271, 431).loadGraphic(Paths.image("storybook/diffEasy"));
        sNormal = new FlxSprite(372, 430).loadGraphic(Paths.image("storybook/diffNormal"));
        sHard = new FlxSprite(475, 427).loadGraphic(Paths.image("storybook/diffHard"));
        sVibrant = new FlxSprite(273, 507).loadGraphic(Paths.image("storybook/diffVibrant"));
        diffCheck = new FlxSprite(sNormal.x + 120, sNormal.y + 50).loadGraphic(Paths.image("storybook/checkmark"));
        weekPlay = new FlxSprite(728, 500).loadGraphic(Paths.image("storybook/story/playWeek"));
        var scoreText = new FlxSprite(716, 347).loadGraphic(Paths.image("storybook/story/storyScore"));

        weekTitle = new FlxSprite(292, 127);
        weekTitle.frames = Paths.getSparrowAtlas('storybook/story/weekTitles');
		weekTitle.animation.addByPrefix('bruh', 'weekTitles', 0);
        weekTitle.animation.play('bruh');
		weekTitle.animation.curAnim.curFrame = 0;

        opponentDrawing = new FlxSprite(284, 230);
        opponentDrawing.frames = Paths.getSparrowAtlas('storybook/story/opponentDrawings');
        opponentDrawing.animation.addByPrefix('bruh', 'storyDrawingOpponent', 0);
        opponentDrawing.animation.play('bruh');
        opponentDrawing.animation.curAnim.curFrame = 0;

        playerDrawing = new FlxSprite(717, 121);
        playerDrawing.frames = Paths.getSparrowAtlas('storybook/story/playerDrawings');
        playerDrawing.animation.addByPrefix('bruh', 'storyDrawingPlayer', 0);
        playerDrawing.animation.play('bruh');
        playerDrawing.animation.curAnim.curFrame = 0;

        stickyNote = new FlxSprite(898, 633);
        stickyNote.frames = Paths.getSparrowAtlas('storybook/story/stickyNotes');
        stickyNote.animation.addByPrefix('bruh', 'StickyNote', 0);
        stickyNote.animation.play('bruh');
        stickyNote.animation.curAnim.curFrame = 0;

        weekTracks = new FlxSprite(711, 395);
        weekTracks.frames = Paths.getSparrowAtlas('storybook/story/weekTracks');
        weekTracks.animation.addByPrefix('bruh', 'weekTracks', 0);
        weekTracks.animation.play('bruh');
        weekTracks.animation.curAnim.curFrame = 0;

        storyMode = new FlxSpriteGroup(0, 0);
        storyMode.add(sEasy);
        storyMode.add(sNormal);
        storyMode.add(sHard);
        storyMode.add(sVibrant);
        storyMode.add(diffCheck);
        storyMode.add(weekPlay);
        storyMode.add(weekTitle);
        storyMode.add(opponentDrawing);
        storyMode.add(playerDrawing);
        storyMode.add(stickyNote);
        storyMode.add(weekTracks);
        storyMode.add(scoreText);
        storyMode.scrollFactor.set(0.2, 0.4);
        for (i in 0...storyMode.length) {
            storyMode.members[i].antialiasing = ClientPrefs.globalAntialiasing;
        }
        add(storyMode);

		storyScoreText = new FlxText(875, 358, 0, "", 24);
		storyScoreText.setFormat(Paths.font("Marker Felt.ttf"), 24, 0xFFC8615F, CENTER);
        storyScoreText.scrollFactor.set(0.2, 0.4);
        storyScoreText.antialiasing = ClientPrefs.globalAntialiasing;
        add(storyScoreText);
    }

    function addFreeplay() {
        easy = new FlxSprite(708, 375).loadGraphic(Paths.image("storybook/diffEasy"));
        normal = new FlxSprite(808, 374).loadGraphic(Paths.image("storybook/diffNormal"));
        hard = new FlxSprite(912, 370).loadGraphic(Paths.image("storybook/diffHard"));
        vibrant = new FlxSprite(709, 445).loadGraphic(Paths.image("storybook/diffVibrant"));
        songPlay = new FlxSprite(872, 520).loadGraphic(Paths.image("storybook/freeplay/FPPlay"));
        var score = new FlxSprite(712, 523).loadGraphic(Paths.image("storybook/freeplay/FPScore"));
        var label = new FlxSprite(757, 110).loadGraphic(Paths.image("storybook/freeplay/freeplayLabel"));

        vibrant.alpha = 0.35;
        
//      bwehehe = new FlxSprite(252, 104).loadGraphic(Paths.image("storybook/freeplay/Bwehehe"));

        var j = 0;
        var k = 0;

        freePlay = new FlxSpriteGroup(0, 0);
        freeplaySongThings = new FlxSpriteGroup();
        add(freeplaySongThings);

        for (i in 0...2) {
            var divider = new FlxSprite(260 + (444 * i), 352).loadGraphic(Paths.image("storybook/freeplay/freeplayDivider"));
            freePlay.add(divider);
        }

        for (i in 0...8) {
            if (i >= 3 && i <= 5) {
                j = 15;
            }
            if (i >= 6 && i <= 7) {
                j = -420;
                k = 440;
            }
            var ui_tex = Paths.getSparrowAtlas('storybook/freeplay/FreeplaySongs');
            bwehehe = new FlxSprite(252 + k, 106 + (82 * i) + j);
            bwehehe.frames = ui_tex;
            bwehehe.animation.addByPrefix('bruh', 'SongNames', 0);
            bwehehe.animation.play('bruh');
            bwehehe.animation.curAnim.curFrame = i;
//          bwehehe.scrollFactor.set(0.2, 0.4);
            bwehehe.antialiasing = ClientPrefs.globalAntialiasing;
            freeplaySongThings.add(bwehehe);
        }
        freeplaySongThings.scrollFactor.set(0.2, 0.4);

        fdifficultyIndicator = new FlxSprite(normal.x + 70, normal.y + 20).loadGraphic(Paths.image("storybook/checkmark"));
        songIndicator = new FlxSprite(freeplaySongThings.members[0].x + 290, freeplaySongThings.members[0].y + 20).loadGraphic(Paths.image("storybook/checkmark"));
        //diffCheck.setPosition(hard.x + 120, hard.y + 50);

        freePlay.add(easy);
        freePlay.add(normal);
        freePlay.add(hard);
        freePlay.add(vibrant);
        freePlay.add(songPlay);
        freePlay.add(score);
        freePlay.add(label);
        freePlay.add(songIndicator);
        freePlay.add(fdifficultyIndicator);
        for (i in 0...freePlay.length) {
            freePlay.members[i].antialiasing = ClientPrefs.globalAntialiasing;
        }
        freePlay.scrollFactor.set(0.2, 0.4);
        add(freePlay);

		freeplayScoreText = new FlxText(718, 560, 0, "", 24);
		freeplayScoreText.setFormat(Paths.font("Marker Felt.ttf"), 24, 0xFFC8615F, CENTER);
        freeplayScoreText.scrollFactor.set(0.2, 0.4);
        freeplayScoreText.antialiasing = ClientPrefs.globalAntialiasing;
        add(freeplayScoreText);
    }

    function addAwards() {
        var j = 0;
        var k = 0;

        awards = new FlxSpriteGroup(0, 0);
        add(awards);

        var awardsLabel = new FlxSprite(319, 118).loadGraphic(Paths.image('storybook/awards/awardsLabel'));
        awards.add(awardsLabel);

        for (i in 0...7) {
            if (i == 3) {
                k = 442; j = -440;
            }
            var award = new FlxSprite(250 + k, 200 + (120 * i) + j);
            award.loadGraphic(Paths.image('storybook/awards/allAwards'), true, 320, 120);
            if (Achievements.achievementsUnlocked[i][1]) {
                award.animation.add('icon', [i], 0, false, false);
            } else {
                award.animation.add('icon', [7], 0, false, false);
            }
            award.animation.play('icon');
            award.antialiasing = ClientPrefs.globalAntialiasing;
            awards.add(award);
        }
        awards.scrollFactor.set(0.2, 0.4);
    }

    function addCredits() {
        typingShit = new FlxInputText(698, 563, 300, "", 24, 0xFFC8615F, FlxColor.TRANSPARENT, true);
		typingShit.setFormat(Paths.font("Marker Felt.ttf"), 24, 0xFFC8615F, CENTER);
        typingShit.antialiasing = ClientPrefs.globalAntialiasing;
        typingShit.scrollFactor.set(0.2, 0.4);
        typingShit.maxLength = 12;
        typingShit.bold = true;
        add(typingShit);

        credits = new FlxSprite(260, 115).loadGraphic(Paths.image('storybook/credits'));
        credits.antialiasing = ClientPrefs.globalAntialiasing;
        credits.scrollFactor.set(0.2, 0.4);
        add(credits);

        ass = new FlxSprite(0, 0).loadGraphic(Paths.image('storybook/LOL/violasstro'));
        ass.setGraphicSize(Std.int(ass.width * 0.7));
        ass.cameras = [camHUD];
        ass.screenCenter();
        ass.alpha = 0;
        add(ass);
    }
}