using Godot;
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using Vosk;

public partial class SpeechRecognizer : Node
{

	[Export(PropertyHint.Dir, "The VOSK model folder")]
	string modelPath = "res://GodotSpeechRecognition/models/en_us_small";
	[Export(PropertyHint.None, "The name of the bus that contains the record effect")]
	string recordBusName = "Record";
	[Export(PropertyHint.None, "Stop recognition after x milliseconds")]
	long timeoutInMS = 10000;
	[Export(PropertyHint.None, "Stop recognition if there is no change in output for x milliseconds.")]
	long noChangeTimeoutInMS = 3000;
	[Export(PropertyHint.None, "Don't stop recongizer until timeout.")]
	bool continuousRecognition = false;
	// ADD THIS: The strict Grammar rule for Vosk
	// It MUST include "[unk]" at the end so it knows how to handle random background noise!
	private string _grammarJson = "[\"mở cửa\", \"đóng cửa\", \"bắt đầu\", \"[unk]\"]";
	[Signal]
	public delegate void OnPartialResultEventHandler(string partialResults);
	[Signal]
	public delegate void OnFinalResultEventHandler(string finalResults);
	
	private int recordBusIdx;
	private AudioEffectRecord _microphoneRecord;  // The microphone recording bus effect
	private bool isListening = false;
	private Model model;
	private string partialResult;
	private string finalResult;
	private ulong recordTimeStart;
	private ulong noChangeTimeOutStart;
	private CancellationTokenSource cancelToken;
	private double processInterval = 0.2;

	// CONTINUOUS RECOGNITION FIELDS
	private VoskRecognizer _recognizer;
	private int _lastProcessedByte = 0;

	public override void _Ready()
	{
		IntializeOSSpecificLibs(); //Doesn't seem to automatically load these libs
		recordBusIdx = AudioServer.GetBusIndex(recordBusName);
		
		// Dynamically find the AudioEffectRecord regardless of where it is in the list
		int effectCount = AudioServer.GetBusEffectCount(recordBusIdx);
		for (int i = 0; i < effectCount; i++)
		{
			if (AudioServer.GetBusEffect(recordBusIdx, i) is AudioEffectRecord recordEffect)
			{
				_microphoneRecord = recordEffect;
				break;
			}
		}

		if (_microphoneRecord == null)
		{
			GD.PrintErr("CRITICAL ERROR: Could not find AudioEffectRecord on bus " + recordBusName);
		}

		GD.Print($"Microphone Mix Rate: {AudioServer.GetMixRate()} Hz");
		model = new Model(ProjectSettings.GlobalizePath(modelPath));
		Vosk.Vosk.SetLogLevel(0);
		cancelToken = new CancellationTokenSource();
		DebugPrint("Initialized Speech Recognition");
	}

	private static void IntializeOSSpecificLibs()
	{
		switch (OS.GetName())
		{
			case "Windows":
			case "UWP":
				NativeLibrary.Load(Path.Join(AppContext.BaseDirectory, "libvosk.dll"));
				break;
			case "macOS":
				NativeLibrary.Load(Path.Join(AppContext.BaseDirectory, "libvosk.dylib"));
				break;
			case "Linux":
			case "FreeBSD":
			case "NetBSD":
			case "OpenBSD":
			case "BSD":
				NativeLibrary.Load(Path.Join(AppContext.BaseDirectory, "libvosk.so"));
				break;
			case "Android":
				NativeLibrary.Load(Path.Join(AppContext.BaseDirectory, "libvosk.so"));
				break;
			case "iOS":
				GD.PrintErr("No IOS Support");
				break;
			case "Web":
				GD.PrintErr("No Web Support");
				break;
		}
	}

	private static void DebugPrint(string debugString)
	{
		if (OS.IsDebugBuild())
		{
			GD.Print(debugString);
		}
	}

	private void StartContinuousSpeechRecognition()
	{
		_ = Task.Factory.StartNew(async () =>
		{
			while (!cancelToken.IsCancellationRequested)
			{
				await Task.Delay(TimeSpan.FromSeconds(processInterval).Milliseconds, cancelToken.Token);
				ProcessMicrophone();
				ulong currentTime = Time.GetTicksMsec();
				if (!continuousRecognition && isListening && (currentTime - noChangeTimeOutStart) > (ulong)noChangeTimeoutInMS)
				{
					StopSpeechRecoginition();
				}
				else if (isListening && (currentTime - recordTimeStart) >= (ulong)timeoutInMS)
				{
					DebugPrint("Stopping from Timeout");
					StopSpeechRecoginition();
				}
			}
		});
	}

	private void ProcessMicrophone()
	{
		if (_microphoneRecord != null && _microphoneRecord.IsRecordingActive())
		{
			var recordedSample = _microphoneRecord.GetRecording();
			if (recordedSample != null && _recognizer != null)
			{
				byte[] fullData = recordedSample.Data;
				int availableBytes = fullData.Length - _lastProcessedByte;

				// Ensure we only process complete audio frames (4 bytes for 16-bit stereo, 2 for mono)
				int bytesPerFrame = recordedSample.Stereo ? 4 : 2;
				availableBytes -= (availableBytes % bytesPerFrame);

				if (availableBytes > 0)
				{
					byte[] chunk = new byte[availableBytes];
					Array.Copy(fullData, _lastProcessedByte, chunk, 0, availableBytes);
					_lastProcessedByte += availableBytes;

					byte[] monoData = recordedSample.Stereo ? MixStereoToMono(chunk) : chunk;

					if (_recognizer.AcceptWaveform(monoData, monoData.Length))
					{
						// AcceptWaveform returns true when the speaker pauses (a full utterance is detected)
						string currentFinal = _recognizer.FinalResult();
						CallDeferred("emit_signal", "OnFinalResult", currentFinal);

						if (!continuousRecognition)
						{
							StopSpeechRecoginition();
						}
					}
					else
					{
						// AcceptWaveform returns false while the speaker is still talking
						string currentPartialResult = _recognizer.PartialResult();
						if (partialResult == null || !currentPartialResult.Equals(partialResult))
						{
							partialResult = currentPartialResult;
							noChangeTimeOutStart = Time.GetTicksMsec();
							CallDeferred("emit_signal", "OnPartialResult", partialResult);
						}
					}
				}
			}
		}
	}

	private void EndRecognition()
	{
		if (_recognizer != null)
		{
			finalResult = _recognizer.FinalResult();
			_recognizer.Dispose();
			_recognizer = null;
		}
	}

	public void StartSpeechRecognition()
	{
		if (cancelToken != null && !cancelToken.IsCancellationRequested)
		{
			cancelToken.Cancel();
		}
		
		// Initialize the recognizer ONCE for this recording session
		if (_recognizer != null) 
		{
			_recognizer.Dispose();
		}
		_recognizer = new VoskRecognizer(model, AudioServer.GetMixRate(), _grammarJson);
		_lastProcessedByte = 0;

		cancelToken = new CancellationTokenSource();
		partialResult = "";
		finalResult = "";
		recordTimeStart = Time.GetTicksMsec();
		noChangeTimeOutStart = Time.GetTicksMsec();
		isListening = true;

		// Quickly toggle recording to clear the internal Godot buffer
		if (_microphoneRecord.IsRecordingActive())
		{
			_microphoneRecord.SetRecordingActive(false);
		}
		_microphoneRecord.SetRecordingActive(true);

		StartContinuousSpeechRecognition();
	}

	public string StopSpeechRecoginition()
	{
		isListening = false;
		cancelToken.Cancel();
		if (_microphoneRecord != null && _microphoneRecord.IsRecordingActive())
		{
			_microphoneRecord.SetRecordingActive(false);
			EndRecognition(); // get final result and dispose
			CallDeferred("emit_signal", "OnFinalResult", finalResult);
		}
		return finalResult;
	}

	private byte[] MixStereoToMono(byte[] input)
	{
		// If the sample length can be divided by 4, it's a valid stereo sound
		if (input.Length % 4 == 0)
		{
			byte[] output = new byte[input.Length / 2];                 // create a new byte array half the size of the stereo length
			int outputIndex = 0;
			for (int n = 0; n < input.Length; n += 4)                     // Loop through each stereo sample
			{
				int leftChannel = BitConverter.ToInt16(input, n);        // Get the left channel
				int rightChannel = BitConverter.ToInt16(input, n + 2);     // Get the right channel
				int mixed = (leftChannel + rightChannel) / 2;           // Mix them together
				byte[] outSample = BitConverter.GetBytes((short)mixed); // Convert mix to bytes

				// copy in the first 16 bit sample
				output[outputIndex++] = outSample[0];
				output[outputIndex++] = outSample[1];
			}
			return output;
		}
		else
		{
			byte[] output = new byte[24];
			return output;
		}
	}

	public override void _Notification(int what)
	{
		if (what == NotificationWMCloseRequest)
		{
			if (_recognizer != null) 
			{
				_recognizer.Dispose();
			}
			model.Dispose();
			GetTree().Quit(); // default behavior
		}
	}

	public bool isCurrentlyListening()
	{
		return isListening;
	}
}
