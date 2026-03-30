#include <a_samp>

#define GAMEMODE_NAME "Traitor"
#define SKIN_DEFAULT_ID 165
#define PLAYER_HEALTH 100.0
#define ROL_TRAITOR 0
#define ROL_INNOCENT 1
#define MAX_ROLES 2
#define MIN_PLAYERS_TO_START 2
#define TIME_START_SECOND 30
#define SECOND 1000
#define MAX_LENGTH 64
#define CICLE_INFINITY true

enum E_SPAWN
{
    Float:E_X,
    Float:E_Y,
    Float:E_Z,
    Float:E_A,
    E_INTERIOR,
    E_VIRTUALWORLD
}

new Float:gMaps[][E_SPAWN] =
{
    {-2638.8232, 1407.3395, 906.4609,  180.0, 3, 1}, // The Pleasure Domes
    {386.5259,   173.6381,  1008.3828,  90.0, 3, 1}, // Planning Department
    {2233.9363,  1711.8038, 1011.6312, 270.0, 1, 1}, // Caligula's Casino
    {1267.8407,  -776.9587, 1091.9063,  90.0, 5, 1}  // Madd Dogg's Mansion
};

new gActivePlayers = 0;
new gCurrentMap = 0;
new gTimerCountdownId;
new gCountdown = TIME_START_SECOND;
new gPlayerRole[MAX_PLAYERS];
new gRoleCount[MAX_ROLES];
new bool:gPlayerDead[MAX_PLAYERS];
new bool:gGameActive = false;

static const gRoleAssignMessage[MAX_ROLES][] =
{
    "{00FF00}Find and kill the traitor!{FFFFFF} If you kill an innocent you will be penalized.",
    "{FF0000}You are the traitor!{FFFFFF} Your mission is to eliminate all players."
};

static const gRoleLoseMessage[MAX_ROLES][] =
{
    "{FF0000}The innocents have lost!{FFFFFF} The traitor eliminated everyone.",
    "{00FF00}The traitor has lost!{FFFFFF} They found and killed him."
};

setPlayerSpectator(playerid)
{
    TogglePlayerSpectating(playerid, true);
    SetPlayerVirtualWorld(playerid, gMaps[gCurrentMap][E_VIRTUALWORLD]);

    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        if (playerId == playerid) continue;
        if (gPlayerDead[playerId]) continue;
        PlayerSpectatePlayer(playerid, playerId);
        break;
    }
}

removeSpectators()
{
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        TogglePlayerSpectating(playerId, false);
    }
}

resetRoleCount()
{
    gRoleCount[ROL_TRAITOR] = 0;
    gRoleCount[ROL_INNOCENT] = 0;
}

resetCountdown()
{
    gCountdown = TIME_START_SECOND;
}

stopCountdown()
{
    KillTimer(gTimerCountdownId);
    resetCountdown();
}

randomPlayerId()
{
    new connectedPlayers[MAX_PLAYERS];
    new count = 0;
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        connectedPlayers[count++] = playerId;
    }
    return connectedPlayers[random(count)];
}

stock switchMap()
{
    gCurrentMap = (gCurrentMap + 1) % sizeof(gMaps);
}

bool:conditionToStartGame()
{
    if (gActivePlayers >= MIN_PLAYERS_TO_START) return true;
    SendClientMessageToAll(0xFF0000FF, "Not enough players to start the match.");
    return false;
}

announceCountdown()
{
    if (gCountdown != TIME_START_SECOND && gCountdown > 5) return;
    static messageCountdown[MAX_LENGTH];
    format(messageCountdown, sizeof(messageCountdown), "The match starts in %d seconds", gCountdown);
    SendClientMessageToAll(0xFFFF00FF, messageCountdown);
}

giveRoleToPlayer(playerId, role)
{
    gPlayerRole[playerId] = role;
    gRoleCount[role]++;
    SendClientMessage(playerId, 0xFFFFFFFF, gRoleAssignMessage[role]);
}

giveWeaponsToPlayerByRole(playerId, role)
{
    if (role == ROL_TRAITOR) GivePlayerWeapon(playerId, WEAPON_KNIFE, 1);
    GivePlayerWeapon(playerId, WEAPON_MP5, 400);
    GivePlayerWeapon(playerId, WEAPON_SILENCED, 400);
    SetPlayerArmedWeapon(playerId, 0);
}

resetWeaponsToPlayers()
{
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        ResetPlayerWeapons(playerId);
    }
}

respawnPlayers()
{
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        SpawnPlayer(playerId);
    }
}

giveWeapons()
{
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        giveWeaponsToPlayerByRole(playerId, gPlayerRole[playerId]);
    }
}

assignRoles()
{
    new traitorId = randomPlayerId();
    for (new playerId = 0; playerId <= GetPlayerPoolSize(); playerId++)
    {
        if (!IsPlayerConnected(playerId)) continue;
        new role = (playerId == traitorId) ? ROL_TRAITOR : ROL_INNOCENT;
        giveRoleToPlayer(playerId, role);
    }
}

announceRoleLose(role)
{
    new messageLose[MAX_LENGTH];
    format(messageLose, sizeof(messageLose), gRoleLoseMessage[role]);
    SendClientMessageToAll(0xFFFFFFFF, messageLose);
}

bool:isRoleExtinct(playerId)
{
    new role = gPlayerRole[playerId];
    gRoleCount[role]--;
    if (gRoleCount[role] > 0) return false;
    announceRoleLose(role);
    return true;
}

startGame()
{
    gGameActive = true;
    assignRoles();
    giveWeapons();
}

resetGame()
{
    gGameActive = false;
    stopCountdown();
    resetRoleCount();
    resetWeaponsToPlayers();
    removeSpectators();
    switchMap();
    respawnPlayers();
    startCountdown();
}

startCountdown()
{
    gTimerCountdownId = SetTimer("onCountdownTick", SECOND, CICLE_INFINITY);
}

forward onCountdownTick();
public onCountdownTick()
{
    if (gCountdown > 0)
    {
        announceCountdown();
        gCountdown--;
        return;
    }
    if (!conditionToStartGame())
    {
        resetCountdown();
        return;
    }
    stopCountdown();
    startGame();
}

public OnGameModeInit()
{
    switchMap();
    startCountdown();
    SetGameModeText(GAMEMODE_NAME);
    DisableInteriorEnterExits();
    return 1;
}

public OnPlayerConnect(playerid)
{
    gActivePlayers++;
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if (gGameActive && gPlayerDead[playerid])
    {
        setPlayerSpectator(playerid);
        return 1;
    }
    gPlayerDead[playerid] = false;
    SetPlayerSkin(playerid, SKIN_DEFAULT_ID);
    SetPlayerPos(playerid, gMaps[gCurrentMap][E_X], gMaps[gCurrentMap][E_Y], gMaps[gCurrentMap][E_Z]);
    SetPlayerFacingAngle(playerid, gMaps[gCurrentMap][E_A]);
    SetPlayerInterior(playerid, gMaps[gCurrentMap][E_INTERIOR]);
    SetPlayerVirtualWorld(playerid, gMaps[gCurrentMap][E_VIRTUALWORLD]);
    SetPlayerHealth(playerid, PLAYER_HEALTH);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if (gPlayerDead[playerid]) return 1;
    gPlayerDead[playerid] = true;
    setPlayerSpectator(playerid);
    if (!isRoleExtinct(playerid)) return 1;
    resetGame();
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gActivePlayers--;
    if (!gGameActive) return 1;
    if (gPlayerDead[playerid])
    {
        gPlayerDead[playerid] = false;
        return 1;
    }
    if (!isRoleExtinct(playerid)) return 1;
    resetGame();
    return 1;
}

main() {}