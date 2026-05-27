using Godot;
using System;
using System.Collections.Generic;

public partial class MicInput : Node
{
	// 1. Unified into a SINGLE exported variable that matches the rest of the code!
	[Export] private SpeechRecognizer _recognizer;

	public static MicInput Instance { get; private set; }

	[Signal]
	public delegate void OnCommandRecognizedEventHandler(string actionId);

	public event Action<string> OnRawPartialText;
	public event Action<string> OnRawFinalText;

	private Dictionary<string, string> _vocabulary = new Dictionary<string, string>
	{
		{ "open door", "door_open" },
		{ "mở cửa", "door_open" },
		{ "close door", "door_close" },
		{ "đóng cửa", "door_close" },
		{ "start", "tutorial_start" },
		{ "bắt đầu", "tutorial_start" }
	};

	public override void _Ready()
	{
		Instance = this;
		// 2. We don't need GetNode anymore because the Inspector handles the link
		if (_recognizer != null)
		{
			_recognizer.OnPartialResult += (text) =>
			{
				ProcessRawSpeech(text);
				OnRawPartialText?.Invoke(text);
			};

			_recognizer.OnFinalResult += (text) => OnRawFinalText?.Invoke(text);

			GD.Print("SpeechBrain: Online and listening.");
		}
		else
		{
			GD.PrintErr("SpeechBrain: Critical Failure. SpeechRecognizer is null. Did you assign it in the Inspector?");
		}
	}

	private void ProcessRawSpeech(string rawText)
	{
		if (string.IsNullOrWhiteSpace(rawText)) return;
		string normalized = rawText.ToLower().Trim();

		foreach (var kvp in _vocabulary)
		{
			if (normalized.Contains(kvp.Key))
			{
				GD.Print($"SpeechBrain: Heard '{kvp.Key}'. Broadcasting action '{kvp.Value}' globally.");
				EmitSignal(SignalName.OnCommandRecognized, kvp.Value);
				break;
			}
		}
	}

	public void TurnOnMic() => _recognizer?.StartSpeechRecognition();
	public string TurnOffMic() => _recognizer?.StopSpeechRecoginition();
	public bool IsListening() => _recognizer != null && _recognizer.isCurrentlyListening();
}
