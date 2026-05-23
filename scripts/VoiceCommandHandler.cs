using Godot;
using System;
using System.Collections.Generic;
using System.Xml;
public partial class VoiceCommandHandler : Node
{
	private SpeechRecognizer speechRecognizer;
	// Link your specific door node here in the Inspector
	[Export] public Node3D targetDoor;
	public override void _Ready()
	{
		// Fetch the AutoLoad directly from the absolute root of the game!
		// "MicInput" must exactly match the Name column in your AutoLoad tab
		MicInput globalMic = GetNodeOrNull<MicInput>("/root/MicInput");

		if (globalMic != null)
		{
			// Assuming your new signal in MicInput.cs is named OnCommandRecognized
			globalMic.OnCommandRecognized += ReactToCommand;
			GD.Print("VoiceCommandHandler: Connected to Global MicInput!");
		}
		else
		{
			GD.PrintErr("VoiceCommandHandler: Could not find the global MicInput AutoLoad!");
		}
	}

	private void ReactToCommand(string actionId)
	{
		if (targetDoor == null) return;
		AnimationPlayer animationPlayer = targetDoor.GetNodeOrNull<AnimationPlayer>("AnimationPlayer");
		if (animationPlayer == null)
		{
			GD.PrintErr("Error, cannot find AnimationPlayer node");
			return;
		}
		if (actionId == "door_open")
		{
			GD.Print("Call animation open door");
			animationPlayer.Play("open");
		}
		else if (actionId == "door_close")
		{
			GD.Print("Call animation close door");
			animationPlayer.Play("close");
		}
	}
}
