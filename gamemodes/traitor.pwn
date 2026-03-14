#include <a_samp>
#include <t_bot>

#define GAMEMODE_NAME "Traitor Mode"

#define SKIN_DEFAULT_ID 217

#define SPAWN_X 502.3310
#define SPAWN_Y -70.6820
#define SPAWN_Z 998.7570
#define SPAWN_INTERIOR 11

#define PLAYER_HEALTH 100.0

#define ROL_TRAITOR 1
#define ROL_INOCENT 0

#define MIN_PLAYERS_TO_START 2
#define TIME_START 30
#define FIVE_SECONDS 5

#define SECOND 1000
#define MAX_LENGTH 64

#define CICLE_INFINITY true
#define CICLE_ONCE false

new countdown = TIME_START;
new timerCountdownId;

createNameLabel(playerid)
{
    new name[30];
    GetPlayerName(playerid, name, sizeof(name));
    new Text3D:label = Create3DTextLabel(name, 0xFFFFFFFF, 0.0, 0.0, 0.1, 20.0, 0);
    Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 0.1);
}

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
    return countdown == TIME_START || (countdown <= FIVE_SECONDS && countdown > 0);
}

broadcastCountdown()
{
    if (!shouldBroadcast()) return 0;
    static messageCountdown[MAX_LENGTH];
    format(messageCountdown, sizeof(messageCountdown), "La partida inicia en %d segundos", countdown);
    SendClientMessageToAll(0xFFFF00FF, messageCountdown);
    return 1;
}

forward startCountdown();
public startCountdown()
{
    if (countdown > 0)
    {
        broadcastCountdown();
        countdown--;
        return 1;
    }
    if (conditionToStartGame())
    {
        KillTimer(timerCountdownId);
        startToGame();
        return 1;
    }
    countdown = TIME_START;
    return 0;
}

startToGame()
{
    SendClientMessageToAll(0x00FF00FF, "Partida iniciada");
}

public OnGameModeInit()
{
    timerCountdownId = SetTimer("startCountdown", SECOND, CICLE_INFINITY);
    SetGameModeText(GAMEMODE_NAME);
    AddPlayerClass(SKIN_DEFAULT_ID, SPAWN_X, SPAWN_Y, SPAWN_Z, 0.0, 0, 0, 0, 0, 0, 0);
    SpawnBot();
    DisableInteriorEnterExits();
    return 1;
}

public OnPlayerConnect(playerid)
{
    SetupBot(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid, SPAWN_INTERIOR);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, SPAWN_X, SPAWN_Y, SPAWN_Z);
    SetPlayerHealth(playerid, PLAYER_HEALTH);
    PositionBot(playerid);
    createNameLabel(playerid);
    return 1;
}