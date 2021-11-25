package;

import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change if the arrows come from the bottom or the top."),
			new MiddleScrollOption("Put your lane in the center or on the right."),
			new GhostTapOption("If enabled, you will not lose health or get a miss when you tap a button."),
			new Judgement("Customize how many frames you have to hit the note."),
			#if desktop
			new FPSCapOption("Change the highest amount of FPS you can have."),
			#end
			new ScrollSpeedOption("Edit your scroll speed value."),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Millisecond Based)"),
			new ResetButtonOption("Toggle pressing R to instantly die."),
			new CustomizeGameplay("Drag around the ratings to your liking.")
		]),
		new OptionCategory("Appearance", [
			new NoteSplashes("When hitting a SICK!, the note plays an animation."),
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new Colour("The color of the healthbar now fits with everyone's icons."),
			new LaneUnderlayOption("Toggles if the notes have a black background behind them for visibility."),
			new CamZoomOption("Toggle the camera zoom in-game."),
			new SpaceOption(""),
			#if desktop
			new RainbowFPSOption("Change the FPS counter to flash rainbow."),
			new FPSOption("Turn the FPS counter on or off."),
			new SpaceOption(""),
			new CpuStrums("The CPU's strumline lights up when a note hits it, like Boyfriend's strumline."),
			#end
			new ScoreScreen("Show a list of all your stats at the end of a song/week."),
			new ShowInput("Display every single input in the score screen."),
		]),
		new OptionCategory("UI and Interface", [
			new HealthBarOption("Toggle the health bar."),
			new ScoreTextOption("Toggle the score text."),
			new WatermarkOption("Toggle the watermarks in certain places."),
			new SongPositionOption("Toggle showing how far you are in the song."),
			new SpaceOption(""),
			new NPSDisplayOption("Display the amount of notes per second."),
			new ComboBreakOption("Display the amount of combo breaks."),
			new ScoreOption("Display score information."),
			new AccuracyOption("Display accuracy information."),
		]),
		new OptionCategory("Miscellaneous", [
			#if desktop
			new ReplayOption("View replays"),
			#end
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new Optimization("Removes everything except your notes and UI. Great for poor computers that cannot handle effects."),
			new BotPlay("Showcase your charts and mods with autoplay."),
		])
		
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var descriptionText:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	var categoryText:FlxText;

	var optionTitle:FlxSprite;
	var black:FlxSprite;
	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFF86b5bf;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		optionTitle = new FlxSprite(0, 55);
		optionTitle.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		optionTitle.animation.addByPrefix('selected', "options white", 24);
		optionTitle.animation.play('selected');
		optionTitle.scrollFactor.set();
		optionTitle.antialiasing = true;
		optionTitle.updateHitbox();
		optionTitle.screenCenter(X);
		//thanks rozebud
		add(optionTitle);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls); //test thing

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.screenCenter(X);
			controlLabel.isCategoryOption = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		categoryText = new FlxText(50, 640, 1180, "Please select a category.", 32);
		categoryText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		categoryText.scrollFactor.set();
		categoryText.borderSize = 2.4;
		add(categoryText);

		descriptionText = new FlxText(FlxG.width - 460, 10, 450, currentDescription, 12);
		descriptionText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.borderSize = 2;
		descriptionText.scrollFactor.set();
		//blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(descriptionText.width + 900)),Std.int(descriptionText.height + 600),FlxColor.BLACK);
		//blackBorder.alpha = 0.5;

		black = new FlxSprite(-700).loadGraphic(Paths.image('blackFade'));
		black.scrollFactor.x = 0;
		black.scrollFactor.y = 0;
		black.setGraphicSize(Std.int(black.width * 1.1));
		black.updateHitbox();
		//black.screenCenter();
		black.antialiasing = true;

		//FlxTween.tween(descriptionText,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		//FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		super.create();
	}

	var isCat:Bool = false;
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				add(categoryText);
				remove(descriptionText);
				FlxTween.tween(black,{x: -700}, 0.5, {ease: FlxEase.expoInOut});
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					remove(black);
				});
				new FlxTimer().start(0.25, function(tmr:FlxTimer)
				{
					add(optionTitle);
					FlxTween.tween(optionTitle,{y: 55}, 0.5, {ease: FlxEase.expoInOut});
				});
				grpControls.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) - 30, options[i].getName(), true, false);
					controlLabel.isCategoryOption = true;
					controlLabel.screenCenter(X);
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}
				
				curSelected = 0;
				
				changeSelection(curSelected);
			}

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(1);
				}
			}
			
			if (FlxG.keys.justPressed.UP)
				changeSelection(-1);
			if (FlxG.keys.justPressed.DOWN)
				changeSelection(1);
			
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
					
					descriptionText.text = currentDescription;
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					descriptionText.text = currentDescription;
				else
					descriptionText.text = currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset -= 0.1;
				}
				else if (FlxG.keys.pressed.RIGHT)
					FlxG.save.data.offset += 0.1;
				else if (FlxG.keys.pressed.LEFT)
					FlxG.save.data.offset -= 0.1;
				
				descriptionText.text = currentDescription;
			}
		

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
						trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					add(black);
					remove(categoryText);
					add(descriptionText);
					FlxTween.tween(optionTitle,{y: -300}, 0.5, {ease: FlxEase.expoInOut});
					new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						remove(optionTitle);
					});
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
							controlLabel.isOption = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
					FlxTween.tween(black,{x: -100}, 0.5, {ease: FlxEase.expoInOut});
					curSelected = 0;
				}
				
				changeSelection();
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				descriptionText.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				descriptionText.text = currentDescription;
		}
		else
			descriptionText.text = currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
