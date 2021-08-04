package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.util.FlxColor;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import sys.thread.Thread;

class PlayState extends FlxState
{
	var fuck:FlxSprite;

	var audioBuffer:AudioBuffer;
	var bytes:Bytes;

	override public function create()
	{
		super.create();

		fuck = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		add(fuck);

		audioBuffer = AudioBuffer.fromFile("./assets/music/music.ogg");
		Sys.println("Channels        : " + audioBuffer.channels + "\nBits per sample : " + audioBuffer.bitsPerSample);

		/* for (i in 0...(100 * (Std.int(audioBuffer.bitsPerSample / 8))) + 10)
			{
				if (audioBuffer.data[i] != null)
				{
					Sys.println("position " + i + " i got " + StringTools.hex(audioBuffer.data[i]));
				}
				else
					Sys.println("position " + i + " i got fucking nothing");
		}*/

		bytes = audioBuffer.data.toBytes();
		// Sys.println(bytes.length);

		/* for (i in 0...Std.int(bytes.length / (audioBuffer.bitsPerSample / 8)))
			{
				if ((i * 4) < bytes.length)
				{
					var epic:Int = bytes.getUInt16(i * 4);
					if (epic > 65535 / 2)
						epic -= 65535;

					var floatSample:Float = (epic / 65535);

					var color:FlxColor = FlxColor.WHITE;

					var ry:Float = floatSample * 300;
					if (ry < 0)
						ry = 0;

					if (Std.int(i / 900) > 1280)
						break;

					fuck.pixels.fillRect(new Rectangle(Std.int(i / 900), (FlxG.height / 2) - ry, 1, Math.abs(floatSample * 300)), color);
				}
				else
					break;
		}*/
		/* var samplesPerPixel:Int = 50;
			var samples:Array<Int> = [];
			var sumX:Int = 0;

			for (i in 0...Std.int(bytes.length / (audioBuffer.bitsPerSample / 8)))
			{
				if ((i * 4) < bytes.length)
				{
					samples.push(bytes.getUInt16(i * 4));

					if (i % samplesPerPixel == 0 && !(i % samplesPerPixel == i))
					{
						var averagedSample:Int;
						var sumSample:Int = 0;
						for (sample in samples)
						{
							sumSample += sample;
						}

						averagedSample = Std.int(sumSample / samples.length);

						if (averagedSample > 65535 / 2)
							averagedSample -= 65535;

						var floatSample:Float = averagedSample / 65535;

						var color:FlxColor = FlxColor.WHITE;

						var ry:Float = floatSample * 300;
						if (ry < 0)
							ry = 0;

						fuck.pixels.fillRect(new Rectangle(sumX, (FlxG.height / 2) - ry, 1, Math.abs(floatSample * 300)), color);

						sumX += 1;
					}
				}
		}*/
		/* for (i in 0...Std.int(audioBuffer.data.length / (audioBuffer.bitsPerSample / 8)))
			{
				var first:Int = Std.int(audioBuffer.data[i * 2]);
				var second:Int = Std.int(audioBuffer.data[(i * 2) + 1]);

				// Sys.println(i + " | " + i * 2 + " | " + ((i * 2) + 1) + " | " + sample);
				Sys.println(second);

				fuck.pixels.fillRect(new Rectangle(i * 2, 0, 2, second), FlxColor.WHITE);
		}*/

		// fuck.pixels.fillRect(new Rectangle(0, 0, 10, 200), FlxColor.WHITE);

		Sys.println(bytes.length);

		FlxG.sound.playMusic(Sound.fromAudioBuffer(audioBuffer));

		Thread.create(function()
		{
			/* var index = -1;
				var drawIndex = -1;

				trace("iterating...");

				try
				{
					while (true)
					{
						index += 1;
						drawIndex += 1;

						if ((index * 4) > (bytes.length - 1))
							break;

						var epic:Int = bytes.getUInt16(index * 4);
						// trace(epic);
						if (epic > 65535 / 2)
							epic -= 65535;

						var floatSample:Float = (epic / 65535);

						var color:FlxColor = FlxColor.WHITE;

						var ry:Float = floatSample * 300;
						if (ry < 0)
							ry = 0;

						if (Std.int(drawIndex / 500 * 1) > 1280)
						{
							fuck.pixels.fillRect(new Rectangle(0, 0, 1280, 720), 0x70000000);
							drawIndex = 0;
							trace(drawIndex);
							continue;
						}

						// fuck.pixels.fillRect(new Rectangle(Std.int(drawIndex / 100 * 2) + 2, 0, 10, 720), FlxColor.BLACK);
						fuck.pixels.fillRect(new Rectangle(Std.int(drawIndex / 500), (FlxG.height / 2) - ry, 1, Math.abs(floatSample * 300)), color);
						// fuck.pixels.fillRect(new Rectangle(Std.int(drawIndex / 400), (FlxG.height / 2) - (floatSample * 300), 1, 1), color);

						// Sys.sleep(0.0001);
					}
				}
				catch (e)
				{
					Sys.println("Why the fuck did it throw an exception???? index: " + (index * 4));
				}

				trace("done");
			 */

			var currentTime:Float = Sys.time();
			var finishedTime:Float;

			var index:Int = 0;
			var drawIndex:Int = 0;
			var samplesPerCollumn:Int = 600;

			var min:Float = 0;
			var max:Float = 0;

			Sys.println("Interating");

			while ((index * 4) < (bytes.length - 1))
			{
				var byte:Int = bytes.getUInt16(index * 4);

				if (byte > 65535 / 2)
					byte -= 65535;

				var sample:Float = (byte / 65535);

				if (sample > 0)
				{
					if (sample > max)
						max = sample;
				}
				else if (sample < 0)
				{
					if (sample < min)
						min = sample;
				}

				if ((index % samplesPerCollumn) == 0)
				{
					// trace("min: " + min + ", max: " + max);

					if (drawIndex > 1280)
					{
						drawIndex = 0;
					}

					var pixelsMin:Float = Math.abs(min * 300);
					var pixelsMax:Float = max * 300;

					fuck.pixels.fillRect(new Rectangle(drawIndex, 0, 1, 720), 0xFF000000);
					fuck.pixels.fillRect(new Rectangle(drawIndex, (FlxG.height / 2) - pixelsMin, 1, pixelsMin + pixelsMax), FlxColor.WHITE);
					drawIndex += 1;

					min = 0;
					max = 0;
				}

				index += 1;
			}

			finishedTime = Sys.time();

			Sys.println("Took " + (finishedTime - currentTime) + " seconds.");
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
