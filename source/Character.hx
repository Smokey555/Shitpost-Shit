package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var canAutoAnim:Bool = true;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas("GF_assets");
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'twi':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('twi');
				frames = tex;
				animation.addByPrefix('idle', '1twidle', 24, false);
				animation.addByPrefix('singUP', '2up', 24, false);
				animation.addByPrefix('singRIGHT', '4right', 24, false);
				animation.addByPrefix('singDOWN', '3down', 24, false);
				animation.addByPrefix('singLEFT', '5left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", -2, 2);
				addOffset("singRIGHT", -17, 1);
				addOffset("singLEFT", 35, 2);
				addOffset("singDOWN", 35, -35);
	
				playAnim('idle');
			case 'mordecai':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('mordecai');
				frames = tex;

				animation.addByPrefix('idle', 'mord idle', 24, false);
				animation.addByPrefix('singUP', 'mord up', 24, false);
				animation.addByPrefix('singRIGHT', 'mord left', 24, false);
				animation.addByPrefix('singDOWN', 'mord down', 24, false);
				animation.addByPrefix('singLEFT', 'mord right', 24, false);
				animation.addByPrefix('singUPmiss', 'mord miss up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'mord miss left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'mord miss down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'mord miss right', 24, false);

				animation.addByPrefix('firstDeath', "mord die", 24, false);
				animation.addByPrefix('deathLoop', "mord dead loop", 24, true);
				animation.addByPrefix('deathConfirm', "mord dead confirm", 24, false);

		
				addOffset('idle');
				addOffset("singUP", -35, 7);
				addOffset("singRIGHT", -25, -7);
				addOffset("singLEFT", 100, -20);
				addOffset("singDOWN", -10, -117);
				addOffset("singUPmiss", -35, 7);
				addOffset("singRIGHTmiss", -25, -7);
				addOffset("singLEFTmiss", 100, -20);
				addOffset("singDOWNmiss", -10, -117);
		
				playAnim('idle');
				
				scale.set(1.5, 1.5);
				flipX = true;
		}

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

		animation.finishCallback = animationEnd;

	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				idleEnd();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
				default:
					if(holdTimer == 0)
						playAnim('idle', true);
			}
		}
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky":
					playAnim('danceRight', true, false, animation.getByName('danceRight').numFrames - 1);
				default:
					playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name))
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

	function animationEnd(name:String){

		switch(curCharacter){
			case "mom-car":
				switch(name){
					case "idle":
						playAnim(name, false, false, 8);
					case "singUP":
						playAnim(name, false, false, 4);
					case "singDOWN":
						playAnim(name, false, false, 4);
					case "singLEFT":
						playAnim(name, false, false, 2);
					case "singRIGHT":
						playAnim(name, false, false, 2);
				}

			case "bf-car":
				switch(name){
					case "idle":
						playAnim(name, false, false, 8);
					case "singUP":
						playAnim(name, false, false, 3);
					case "singDOWN":
						playAnim(name, false, false, 2);
					case "singLEFT":
						playAnim(name, false, false, 4);
					case "singRIGHT":
						playAnim(name, false, false, 2);
				}

			case "monster-christmas" | "monster":
				switch(name){
					case "idle":
						playAnim(name, false, false, 10);
					case "singUP":
						playAnim(name, false, false, 8);
					case "singDOWN":
						playAnim(name, false, false, 7);
					case "singLEFT":
						playAnim(name, false, false, 5);
					case "singRIGHT":
						playAnim(name, false, false, 6);
				}

		}

	}
}
