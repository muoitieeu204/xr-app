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
	public async void UploadSessionDataAsync(string jsonPath, string audioPath)
	{
		string absoluteJsonPath = ProjectSettings.GlobalizePath(jsonPath);
		string absoluteAudioPath = ProjectSettings.GlobalizePath(audioPath);
		try
		{

			//Setup FileStream
			using (var form = new MultipartFormDataContent())
			using (var jsonStream = File.OpenRead(absoluteJsonPath))
			using (var audioStream = File.OpenRead(absoluteAudioPath))
			{
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
				if (response.IsSuccessStatusCode)
				{
					string responseBody = await response.Content.ReadAsStringAsync();
					GD.Print($"Upload successful! Status: {responseBody} ");
				}
				else GD.Print($"Upload failed! Server response with: {response.StatusCode}, message: {response.ReasonPhrase}");
			}

		}
		catch (Exception e)
		{
			GD.Print($"Exception during upload {e.Message}");
		}
	}
}
