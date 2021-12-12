import flixel.FlxG;

class Ratings
{
    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "N/A";
		if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "BotPlay";

        if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
            ranking = "[SFC]";
        else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
            ranking = "[GFC]";
        else if (PlayState.misses == 0) // Regular FC
            ranking = "[FC]";
        else if (PlayState.misses < 10) // Single Digit Combo Breaks
            ranking = "[SDCB]";
        else
            ranking = "";

        var wifeConditions:Array<Bool> = [
            accuracy >= 99.5, // S++
            accuracy >= 99, // S+
            accuracy >= 97.34, // S
            accuracy >= 95.68, // S-
            accuracy >= 94.02, // A+
            accuracy >= 92.36, // A
            accuracy >= 90, // A-
            accuracy >= 88, // B+
            accuracy >= 85, // B
            accuracy >= 80, // B-
            accuracy >= 78, // C+
            accuracy >= 75, // C
            accuracy >= 70, // C-
            accuracy >= 68, // D+
            accuracy >= 65, // D
            accuracy >= 60, // D-
            accuracy < 60 // F
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " SSS";
                    case 1:
                        ranking += " SS";
                    case 2:
                        ranking += " S";
                    case 3:
                        ranking += " S-";
                    case 4:
                        ranking += " A+";
                    case 5:
                        ranking += " A";
                    case 6:
                        ranking += " A-";
                    case 7:
                        ranking += " B+";
                    case 8:
                        ranking += " B";
                    case 9:
                        ranking += " B-";
                    case 10:
                        ranking += " C+";
                    case 11:
                        ranking += " C";
                    case 12:
                        ranking += " C-";
                    case 13:
                        ranking += " D+";
                    case 14:
                        ranking += " D";
                    case 15:
                        ranking += " D-";
                    case 16:
                        ranking += " E";
                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "N/A";
		else if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "BotPlay";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;

        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

        if (FlxG.save.data.botplay && !PlayState.loadRep)
            return "sick"; // FUNNY
	

        var rating = checkRating(noteDiff,customTimeScale);


        return rating;
    }

    public static function checkRating(ms:Float, ts:Float)
    {
        var rating = "sick";
        if (ms <= 166 * ts && ms >= 135 * ts)
            rating = "shit";
        if (ms < 135 * ts && ms >= 90 * ts) 
            rating = "bad";
        if (ms < 90 * ts && ms >= 45 * ts)
            rating = "good";
        if (ms < 45 * ts && ms >= -45 * ts)
            rating = "sick";
        if (ms > -90 * ts && ms <= -45 * ts)
            rating = "good";
        if (ms > -135 * ts && ms <= -90 * ts)
            rating = "bad";
        if (ms > -166 * ts && ms <= -135 * ts)
            rating = "shit";
        return rating;
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,nps:Int,maxNPS:Int,accuracy:Float):String
    {
        return
         (FlxG.save.data.npsDisplay ? "NPS: " + nps + " (Max " + maxNPS + ")" : "") + 
         (((FlxG.save.data.scoreDisplay || FlxG.save.data.missDisplay || FlxG.save.data.accuracyDisplay) && FlxG.save.data.npsDisplay) ? " | " : "") +
         (FlxG.save.data.scoreDisplay ? "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : " " + score + "") : "") +
         (((FlxG.save.data.missDisplay || FlxG.save.data.accuracyDisplay) && FlxG.save.data.scoreDisplay) ? " | " : "") +
         (FlxG.save.data.missDisplay ? "Misses:" + PlayState.misses + "" : "") +
         ((FlxG.save.data.accuracyDisplay && FlxG.save.data.missDisplay) ? " | " : "") +
         (FlxG.save.data.accuracyDisplay ? "Accuracy:" + (PlayStateChangeables.botPlay && !PlayState.loadRep ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + "%") + " | " + GenerateLetterRank(accuracy) : "");
    }
}
