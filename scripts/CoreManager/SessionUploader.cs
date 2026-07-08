using Godot;
using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

public partial class SessionUploader : Node
{
	private static readonly System.Net.Http.HttpClient client = new System.Net.Http.HttpClient();
	private readonly string apiUrl = "https://103-162-31-23.sslip.io/api/files";
	// Called when the node enters the scene tree for the first time.
	public async void UploadSessionDataAsync(string jsonPath, string audioPath, string token, int childProfileId)
	{
		string absoluteJsonPath = ProjectSettings.GlobalizePath(jsonPath);
		string absoluteAudioPath = ProjectSettings.GlobalizePath(audioPath);
		try
		{
			// Inject Authorization Bearer Token
			client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
			//Setup FileStream
			using (var form = new MultipartFormDataContent())
			using (var jsonStream = File.OpenRead(absoluteJsonPath))
			using (var audioStream = File.OpenRead(absoluteAudioPath))
			{
				// Attach childId into request body
				var childId = new StringContent(childProfileId.ToString());
				childId.Headers.ContentType = null;
				form.Add(childId, "ChildProfileId");
				//Use FileStream for json
				var jsonContent = new StreamContent(jsonStream);
				jsonContent.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json");
				form.Add(jsonContent, "Metadata", Path.GetFileName(absoluteJsonPath));

				//Use FileStream for audio
				var audioContent = new StreamContent(audioStream);
				audioContent.Headers.ContentType = MediaTypeHeaderValue.Parse("audio/wav");
				form.Add(audioContent, "Audio", Path.GetFileName(absoluteAudioPath));

				GD.Print("Starting upload to server...");
				HttpResponseMessage response = await client.PostAsync(apiUrl, form);
				string responseBody = await response.Content.ReadAsStringAsync();
				if (response.IsSuccessStatusCode)
				{
					var jsonNode = Godot.Json.ParseString(responseBody);
					string folderId = jsonNode.AsGodotDictionary()["folderId"].AsString();
					GD.Print($"Upload session replay successful! Server return folderId: {folderId} ");
				}
				else GD.Print($"Upload session failed! Server response with: {response.StatusCode}, message: {response.ReasonPhrase}");
			}

		}
		catch (Exception e)
		{
			GD.Print($"Exception during upload {e.Message}");
		}
	}
}
