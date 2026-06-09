using Godot;
using System;
using System.Collections.Generic;

public partial class MicInput : Node
{
	// 1. We change this from SpeechRecognizer to a generic Node so it can hold the GDScript Whisper node
	[Export] public Node _whisperNode;

	public static MicInput Instance { get; private set; }

	[Signal]
	public delegate void OnCommandRecognizedEventHandler(string actionId);

	public event Action<string> OnRawPartialText;
	public event Action<string> OnRawFinalText;

	private Dictionary<string, string> _vocabulary = new Dictionary<string, string>
	{
		{ "mở cửa", "door_open" },
		{ "đóng cửa", "door_close" },
		{ "bắt đầu", "tutorial_start" }
	};

	public override void _Ready()
	{
		Instance = this;

		if (_whisperNode != null)
		{
			// Automatically connect the Whisper signal via code so you don't have to use the Editor!
			_whisperNode.Connect("transcribed_msg", new Callable(this, MethodName._on_whisper_transcribed_msg));
			GD.Print("SpeechBrain (Whisper): Online and listening.");
		}
		else
		{
			GD.PrintErr("SpeechBrain: Critical Failure. Whisper Node is null. Did you assign it in the Inspector?");
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

	public void TurnOnMic() 
	{
		if (_whisperNode != null) _whisperNode.Set("recording", true);
	}

	public string TurnOffMic() 
	{
		if (_whisperNode != null) _whisperNode.Set("recording", false);
		return "";
	}

	public bool IsListening() 
	{
		if (_whisperNode != null) return (bool)_whisperNode.Get("recording");
		return false;
	}

	public void _on_whisper_transcribed_msg(bool isComplete, string newText)
	{
		// Still check for our keywords like "mở cửa"!
		ProcessRawSpeech(newText);

		if (isComplete)
		{
			// This is a final result! Send it to your UI.
			OnRawFinalText?.Invoke(newText);
		}
		else
		{
			// This is a partial, live-updating result! Send it to your UI.
			OnRawPartialText?.Invoke(newText);
		}
	}
}
