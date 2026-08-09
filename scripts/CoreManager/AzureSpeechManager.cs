using Godot;
using Microsoft.CognitiveServices.Speech;
using System;

public partial class AzureSpeechManager : Node
{
	private string SubscriptionKey = "";
	private string Region = "";
	private string Language = "";

	[Signal]
	public delegate void OnSpeechRecognizedEventHandler(string text);
	[Signal]
	public delegate void OnSpeechFailedEventHandler(string reason);

	public static AzureSpeechManager Instance {get; private set;}

	public override void _Ready(){
		Instance = this;
		LoadSettingsFromJSON();
	}

	private void LoadSettingsFromJSON()
	{
		// MUST have res:// at the beginning for Godot to find it!
		string path = "res://Prefabs/PlayerPrefabs/appsettings.json";
		
		if (FileAccess.FileExists(path))
		{
			using var file = FileAccess.Open(path,FileAccess.ModeFlags.Read);
			string content = file.GetAsText();

			var jsonDict = Json.ParseString(content).AsGodotDictionary();
			if (jsonDict.ContainsKey("AzureService"))
			{
				var azureSettings = jsonDict["AzureService"].AsGodotDictionary();
				
				// These must match the exact names inside the AzureService JSON block!
				SubscriptionKey = azureSettings["SubscriptionKey"].AsString();
				Region = azureSettings["Region"].AsString();
				Language = azureSettings["Language"].AsString();
				
				GD.Print("AzureSpeechManager: Successfully loaded keys from appsettings.json");
			}
		}
		else GD.PrintErr($"AzureSpeechManager: Could not find {path}!. Make sure it exists");
	}

	private SpeechRecognizer _currentRecognizer;
	private bool _isListening = false;

	public async void StartListening(){
		if(string.IsNullOrEmpty(SubscriptionKey) || string.IsNullOrEmpty(Region)){
			GD.PrintErr("AzureSpeechManager: Key or Reigon not found");
			return;
		}
		
		_isListening = true;
		
		GD.Print("Connecting to Azure Service...");

		await System.Threading.Tasks.Task.Run(async () => {
			var config = SpeechConfig.FromSubscription(SubscriptionKey, Region);
			config.SpeechRecognitionLanguage = Language;
			
			var recognizer = new SpeechRecognizer(config);
			_currentRecognizer = recognizer;
			
			GD.Print("AzureSpeechManager: Listening... Speak now!");
			try {
				var result = await recognizer.RecognizeOnceAsync().ConfigureAwait(false);
				
				// Only process the result if we haven't dropped the item!
				if (_isListening && _currentRecognizer == recognizer) {
					if (result.Reason == ResultReason.Canceled)
					{
						var cancellation = CancellationDetails.FromResult(result);
						GD.PrintErr($"Azure CANCELED: {cancellation.ErrorCode}| Details: {cancellation.ErrorDetails}");
					}
					CallDeferred(MethodName.ProcessResult, result.Text, (int)result.Reason);
				}
				
				// Safely dispose only AFTER it finishes running
				recognizer.Dispose();
			} catch (Exception e) {
				GD.PrintErr("AzureSpeechManager Error: " + e.Message);
			}
		});
	}

	public void StopListening() {
		_isListening = false;
		_currentRecognizer = null;
		GD.Print("AzureSpeechManager: Microphone turned off (ignoring result).");
	}

	private void ProcessResult(string recognizeText, int reasonCode)
	{
		var reason = (ResultReason)reasonCode;
		if(reason == ResultReason.RecognizedSpeech)
		{
			GD.Print($"AzureSpeechManager: Heard '{recognizeText}'");
			EmitSignal(SignalName.OnSpeechRecognized, recognizeText.ToLower());
		}
		else if(reason == ResultReason.NoMatch)
		{
			GD.Print("AzureSpeechManager: Speech could not be recognized");
			EmitSignal(SignalName.OnSpeechFailed, "No Match");
		}
		else if(reason == ResultReason.Canceled)
		{
			GD.PrintErr("AzureSpeechManager: Speech recognition was canceled. Check your api key");
			EmitSignal(SignalName.OnSpeechFailed, "Canceled");
		}
	}

    public override void _ExitTree()
    {
		if(Instance == this) Instance = null;
    }

}
