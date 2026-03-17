#include <a_samp>
#define GAMEMODE_NAME "Traitor Mode"

#define SKIN_DEFAULT_ID 217

#define SPAWN_X 502.3310
#define SPAWN_Y -70.6820
#define SPAWN_Z 998.7570
#define SPAWN_INTERIOR 11

#define PLAYER_HEALTH 100.0

#define ROL_TRAITOR 1
#define ROL_INOCENT 0
#define MAX_ROL 2

#define MIN_PLAYERS_TO_START 2
#define TIME_START_SECOND 30

#define SECOND 1000
#define MAX_LENGTH 64

#define CICLE_INFINITY true

static const rolMessage[MAX_ROL][] =
{
    "{00FF00}Find and kill the traitor!{FFFFFF} If you kill an innocent you will be penalized.",
    "{FF0000}You are the traitor!{FFFFFF} Your mission is to eliminate all players."
};

new countdown = TIME_START_SECOND;
new timerCountdownId;
new playerRol[MAX_PLAYERS];
new activePlayers = 0;

bool:conditionToStartGame()
{
    if (activePlayers >= MIN_PLAYERS_TO_START) return true;
    SendClientMessageToAll(0xFF0000FF, "Not enough players to start the match.");
    return false;
}

broadcastCountdown()
{
    if (countdown != TIME_START_SECOND) return 0;
    static messageCountdown[MAX_LENGTH];
    format(messageCountdown, sizeof(messageCountdown), "The match starts in %d seconds", countdown);
    SendClientMessageToAll(0xFFFF00FF, messageCountdown);
    return 1;
}

giveRol(playerId, rol)
{
    playerRol[playerId] = rol;
    SendClientMessage(playerId, 0xFFFFFFFF, rolMessage[rol]);
}

giveWeapons(playerId, rol)
{
    if (rol == ROL_TRAITOR) GivePlayerWeapon(playerId, 4, 1);
    GivePlayerWeapon(playerId, 29, 400);
    GivePlayerWeapon(playerId, 23, 400);
    SetPlayerArmedWeapon(playerId, 0);
}

defineRoles()
{
    new traitorId = playerIdRandom();
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        new rol = (playerId == traitorId) ? ROL_TRAITOR : ROL_INOCENT;
        giveRol(playerId, rol);
        giveWeapons(playerId, rol);
    }
}

playerIdRandom()
{
    new players[MAX_PLAYERS];
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        players[playerId] = playerId;
    }
    return players[random(activePlayers)];
}

startToGame()
{
    defineRoles();
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
    countdown = TIME_START_SECOND;
    return 0;
}

public OnGameModeInit()
{
    timerCountdownId = SetTimer("startCountdown", SECOND, CICLE_INFINITY);
    SetGameModeText(GAMEMODE_NAME);
    AddPlayerClass(SKIN_DEFAULT_ID, SPAWN_X, SPAWN_Y, SPAWN_Z, 0.0, 0, 0, 0, 0, 0, 0);
    DisableInteriorEnterExits();
    return 1;
}

public OnPlayerConnect(playerid)
{
    activePlayers++;
    SpawnPlayer(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    activePlayers--;
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid, SPAWN_INTERIOR);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, SPAWN_X, SPAWN_Y, SPAWN_Z);
    SetPlayerHealth(playerid, PLAYER_HEALTH);
    return 1;
}

main() {}
