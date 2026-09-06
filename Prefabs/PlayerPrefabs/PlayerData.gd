extends Node

# Active Child Profile Data
var childId: int = 0
var parentUserId: int = 0
var fullName: String = ""
var age: int = 0
var gender: String = ""
var learningLevel: String = ""
var childType: String = "" # Change back to "" after debug
var status: String = ""

func clear():
	childId = 0
	parentUserId = 0
	fullName = ""
	age = 0
	gender = ""
	learningLevel = ""
	childType = ""
	status = ""
