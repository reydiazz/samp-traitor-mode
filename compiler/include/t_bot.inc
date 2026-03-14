#define BOT_SPAWN_X 511.3500
#define BOT_SPAWN_Y -72.4587
#define BOT_SPAWN_Z 998.7650
#define BOT_SPAWN_INTERIOR 11

#define BOT_SKIN_DEFAULT_ID 281

#define SCRIPT_NAME "bot_script"

new NPC[5];

#define NAME_BOT_ONE "wz_acv1"
#define NAME_BOT_TWO "wz_acv2"
#define NAME_BOT_THREE "wz_acv3"
#define NAME_BOT_FOUR "wz_acv4"
#define NAME_BOT_FIVE "wz_acv5"

stock SpawnBot()
{
    ConnectNPC(NAME_BOT_ONE, SCRIPT_NAME);
    ConnectNPC(NAME_BOT_TWO, SCRIPT_NAME);
    ConnectNPC(NAME_BOT_THREE, SCRIPT_NAME);
    ConnectNPC(NAME_BOT_FOUR, SCRIPT_NAME);
    ConnectNPC(NAME_BOT_FIVE,  SCRIPT_NAME);
}

stock SetupBot(playerid)
{
    new nombre[24];
    GetPlayerName(playerid, nombre, sizeof(nombre));

    if (!strcmp(nombre, NAME_BOT_ONE))
    {
        NPC[0] = playerid;
        SpawnPlayer(playerid);
    }
    if (!strcmp(nombre, NAME_BOT_TWO))
    {
        NPC[1] = playerid;
        SpawnPlayer(playerid);
    }
    if (!strcmp(nombre, NAME_BOT_THREE))
    {
        NPC[2] = playerid;
        SpawnPlayer(playerid);
    }

    if (!strcmp(nombre, NAME_BOT_FOUR))
    {
        NPC[3] = playerid;
        SpawnPlayer(playerid);
    }
    if (!strcmp(nombre, NAME_BOT_FIVE))
    {
        NPC[4] = playerid;
        SpawnPlayer(playerid);
    }
}

stock PositionBot(playerid)
{
    new nombre[24];
    GetPlayerName(playerid, nombre, sizeof(nombre));

    if (!strcmp(nombre, NAME_BOT_ONE))
    {
        SetPlayerInterior(playerid, BOT_SPAWN_INTERIOR);
        SetPlayerPos(playerid, BOT_SPAWN_X, BOT_SPAWN_Y, BOT_SPAWN_Z);
        SetPlayerFacingAngle(playerid, 90);
        SetPlayerSkin(playerid, BOT_SKIN_DEFAULT_ID);
    }
    if (!strcmp(nombre, NAME_BOT_TWO))
    {
        SetPlayerInterior(playerid, BOT_SPAWN_INTERIOR);
        SetPlayerPos(playerid, BOT_SPAWN_X, BOT_SPAWN_Y - 1.0, BOT_SPAWN_Z);
        SetPlayerFacingAngle(playerid, 90);
        SetPlayerSkin(playerid, BOT_SKIN_DEFAULT_ID);
    }
    if (!strcmp(nombre, NAME_BOT_THREE))
    {
        SetPlayerInterior(playerid, BOT_SPAWN_INTERIOR);
        SetPlayerPos(playerid, BOT_SPAWN_X, BOT_SPAWN_Y - 2.0, BOT_SPAWN_Z);
        SetPlayerFacingAngle(playerid, 90);
        SetPlayerSkin(playerid, BOT_SKIN_DEFAULT_ID);
    }
    if (!strcmp(nombre, NAME_BOT_FOUR))
    {
        SetPlayerInterior(playerid, BOT_SPAWN_INTERIOR);
        SetPlayerPos(playerid, BOT_SPAWN_X, BOT_SPAWN_Y - 3.0, BOT_SPAWN_Z);
        SetPlayerFacingAngle(playerid, 90);
        SetPlayerSkin(playerid, BOT_SKIN_DEFAULT_ID);
    }
    if (!strcmp(nombre, NAME_BOT_FIVE))
    {
        SetPlayerInterior(playerid, BOT_SPAWN_INTERIOR);
        SetPlayerPos(playerid, BOT_SPAWN_X, BOT_SPAWN_Y - 4.0, BOT_SPAWN_Z);
        SetPlayerFacingAngle(playerid, 90);
        SetPlayerSkin(playerid, BOT_SKIN_DEFAULT_ID);
    }
}