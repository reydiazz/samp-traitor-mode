#include <a_samp>

#define GAMEMODE_NAME "Traitor Mode | PC & Mobile"

#define SKIN_DEFAULT_ID 217

#define SPAWN_LOBBY_X 161.40
#define SPAWN_LOBBY_Y -94.24
#define SPAWN_LOBBY_Z 1001.80
#define SPAWN_LOBBY_INTERIOR 18

#define PLAYER_HEALTH 100.0

#define ROL_TRAITOR 1
#define ROL_INOCENT 0

#define GAME_STATE_LOBBY  0
#define GAME_STATE_PLAY 1

#define MIN_PLAYERS_TO_START 2
#define TIME_START 30
#define FIVE_SECONDS 5

#define SECOND 1000
#define MAX_LENGTH 64

#define CICLE_INFINITY true
#define CICLE_ONCE false

new countdown = TIME_START;
new timerCountdownId;

countActivePlayers()
{
    new playerActive = 0;
    for (new i = 0; i <= GetPlayerPoolSize(); i++)
    {
        if (IsPlayerConnected(i))
        {
            playerActive++;
        }
    }
    return playerActive;
}

bool:conditionToStartGame()
{
    if (countActivePlayers() < MIN_PLAYERS_TO_START)
    {
        SendClientMessageToAll(0xFF0000FF, "Faltan jugadores para empezar la partida.");
        return false;
    }
    return true;
}

bool:shouldBroadcast()
{
    return countdown == TIME_START || (countdown <= FIVE_SECONDS && countdown < TIME_START);
}

countdownBroadcast()
{
    if (shouldBroadcast())
    {
        static messageCountdown[MAX_LENGTH];
        format(messageCountdown, sizeof(messageCountdown), "La partida inicia en %d segundos", countdown);
        SendClientMessageToAll(0xFFFF00FF, messageCountdown);
    }
    countdown--;
}

forward startCountdown();
public startCountdown()
{
    if (countdown > 0)
    {
        countdownBroadcast();
        return 1;
    }
    if (conditionToStartGame())
    {
        KillTimer(timerCountdownId);
        return 1;
    }
    countdown = TIME_START;
    return 0;
}

public OnGameModeInit()
{
    SetGameModeText(GAMEMODE_NAME);
    AddPlayerClass(SKIN_DEFAULT_ID, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0);
    DisableInteriorEnterExits();
    return 1;
}

public OnPlayerSpawn(playerid)
{
    timerCountdownId = SetTimer("startCountdown", SECOND, CICLE_INFINITY);
    SetPlayerInterior(playerid, SPAWN_LOBBY_INTERIOR);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, SPAWN_LOBBY_X, SPAWN_LOBBY_Y, SPAWN_LOBBY_Z);
    SetPlayerHealth(playerid, PLAYER_HEALTH);
    return 1;
}