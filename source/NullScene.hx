package;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxG;

#if desktop
import Discord.DiscordClient;
#end

class NullScene extends MusicBeatState
{
    var cardinal:FlxSprite;

    override function create()
    {
        FlxG.sound.music.stop();

        var dots:Alphabet = new Alphabet(0, 0, '...', true, true, 0.2, 3);
        dots.screenCenter(X);
        dots.x -= 175;
        add(dots);

        cardinal = new FlxSprite(0, 100);
        cardinal.frames = Paths.getSparrowAtlas('cardinal_disappointed');
        cardinal.animation.addByPrefix('start', 'Cardinal Disappointed', 24, false);
        cardinal.animation.addByPrefix('loop', 'Cardinal Disappointed Loop', 24, true);
        cardinal.animation.play('start');
        cardinal.screenCenter(X);
        cardinal.setGraphicSize(Std.int(cardinal.width * 0.85));
        cardinal.antialiasing = ClientPrefs.globalAntialiasing;
        cardinal.alpha = 0;
        add(cardinal);

        FlxG.sound.playMusic(Paths.music('nothing'), 0);
		FlxG.sound.music.fadeIn(5, 0, 1);
        FlxTween.tween(cardinal, { alpha: 1 }, 2, { startDelay: 2.5});

        #if desktop
        DiscordClient.changePresence("What are you doing here?", "There's nothing back here.");
        #end

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (cardinal.animation.curAnim.name == 'start' && cardinal.animation.curAnim.finished) {
            cardinal.animation.play('loop');
        }

        super.update(elapsed);
    }
}