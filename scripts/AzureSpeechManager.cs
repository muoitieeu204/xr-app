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

	public async void StartListening(){
		if(string.IsNullOrEmpty(SubscriptionKey) || string.IsNullOrEmpty(Region)){
			GD.PrintErr("AzureSpeechManager: Key or Reigon not found");
			return;
		}
		
		StopListening(); // Stop any ongoing listening just in case
		
		GD.Print("Connecting to Azure Service...");

		await System.Threading.Tasks.Task.Run(async () => {
			var config = SpeechConfig.FromSubscription(SubscriptionKey, Region);
			config.SpeechRecognitionLanguage = Language;
			_currentRecognizer = new SpeechRecognizer(config);
			GD.Print("AzureSpeechManager: Listening... Speak now!");
			try {
				var result = await _currentRecognizer.RecognizeOnceAsync().ConfigureAwait(false);
				CallDeferred(MethodName.ProcessResult, result.Text, (int)result.Reason);
			} catch (ObjectDisposedException) {
				// Safely ignore if we forced it to stop!
			}
		});
	}

	public void StopListening() {
		if (_currentRecognizer != null) {
			_currentRecognizer.Dispose();
			_currentRecognizer = null;
			GD.Print("AzureSpeechManager: Microphone turned off.");
		}
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
	}

    public override void _ExitTree()
    {
		if(Instance == this) Instance = null;
    }

}
