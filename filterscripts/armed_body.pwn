#include <a_samp>

static armedbody_pTick[MAX_PLAYERS];

public OnFilterScriptExit()
{
    return true;
}

public OnPlayerUpdate(playerid)
{
    if (GetTickCount() - armedbody_pTick[playerid] > 113)
    {
        new weaponid[13], weaponammo[13], pArmedWeapon;
        pArmedWeapon = GetPlayerWeapon(playerid);

        GetPlayerWeaponData(playerid, 4, weaponid[4], weaponammo[4]);

        if (weaponid[4] && weaponammo[4] > 0)
        {
            if (pArmedWeapon != weaponid[4])
            {
                if (!IsPlayerAttachedObjectSlotUsed(playerid, 0))
                {
                    SetPlayerAttachedObject(
                        playerid,
                        0,
                        GetWeaponModel(weaponid[4]),
                        7,
                        0.000000,
                        -0.100000,
                        -0.080000,
                        -95.000000,
                        -10.000000,
                        0.000000,
                        1.000000,
                        1.000000,
                        1.000000
                    );
                }
            }
            else
            {
                if (IsPlayerAttachedObjectSlotUsed(playerid, 0))
                {
                    RemovePlayerAttachedObject(playerid, 0);
                }
            }
        }
        else if (IsPlayerAttachedObjectSlotUsed(playerid, 0))
        {
            RemovePlayerAttachedObject(playerid, 0);
        }

        armedbody_pTick[playerid] = GetTickCount();
    }
    return true;
}

stock GetWeaponModel(weaponid)
{
    if (weaponid == 28 || weaponid == 29) return weaponid + 324;
    if (weaponid == 32) return 372;
    return 0;
}