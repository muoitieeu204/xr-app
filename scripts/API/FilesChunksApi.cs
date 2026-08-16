using Godot;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;

public partial class FilesChunksApi : Node
{
	private static readonly System.Net.Http.HttpClient client = new System.Net.Http.HttpClient();
	private readonly string apiUrl = "https://103-162-30-111.sslip.io/api/files/chunks";
	public async void UploadChunkAsync(int childProfileId, string sessionId, int chunkIndex, string chunkSavePath, bool isFinalChunk, string token)
	{
		try
		{
			client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
			using (var form = new MultipartFormDataContent())
			using (var audioStream = File.OpenRead(ProjectSettings.GlobalizePath(chunkSavePath)))
			{
				form.Add(new StringContent(childProfileId.ToString()), "ChildProfileId");
				form.Add(new StringContent(sessionId.ToString()), "SessionId");
				form.Add(new StringContent(chunkIndex.ToString()), "ChunkIndex");
				form.Add(new StringContent(isFinalChunk.ToString()), "IsFinalChunk");
				var audioContent = new StreamContent(audioStream);
				audioContent.Headers.ContentType = MediaTypeHeaderValue.Parse("audio/wav");
				form.Add(audioContent, "AudioFile", Path.GetFileName(chunkSavePath));
				GD.Print($"Uploading chunk {chunkIndex}...");
				HttpResponseMessage response = await client.PostAsync(apiUrl, form);
				string responseBody = await response.Content.ReadAsStringAsync();

				if (response.IsSuccessStatusCode)
				{
					var jsonNode = Godot.Json.ParseString(responseBody);
					var dict = jsonNode.AsGodotDictionary();

					string status = dict["status"].AsString();
					string responseChunkIndex = dict["chunkIndex"].AsString();
					string voiceUrl = dict["voiceUrl"].AsString();

					GD.Print($"Returned {responseChunkIndex} Updated! Status: {status}| Voice URL: {voiceUrl}");	
				}
				else 
				GD.Print($"Chunk upload failed: {response.StatusCode} - {responseBody}");
			}
		}
		catch(Exception e)
		{
			GD.Print($"Execption during upload {e.Message}");
		}
	}
}
