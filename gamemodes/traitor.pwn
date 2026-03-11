#include <a_samp>

#define SKIN_ID_DEFAULT 217

#define SPAWN_LOBBY_X 161.40
#define SPAWN_LOBBY_Y -94.24
#define SPAWN_LOBBY_Z 1001.80
#define LOBBY_INTERIOR 18

#define PLAYER_HEALTH 100.0

#define ROL_TRAITOR 1
#define ROL_INOCENT 0

#define PLAYER_ACTIVE 0

#define MIN_PLAYERS 2
#define TIME_START 30

#define SECOND 1000

countActivePlayers()
{
    new playerActive = 0;
    for (new i = 0; i <= GetPlayerPoolSize(); i ++)
    {
        if (IsPlayerConnected(i))
        {
            playerActive++;
        }
    }
    return playerActive;
}

public OnGameModeInit()
{
    SetGameModeText("Traitor Mode");
    AddPlayerClass(SKIN_ID_DEFAULT, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0);
    DisableInteriorEnterExits();
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid, LOBBY_INTERIOR);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, SPAWN_LOBBY_X, SPAWN_LOBBY_Y, SPAWN_LOBBY_Z);
    SetPlayerHealth(playerid, PLAYER_HEALTH);
    return 1;
}

