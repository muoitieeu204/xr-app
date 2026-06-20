using Godot;
using System;
using System.Collections.Generic;
using System.Xml;
 public partial class VoiceCommandHandler : Node                                                                                                                                                                              
	{                                                                                                                                                                                                                            
		[Export] public Node3D targetDoor;                                                                                                                                                                                          
																																																									
		private Dictionary<string, string> _vocab = new Dictionary<string, string>                                                                                                                                                  
		{                                                                                                                                                                                                                           
			{"mở cửa", "open_door"},                                                                                                                                                                                                    
			{"đóng cửa", "close_door"}                                                                                                                                                                                                  
		};                                                                                                                                                                                                                          
																																																								 
		public override void _Ready()                                                                                                                                                                                               
		{                                                                                                                                                                                                                           
			if (AzureSpeechManager.Instance != null) {                                                                                                                                                                                  
				AzureSpeechManager.Instance.OnSpeechRecognized += HandleSpeech;                                                                                                                                                             
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
																																																								 
		private void HandleSpeech(string rawText)                                                                                                                                                                                   
		{                                                                                                                                                                                                                           
			foreach (var kvp in _vocab)                                                                                                                                                                                                 
			{                                                                                                                                                                                                                           
				if (rawText.ToLower().Contains(kvp.Key))                                                                                                                                                                                    
				{                                                                                                                                                                                                                           
					ExecuteAction(kvp.Value);                                                                                                                                                                                                   
					break;                                                                                                                                                                                                                      
				}                                                                                                                                                                                                                           
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
																																																								 
		private void ExecuteAction(string actionId)                                                                                                                                                                                 
		{                                                                                                                                                                                                                           
			if (targetDoor == null) return;                                                                                                                                                                                             
			AnimationPlayer animPlayer = targetDoor.GetNodeOrNull<AnimationPlayer>("AnimationPlayer");                                                                                                                                  
			if (animPlayer == null) return;                                                                                                                                                                                             
																																																								 
			if (actionId == "open_door") animPlayer.Play("open");                                                                                                                                                                       
			if (actionId == "close_door") animPlayer.Play("close");                                                                                                                                                                     
		}                                                                                                                                                                                                                           
																																																								 
		public override void _ExitTree()                                                                                                                                                                                            
		{                                                                                                                                                                                                                           
			if (AzureSpeechManager.Instance != null) {                                                                                                                                                                                  
				AzureSpeechManager.Instance.OnSpeechRecognized -= HandleSpeech;                                                                                                                                                             
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
	}                              
