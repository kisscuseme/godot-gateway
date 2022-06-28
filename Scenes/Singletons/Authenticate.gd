extends Node

var network = NetworkedMultiplayerENet.new()
var ip = GlobalData.server_info["AUTHENTICATE"]["IP"]
var port = GlobalData.server_info["AUTHENTICATE"]["PORT"]

onready var gateway = get_node("/root/Gateway")

func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().network_peer = network
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect to authentication server")

func _OnConnectionSucceeded():
	print("Successfully connected to authentication server")

func AuthenticatePlayer(username, password, player_id):
	print("sending out authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)

remote func AuthenticationResults(result, player_id, token):
	print("results received and replying to player login request")
	gateway.ReturnLoginRequest(result, player_id, token)

func CreateAccount(username, password, player_id):
	print("sending out create account request")
	rpc_id(1, "CreateAccount", username, password, player_id)

remote func CreateAccountResults(result, player_id, message):
	print("results received and replying to player create account request")
	gateway.ReturnCreateAccountRequest(result, player_id, message)
