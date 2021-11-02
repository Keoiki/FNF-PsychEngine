package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == this.character) return;
	
		this.character = character;
		antialiasing = ClientPrefs.globalAntialiasing;

		switch(character) {
			case 'bf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_BF');
				animation.addByPrefix('idle', "M BF Idle", 24);
				animation.addByPrefix('confirm', 'M bf HEY', 24, false);

			case 'gf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_GF');
				animation.addByPrefix('idle', "M GF Idle", 24);

			case 'dad':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Dad');
				animation.addByPrefix('idle', "M Dad Idle", 24);

			case 'violastro':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Violastro');
				animation.addByPrefix('idle', 'M Violastro Idle', 24);

			case 'venturers':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Venturers');
				animation.addByPrefix('idle', 'M Venturers Idle', 24);

			case 'vio-bf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_VBF');
				animation.addByPrefix('idle', "M VBF Idle", 24);
				animation.addByPrefix('confirm', 'M VBF HEY', 24, false);

			case 'vio-gf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_VGF');
				animation.addByPrefix('idle', "M VGF Idle", 24);
		}
		animation.play('idle');
		updateHitbox();

		switch(character) {
			case 'bf':
				offset.set(15, -40);

			case 'gf':
				offset.set(-40, -25);

			case 'violastro':
				offset.set(60, 10);

			case 'venturers':
				offset.set(80, -40);
				
			case 'vio-bf':
				offset.set(20, -45);

			case 'vio-gf':
				offset.set(-70, 0);
		}
	}
}
