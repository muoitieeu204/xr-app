using Godot;
using System;
using System.Collections.Generic;
using System.Xml;
public partial class VoiceCommandHandler : Node
{
	// Link your specific door node here in the Inspector
	[Export] public Node3D targetDoor;

	private Dictionary<string, string> _vocab = new Dictionary<string, string>
	{
		{"mở cửa", "open_door"},
		{"đóng cửa", "close_door"}
	};

	public override void _Ready()
	{
		if(AzureSpeechManager.Instance == null) GD.PrintErr("VoiceCommandHandler: AzureSpeechManager not found");
		else
		{
			AzureSpeechManager.Instance.OnspeechRecognized += HandleSpeech;
		}
	}
	
	private void HandleSpeech(string rawText){
		// We MUST loop through our dictionary to translate the spoken words ("mở cửa") into the action ID ("open_door")
		foreach (var kvp in _vocab)
		{
			if (rawText.Contains(kvp.Key))
			{
				ExecuteAction(kvp.Value);
				break;
			}
		}
	}

	private void ExecuteAction(string actionId)
	{
		if(targetDoor == null) return;
		AnimationPlayer animPlayer = targetDoor.GetNodeOrNull<AnimationPlayer>("AnimationPlayer");
		if(animPlayer == null) return;
		
		// Notice how it checks for "open_door" to match your dictionary!
		if(actionId == "open_door")
		{
			GD.Print("Open Door");
			animPlayer.Play("open");
		}
		if(actionId == "close_door")
		{
			GD.Print("Close Door");
			animPlayer.Play("close");
		}
	}
}
