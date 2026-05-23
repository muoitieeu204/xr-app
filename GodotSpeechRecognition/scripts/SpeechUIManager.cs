using Godot;
using System;

public partial class SpeechUIManager : Node
{
	public Button startButton;
	public Label partialResultText;
	public Label finalResultText;

	// Point to your AutoLoad
	private MicInput globalMic;

	public override void _Ready()
	{
		startButton = GetNode<Button>("MarginContainer/VBoxContainer/StartListeningButton");
		partialResultText = GetNode<Label>("MarginContainer/VBoxContainer/PartialResult");
		finalResultText = GetNode<Label>("MarginContainer/VBoxContainer/FinalResult");

		globalMic = GetNodeOrNull<MicInput>("/root/MicInput");

		if (startButton == null || globalMic == null)
		{
			GD.PrintErr("CRITICAL: SpeechUIManager missing UI elements or globalMic!");
			return;
		}

		startButton.Pressed += () =>
		{
			if (!globalMic.IsListening())
			{
				partialResultText.Text = "";
				finalResultText.Text = "";
				OnStartSpeechRecognition();
				globalMic.TurnOnMic();
			}
			else
			{
				OnStopSpeechRecognition();
				string finalResult = globalMic.TurnOffMic();
			}
		};

		// Subscribe to the new Pass-Through events from the Brain!
		globalMic.OnRawPartialText += (partialText) =>
		{
			partialResultText.Text = partialText;
		};

		globalMic.OnRawFinalText += (finalText) =>
		{
			finalResultText.Text = finalText;
			OnStopSpeechRecognition();
		};
	}

	private void OnStopSpeechRecognition()
	{
		startButton.Text = "Start Recognition";
		startButton.Modulate = new Color(1, 1, 1, 1f);
	}

	private void OnStartSpeechRecognition()
	{
		startButton.Text = "Stop Recognition";
		startButton.Modulate = new Color(1f, 0.5f, 0.5f, 1f);
	}
}
