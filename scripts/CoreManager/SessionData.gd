extends Node
#Login & Identity Data
var accessToken: String = ""
var refreshToken: String = ""
var userId: int = 0
var sessionId: String = ""
var fullName: String = ""
var userName: String = ""
var roleName: String = ""
var isActive: bool = true


#Replay storing Path
var target_replay_path: String = ""
var target_audio_path: String = ""
var target_scene_path: String = ""
var target_audio_url: String = ""
var is_spectator: bool = false

func clear():
    accessToken = ""
    refreshToken = ""
    userId = 0
    sessionId = ""
    fullName = ""
    userName = ""
    roleName = ""
    isActive = true
    target_replay_path = ""
    target_audio_path = ""
    target_scene_path = ""
    target_audio_url = ""
