#include                    <a_samp>
#include                    <y_ini>
#include                    <sscanf2>
#include                    <zcmd>
#include                    <foreach>
#include                    <streamer>

#pragma                     tabsize                         (0)

#undef                      MAX_PLAYERS
//#define                     DEBUG						
#define                     SCRIPT_VERSION                  "1.3"
#define                     MAX_PLAYERS                     (50)
#define                     MAX_HOUSES                      (500)
#define                     MAX_BUILDINGS                   (500)
#define                     MAX_FACTIONS                    (15)
#define                     maxobj                          (500)
#define                     COLOR_FADE1                     0xE6E6E6FF
#define                     COLOR_OOC                       0xB1C8FBAA
#define                     COLOR_GRAD1                     0xB4B5B7FF
#define                     COLOR_GRAD2                     0xBFC0C2FF
#define                     COLOR_GRAD3                     0xCBCCCEFF
#define                     COLOR_GRAD4                     0xD8D8D8FF
#define                     COLOR_GRAD5                     0xE3E3E3FF
#define                     COLOR_GRAD6                     0xF0F0F0FF
#define                     COLOR_GREY                      0xAFAFAFFF
#define                     COLOR_GREEN                     0x9EC73DFF
#define                     COLOR_RED                       0xAA3333FF
#define                     COLOR_LIGHTRED                  0xFF6347FF
#define                     COLOR_LIGHTBLUE                 0x33CCFFFF
#define                     COLOR_LIGHTGREEN                0x9ACD32FF
#define                     COLOR_YELLOW                    0xDABB3EFF
#define                     COLOR_WHITE                     0xFFFFFFFF
#define                     COLOR_PURPLE                    0xC2A2DAFF
#define                     COLOR_DBLUE                     0x2641FEFF
#define                     COLOR_ALLDEPT                   0xFF8282FF
#define                     COLOR_BLUE                      0x2641FEFF
#define                     COLOR_DARKNICERED               0x9D000096
#define                     COLOR_ORANGE                    0xFF9900FF
#define                     COLOR_MAGENTA                   0xFF00FFFF
#define                     COLOR_NAVY                      0x000080FF
#define                     COLOR_AQUA                      0xF0F8FFFF
#define                     COLOR_CRIMSON                   0xDC143CFF
#define                     COLOR_FLBLUE                    0x6495EDFF
#define                     COLOR_BISQUE                    0xFFE4C4FF
#define                     COLOR_BLACK2                    0x000000FF
#define                     COLOR_CHARTREUSE                0x7FFF00FF
#define                     COLOR_BROWN                     0xA52A2AFF
#define                     COLOR_CORAL                     0xFF7F50FF
#define                     COLOR_GOLD                      0xB8860BFF
#define                     COLOR_GREENYELLOW               0xADFF2FFF
#define                     COLOR_INDIGO                    0x4B00B0FF
#define                     COLOR_IVORY                     0xFFFF82FF
#define                     COLOR_LAWNGREEN                 0x7CFC00FF
#define                     COLOR_SYSTEMGREEN               0x32CD32FF
#define                     COLOR_MIDNIGHTBLUE              0x191970FF
#define                     COLOR_MAROON                    0x800000FF
#define                     COLOR_OLIVE                     0x808000FF
#define                     COLOR_ORANGERED                 0xFF4500FF
#define                     COLOR_PINK                      0xFFC0CBFF
#define                     COLOR_SPRINGGREEN               0x00FF7FFF
#define                     COLOR_TOMATO                    0xFF6347FF
#define                     COLOR_YELLOWGREEN               0x9ACD32FF
#define                     COLOR_MEDIUMAQUA                0x83BFBFFF
#define                     COLOR_MEDIUMMAGENTA             0x8B008BFF
#define                     COLOR_BRIGHTRED                 0xDC143CFF
#define                     COLOR_SYSTEM                    0xA9C4E4FF
#define                     COLOR_WARNING                   COLOR_YELLOW
#define                     COLOR_ERROR                     COLOR_BRIGHTRED
#define                     COLOR_SAMP                      0xA9C4E4FF
#define                     COLOR_FAMILY                    0x7BDDA5FF
#define                     DIALOG_LOGIN                    (0)
#define                     DIALOG_CREATION                 (1)
#define                     DIALOG_PLAYERDESCRIPTION        (14)
#define                     DIALOG_X                        (21)

//==============================[FORWARD FUNCTIONS]=============================

forward CheckForWalkingTeleport(playerid);
forward OnPlayerLoginEx(playerid, name[], value[]);
forward OnPlayerUpdateEx(playerid);
forward OnPlayerRegister(playerid, pass[]);
forward GlobalPlayerLoop();
forward GameModeExitFunc();

//==============================[GLOBAL VARIABLES]==============================

new Float:ObjCoords[maxobj][3];
new object[maxobj];
new Dropped[maxobj];
new ObjectID[maxobj][3];
new _string[128];
new _largestring[1280];
new _playername[24];
new _otherplayername[24];
new GMXSet;
new ghour, gmin, gsec;
new gOOC;
new gametime;
new timeshift = -1;
new shifthour;
//new Text3D:CarDescription[MAX_VEHICLES];
//new Text3D:CarMusic[MAX_VEHICLES];
new Text3D:PlayerDescription[MAX_PLAYERS];
new Text3D:BuildingLabel[MAX_BUILDINGS];
new BuildingPickUp[MAX_BUILDINGS];
new CreatedCar[MAX_VEHICLES];

new GunNames[48][] = {
	"Nada",
	"Soco Ingl�s",
	"Taco de Golfe",
	"Cacetete",
	"Faca",
	"Taco de Baseball",
	"P�",
	"Taco de Sinuca",
	"Espada",
	"Serra El�trica",
	"Consolo Rosa",
	"Consolo Pequeno Branco",
	"Consolo Longo Branco",
	"Vibrador",
	"Flores",
	"Bengala",
	"Granada",
	"Granada de G�s",
	"Coquetel Molotov",
	"M�ssil Ve�cular",
	"Flare de Hydra",
	"Mochila a Jato",
	"Pistola",
	"Pistola com Silenciador",
	"Pistola de Alto Calibre",
	"Espingarda",
	"Espingarda de Cano Serrado",
	"Espingarda Autom�tica",
	"Sub-Metralhadora (UZI)",
	"Sub-Metralhadora (MP5)",
	"Fuzil (AK-47)",
	"Fuzil (M4)",
	"Sub-Metralhadora (TEC-9)",
	"Carabina",
	"Rifle com Mira",
	"Lan�a-Foguetes",
	"Lan�a-Foguetes Teleguiado",
	"Lan�a-Chamas",
	"Metralhadora",
	"Explosivo",
	"Detonador",
	"Lata de Spray",
	"Extintor",
	"C�mera",
	"�culos de Vis�o Noturna",
	"�culos de Vis�o Infravermelha",
	"Paraquedas",
	"Pistola Falsa"
};

new GunObjects[47][0] = { // (c) gimini
	{0},// Emty // 0
	{331},// Brass Knuckles
	{333},// Golf Club
	{334},// Nitestick
	{335},// Knife
	{336},// Baseball Bat
	{337},// Showel
	{338},// Pool Cue
	{339},// Katana
	{341},// Chainsaw
	{321},// Purple Dildo
	{322},// Small White Dildo
	{323},// Long White Dildo
	{324},// Vibrator
	{325},// Flowers
	{326},// Cane
	{342},// Grenade
	{343},// Tear Gas
	{344},// Molotov
	{0},
	{0},
	{0},
	{346},// Glock
	{347},// Silenced Colt
	{348},// Desert Eagle
	{349},// Shotgun
	{350},// Sawn Off
	{351},// Combat Shotgun
	{352},// Micro UZI
	{353},// MP5
	{355},// AK47
	{356},// M4
	{372},// Tec9
	{357},// Rifle
	{358},// Sniper Rifle
	{359},// Rocket Launcher
	{360},// HS Rocket Launcher
	{361},// Flamethrower
	{362},// Minigun
	{363},// Detonator
	{364},// Detonator Button
	{365},// Spraycan
	{366},// Fire Extinguisher
	{367},// Camera
	{368},// Nightvision
	{368},// Infrared Vision
	{371}// Parachute
};

//====================================[ENUMS]===================================

enum fInfo
{
	fType,
	fName[24],
	fLeader[24],
	fMembers,
	Float:fHQEntrnance[3],
	Float:fHQExit[3],
	fInterior,
    fRank1[24],
    fRank2[24],
    fRank3[24],
    fRank4[24],
    fRank5[24],
    fRank6[24],
    fRank7[24],
    fRank8[24],
    fRank9[24],
    fRank10[24],
    fRank11[24],
    fRank12[24],
    fRank13[24],
    fRank14[24],
    fRank15[24]
};
new FactionInfo[MAX_FACTIONS][fInfo];

enum pInfo
{
    pRealName[32],
    pHeight,
    pWeight,
    pTatoo[128],
    pSkinColor,
    pHairColor,
    pEyeColor,
    pBeard,
    pCharDescription[128],
    pBody,
    pHairStyle,
    pBeardStyle,
    pKey[24],
	pLevel,
	pAdmin,
	pYearsOn,
    pMonthsOn,
    pDaysOn,
    pHoursOn,
    pMinutesOn,
    pSecondsOn,
	pReg,
	pSex,
	pAge,
    pPISTOL,
    pPISTOL_SILENCED,
    pDESERT_EAGLE,
    pSHOTGUN,
    pSAWNOFF_SHOTGUN,
    pSPAS12_SHOTGUN,
    pMICRO_UZI,
    pMP5,
    pAK47,
    pM4,
    pSNIPERRIFLE,
	pOrigin[64],
	pCK,
	pExp,
	pKills,
	pDeaths,
	pRadioFreq,
	pRank,
	Float:pHealth,
	Float:pArmor,
    Float:pPos[3],
    pInt,
	pFaction,
	pGun1,
	pGun2,
	pGun3,
	pAmmo1,
	pAmmo2,
	pAmmo3,
	pTut,
	pRadioAlias[MAX_PLAYER_NAME],
    pOfficialAlias[MAX_PLAYER_NAME],
    pWarns,
	pVirWorld,
	pFuel,
    pSkin,
    pSotaque
};
new PlayerInfo[MAX_PLAYERS][pInfo];

enum bInfo
{
	Float:bEntrancex,
	Float:bEntrancey,
	Float:bEntrancez,
	Float:bExitx,
	Float:bExity,
	Float:bExitz,
    bName[24],
    Text3D:bText,
    bLock,
    bVW,
    bInterior
};

new BuildingInfo[MAX_BUILDINGS][bInfo];


enum cInfo
{
	cModel,
	Float:cLocationx,
	Float:cLocationy,
	Float:cLocationz,
	Float:cAngle,
	cColorOne,
	cColorTwo,
    cFaction,
    cLock,
    cInt,
    cVW
};

new CarInfo[MAX_VEHICLES][cInfo];



main()
{
    print("||       GM B�sico de RP      ||");
    printf("||Vers�o do Gamemode:  %s||", SCRIPT_VERSION);
    print("||        Programado por: LeLeTe        ||");
}

//===============================[MISC FUNCTIONS]===============================

stock CheckPlayerDistanceToVehicle(Float:radi, playerid, vehicleid)
{
	if(IsPlayerConnected(playerid))
	{
	    new Float:PX,Float:PY,Float:PZ,Float:X,Float:Y,Float:Z;
	    GetPlayerPos(playerid,PX,PY,PZ);
	    GetVehiclePos(vehicleid, X,Y,Z);
	    new Float:Distance = (X-PX)*(X-PX)+(Y-PY)*(Y-PY)+(Z-PZ)*(Z-PZ);
	    if(Distance <= radi*radi)
	    {
	        return 1;
	    }
	}
	return 0;
}



forward Descongelar(playerid);
public Descongelar(playerid)
{
    TogglePlayerControllable(playerid, 1);
    DeletePVar(playerid, "Frozen");
}

public GameModeExitFunc()
{
	GameModeExit();
}

stock GetPlayerRank(playerid)
{
    switch (PlayerInfo[playerid][pRank])
    {
        case 1: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank1];
        case 2: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank2];
        case 3: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank3];
        case 4: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank4];
        case 5: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank5];
        case 6: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank6];
        case 7: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank7];
        case 8: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank8];
        case 9: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank9];
        case 10: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank10];
        case 11: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank11];
        case 12: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank12];
        case 13: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank13];
        case 14: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank14];
        case 15: return FactionInfo[PlayerInfo[playerid][pFaction]][fRank15];
        default: return 0;
    }
    return 1;
}

stock SafeResetPlayerWeapons(plyid)
{
	ResetPlayerWeapons(plyid);
    return 1;
}

stock GivePlayerWeaponEx(playerid,weaponid,ammo)
{
    new gun1, gun2, gun3;
    gun1 = PlayerInfo[playerid][pGun1];
    gun2 = PlayerInfo[playerid][pGun2];
    gun3 = PlayerInfo[playerid][pGun3];
    if(gun1 > 0 && gun1 != weaponid)
    {
        if(PlayerInfo[playerid][pGun2] > 0 && gun2 != weaponid)
        {
            if(PlayerInfo[playerid][pGun3] > 0 && gun3 != weaponid) return 0;
            else
            {
                PlayerInfo[playerid][pGun3] = weaponid;
                PlayerInfo[playerid][pAmmo3] += ammo;
            }
        }
        else
        {
            PlayerInfo[playerid][pGun2] = weaponid;
            PlayerInfo[playerid][pAmmo2] += ammo;
        }
    }
    else
    {
        PlayerInfo[playerid][pGun1] = weaponid;
        PlayerInfo[playerid][pAmmo1] += ammo;
    }
    return GivePlayerWeapon(playerid,weaponid,ammo);
}

stock RemovePlayerWeapon(playerid, weaponid)
{
    new plyWeapons[12] = 0;
	new plyAmmo[12] = 0;
	for(new slot = 0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);

		if(wep != weaponid && ammo != 0)
		{
			GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
		}
	}
	SafeResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
	    if(plyAmmo[slot] != 0)
	    {
			GivePlayerWeaponEx(playerid, plyWeapons[slot], plyAmmo[slot]);
		}
	}
	if(weaponid != PlayerInfo[playerid][pGun1])
    {
        if(weaponid != PlayerInfo[playerid][pGun2])
        {
            if(weaponid != PlayerInfo[playerid][pGun3]) return 0;
            else
            {
                PlayerInfo[playerid][pGun1] = 0;
                PlayerInfo[playerid][pAmmo1] = 0;
            }
        }
        else
        {
            PlayerInfo[playerid][pGun1] = 0;
            PlayerInfo[playerid][pAmmo1] = 0;
        }
    }
    else
    {
        PlayerInfo[playerid][pGun1] = 0;
        PlayerInfo[playerid][pAmmo1] = 0;
    }
    return 1;
}

stock IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock IsPlayerInRangeOfPlayer(playerid, playerid2, Float: radius) {

	new
		Float:Floats[3];

	GetPlayerPos(playerid2, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock IsVehicleInRangeOfPoint(vehicleid, Float: radius, Float:x, Float:y, Float:z) {

	new
		Float:Floats[6];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	Floats[3] = (Floats[0] -x);
	Floats[4] = (Floats[1] -y);
	Floats[5] = (Floats[2] -z);
	if (((Floats[3] < radius) && (Floats[3] > -radius)) && ((Floats[4] < radius) && (Floats[4] > -radius)) && ((Floats[5] < radius) && (Floats[5] > -radius)))
		return 1;
	return 0;
}

stock nearByMessage(playerid, color, string[], Float: Distance = 12.0) {
	new
	    Float: nbCoords[3];

	GetPlayerPos(playerid, nbCoords[0], nbCoords[1], nbCoords[2]);

	foreach(Player, i)
    {
	    if(IsPlayerInRangeOfPoint(i, Distance, nbCoords[0], nbCoords[1], nbCoords[2]) && (GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)))
        {
            new stringfull[192];
            new lengths[96];
            new length2[96];
            strmid(stringfull, string, 0, 192);
            strmid(lengths, stringfull, 0, 96);
            strmid(length2, string, 95, 192);
            if(strlen(string) > 96)
            {
                new message[128];
                format(message, 128, "%s ...", lengths);
                SendClientMessage(playerid, color, message);
                format(message, 128, "... %s", length2);
                SendClientMessage(playerid, color, message);
            }
            else
            {
                new message[128];
                format(message, 128, "%s", string);
                SendClientMessage(playerid, color, message);
            }
        }
	}

	return 1;
}

stock ReturnPlayerNameEx( playerid )
{
	new
	NameString[ MAX_PLAYER_NAME ],
	stringPos;
	GetPlayerName( playerid, NameString, MAX_PLAYER_NAME );
    stringPos = strfind( NameString, "_" );
	NameString[ stringPos ] = ' ';
	return NameString;
}

stock ReturnFullName( playerid )
{
	new
	NameString[ MAX_PLAYER_NAME ];
	GetPlayerName( playerid, NameString, MAX_PLAYER_NAME );
	return NameString;
}

new stock VehicleNames[213][] = {
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer", //artict1
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer", //artict2
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "Berkley's RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR3 50",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "Police Maverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring Racer", //hotrina
   "Hotring Racer", //hotrinb
   "Bloodring Banger",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker", //petro
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement Truck",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck", //firela
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster", //monstera
   "Monster", //monsterb
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight", //freiflat
   "Trailer", //streakc
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer", //petrotr
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer", //freibox
   "Trailer", //artict3
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car (LSPD)",
   "Police Car (SFPD)",
   "Police Car (LVPD)",
   "Police Ranger",
   "Picador",
   "S.W.A.T. Van",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer", //bagboxa
   "Luggage Trailer", //bagboxb
   "Stair Trailer", //tugstair
   "Boxville",
   "Farm Plow", //farmtr1
   "Utility Trailer", //utiltr1
   "Invalid Vehicle" //just to return if the modelid is invalid
};

stock ReturnVehicleID(vName[])
{
    for(new x; x != 211; x++) if(strfind(VehicleNames[x], vName, true) != -1) return x + 400;
    return INVALID_VEHICLE_ID;
}

stock ReturnVehicleNameID(vehicleid)
{
	new modelid;
	modelid=GetVehicleModel(vehicleid);
	return VehicleNames[(modelid-400)];
}

stock ReturnVehicleNameModel(modelid)
{
	if(400<modelid || modelid>611)
	{
		modelid=612;
	}
	return VehicleNames[(modelid-400)];
}

stock IsABoat(carid)
{
	if(GetVehicleModel(carid) == 472 || GetVehicleModel(carid) == 473 || GetVehicleModel(carid) == 593 || GetVehicleModel(carid) == 595 || GetVehicleModel(carid) == 484 || GetVehicleModel(carid) == 430 || GetVehicleModel(carid) == 453 || GetVehicleModel(carid) == 452 || GetVehicleModel(carid) == 446 || GetVehicleModel(carid) == 454)	return 1;
	return 0;
}

stock IsAHeli(carid)
{
	if( GetVehicleModel(carid) == 548 || GetVehicleModel(carid) == 425 || GetVehicleModel(carid) == 417 || GetVehicleModel(carid) == 487 || GetVehicleModel(carid) == 488 || GetVehicleModel(carid) == 497 || GetVehicleModel(carid) == 563 || GetVehicleModel(carid) == 447 || GetVehicleModel(carid) == 469) return 1;
	return 0;
}

stock IsABike(carid)
{
   if(GetVehicleModel(carid) == 509 || GetVehicleModel(carid) == 481 || GetVehicleModel(carid) == 510 || GetVehicleModel(carid) == 462 || GetVehicleModel(carid) == 448 || GetVehicleModel(carid) == 581 || GetVehicleModel(carid) == 522 || GetVehicleModel(carid) == 461 || GetVehicleModel(carid) == 521 || GetVehicleModel(carid) == 523 || GetVehicleModel(carid) == 463 || GetVehicleModel(carid) == 586 || GetVehicleModel(carid) == 468 || GetVehicleModel(carid) == 471)   return 1;
	return 0;
}

stock IsAPlane(carid)
{
	if(GetVehicleModel(carid) == 592 || GetVehicleModel(carid) == 593 || GetVehicleModel(carid) == 511 || GetVehicleModel(carid) == 512 || GetVehicleModel(carid) == 577 || GetVehicleModel(carid) == 593 || GetVehicleModel(carid) == 520 || GetVehicleModel(carid) == 553 || GetVehicleModel(carid) == 476 || GetVehicleModel(carid) == 519 || GetVehicleModel(carid) == 460 || GetVehicleModel(carid) == 513)		return 1;
	return 0;
}

stock INI_Exist(nickname)
{
    new str[40], _xstring[24];
    GetPlayerName(nickname, _xstring, 24);
    format(str,sizeof(str),"Contas/%s.ini", _xstring);
    return fexist(str);
}

stock ReturnWeaponName(weaponid)
{
    return GunNames[weaponid];
}

stock SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	    if(PlayerInfo[playerid][pTut] == 0)
	    {
            SetPlayerPos(playerid, -133.2492,1124.9255,20.9518);
            SetPlayerCameraPos(playerid, -136.1206,1124.8572,27.1411);
        	SetPlayerCameraLookAt(playerid, -144.9004,1124.2347,21.4658);
			TogglePlayerControllable(playerid, 0);
            ShowPlayerDialog(playerid, DIALOG_CREATION, DIALOG_STYLE_MSGBOX, "Cria��o de Personagens || {FF0000}Sexo", "Selecione se seu personagem ser� Masculino ou Feminino.", "Masculino", "Feminino");
            return 1;
	    }
	    if(PlayerInfo[playerid][pAdmin] >= 1)
        {
            SetPVarInt(playerid, "ReadAdminWarning", 1);
            SetPVarInt(playerid, "ReadAdminChat", 1);
            SetPVarInt(playerid, "ReadSystemWarning", 1);
        }
        SetSpawnInfo(playerid, PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2], 1.0, -1, -1, -1, -1, -1, -1);
        SetPlayerFacingAngle(playerid, 0);
        SetPlayerInterior(playerid,0);
        PlayerInfo[playerid][pInt] = 0;
	}
	return 1;
}

//================================[LOG FUNCTIONS]===============================

stock CKLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/CK.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock DebugLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Debug.log", io_append);
	fwrite(hFile, _largestring);
    print(_largestring);
    fclose(hFile);
}

stock PayLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Pay.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock KickLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Kick.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock BanLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Ban.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock AdminLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Admin.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock SystemLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Sistema.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock OOCLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/OOC.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock LoginLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Login.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock TeamLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Team.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock WalkieLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Walkie.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock RadioLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Radio.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock FactionLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Family.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

stock CommandLog(string[])
{
    new Year, Month, Day, Hour, Minute, Second;
    getdate(Year, Month, Day);
    gettime(Hour, Minute, Second);
    format(_largestring, sizeof(_largestring), "[%02d/%02d/%02d]-[%02d:%02d:%02d]: %s\r\n",Day, Month, Year, Hour, Minute, Second, string);
	new File:hFile;
	hFile = fopen("Logs/Comandos.log", io_append);
	fwrite(hFile, _largestring);
	fclose(hFile);
}

//==============================[LOADING FUNCTIONS]=============================

stock LoadWeapons()
{
	new File: file = fopen("weapons.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(ObjCoords))
		{
			fread(file, _largestring);
            sscanf(_largestring,"p<,>dddfff",
			ObjectID[idx][0],
			ObjectID[idx][1],
			ObjectID[idx][2],
			ObjCoords[idx][0],
			ObjCoords[idx][1],
			ObjCoords[idx][2]);
	        idx++;
		}
		fclose(file);
	}
    return 1;
}

stock LoadFactions()
{
    for(new i = 0; i < sizeof(FactionInfo); i++)
    {
        new b[32];
        format(b, sizeof (b), "Times/Time %d.ini", i);
        INI_ParseFile(b, "LoadFaction", false, true, i);
    }
    return 1;
}

forward LoadFactionEx(idx, name[], value[]);
public LoadFactionEx(idx, name[], value[])
{
    if(!strcmp(name, "Type")) FactionInfo[idx][fType] = strval(value);
    if(!strcmp(name, "Name"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fName] = cameo;
    }
    if(!strcmp(name, "Leader"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fLeader] = cameo;
    }
    if(!strcmp(name, "Members")) FactionInfo[idx][fInterior]= strval(value);
    if(!strcmp(name, "Interior")) FactionInfo[idx][fMembers]= strval(value);
    if(!strcmp(name, "HQEN_X")) FactionInfo[idx][fHQEntrnance][0]= floatstr(value);
    if(!strcmp(name, "HQEN_Y")) FactionInfo[idx][fHQEntrnance][1]= floatstr(value);
    if(!strcmp(name, "HQEN_Z")) FactionInfo[idx][fHQEntrnance][2]= floatstr(value);
    if(!strcmp(name, "HQEX_X")) FactionInfo[idx][fHQExit][0]= floatstr(value);
    if(!strcmp(name, "HQEX_Y")) FactionInfo[idx][fHQExit][1]= floatstr(value);
    if(!strcmp(name, "HQEX_Z")) FactionInfo[idx][fHQExit][2]= floatstr(value);
    if(!strcmp(name, "Rank1"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank1] = cameo;
    }
    if(!strcmp(name, "Rank2"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank2] = cameo;
    }
    if(!strcmp(name, "Rank3"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank3] = cameo;
    }
    if(!strcmp(name, "Rank4"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank4] = cameo;
    }
    if(!strcmp(name, "Rank5"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank5] = cameo;
    }
    if(!strcmp(name, "Rank6"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank6] = cameo;
    }
    if(!strcmp(name, "Rank7"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank7] = cameo;
    }
    if(!strcmp(name, "Rank8"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank8] = cameo;
    }
    if(!strcmp(name, "Rank9"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank9] = cameo;
    }
    if(!strcmp(name, "Rank10"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank10] = cameo;
    }
    if(!strcmp(name, "Rank11"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank11] = cameo;
    }
    if(!strcmp(name, "Rank12"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank12] = cameo;
    }
    if(!strcmp(name, "Rank13"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank13] = cameo;
    }
    if(!strcmp(name, "Rank14"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank14] = cameo;
    }
    if(!strcmp(name, "Rank15"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        FactionInfo[idx][fRank15] = cameo;
    }
    return 1;
}

stock LoadCar()
{
    for(new i = 0; i < sizeof(CarInfo); i++)
    {
        new b[32];
        format(b, sizeof (b), "Carros/Veiculo %d.ini", i);
        INI_ParseFile(b, "LoadCarEx", false, true, i);
    }
    return 1;
}

forward LoadCarEx(idx, name[], value[]);
public LoadCarEx(idx, name[], value[])
{
    if(!strcmp(name, "Modelo")) CarInfo[idx][cModel] = strval(value);
    if(!strcmp(name, "Pos_X")) CarInfo[idx][cLocationx]= floatstr(value);
    if(!strcmp(name, "Pos_Y")) CarInfo[idx][cLocationy]= floatstr(value);
    if(!strcmp(name, "Pos_Z")) CarInfo[idx][cLocationz]= floatstr(value);
    if(!strcmp(name, "Angulo")) CarInfo[idx][cAngle]= floatstr(value);
    if(!strcmp(name, "Cor_1")) CarInfo[idx][cColorOne]= strval(value);
    if(!strcmp(name, "Cor_2")) CarInfo[idx][cColorTwo]= strval(value);
    if(!strcmp(name, "Faction")) CarInfo[idx][cFaction]= strval(value);
    if(!strcmp(name, "Lock")) CarInfo[idx][cLock]= strval(value);
    if(!strcmp(name, "Int")) CarInfo[idx][cInt]= strval(value);
    if(!strcmp(name, "VW")) CarInfo[idx][cVW]= strval(value);
}

forward LoadBuildings();
public LoadBuildings()
{
    for(new i = 0; i < sizeof(BuildingInfo); i++)
    {
        new b[32];
        format(b, sizeof (b), "Interiores/Interior %d.ini", i);
        INI_ParseFile(b, "LoadBuildingEx", false, true, i);
    }
    return 1;
}

forward LoadBuildingEx(idx, name[], value[]);
public LoadBuildingEx(idx, name[], value[])
{
    if(!strcmp(name, "Entrada_X")) BuildingInfo[idx][bEntrancex] = floatstr(value);
	if(!strcmp(name, "Entrada_Y")) BuildingInfo[idx][bEntrancey] = floatstr(value);
	if(!strcmp(name, "Entrada_Z")) BuildingInfo[idx][bEntrancez] = floatstr(value);
	if(!strcmp(name, "Saida_X")) BuildingInfo[idx][bExitx] = floatstr(value);
	if(!strcmp(name, "Saida_Y")) BuildingInfo[idx][bExity] = floatstr(value);
	if(!strcmp(name, "Saida_Z")) BuildingInfo[idx][bExitz] = floatstr(value);
	if(!strcmp(name, "Lock")) BuildingInfo[idx][bLock] = strval(value);
	if(!strcmp(name, "VW")) BuildingInfo[idx][bVW] = strval(value);
	if(!strcmp(name, "Int")) BuildingInfo[idx][bInterior] = strval(value);
    if(!strcmp(name, "Name")) strmid(BuildingInfo[idx][bName], value, 0, strlen(value), 255);
    return 1;
}

//==========================[GLOBAL/PUBLIC FUNCTIONS]==========================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnDialogResponse] \"%s\" - %d, %d, %d, %d, \"%s\"", ReturnPlayerNameEx(playerid), playerid, dialogid, response, listitem, inputtext);
        DebugLog(_largestring);
    #endif
	switch (dialogid)
    {
        case DIALOG_LOGIN:
        {
            if(!response) return SendClientMessage(playerid, 0xFF0000FF, "Voc� n�o quis logar, por isso, ser� kickado."), Kick(playerid);
            if (GetPVarInt(playerid, "PlayerAccount") != 0)
            {
                format(_largestring, 180, "Bem Vindo de volta, %s!\nDetectamos que voc� tem uma conta neste servidor!\nDigite a senha referente a este personagem abaixo:", ReturnPlayerNameEx(playerid));
		        if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu servidor", _largestring, "Logar", "Sair");
                format(_string, 128, "Contas/%s.ini", ReturnFullName(playerid));
                SetPVarString(playerid, "PassW", inputtext);
                INI_ParseFile(_string, "Logar", false, true, playerid);
            }
            else
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu servidor", "Voc� tem que registrar a senha referente a seu personagem para poder jogar!", "Logar", "Sair");
                GetPlayerName(playerid, _playername, 24);
    			format(_string, sizeof(_string), "Contas/%s.ini", _playername);
    			if (INI_Exist(playerid))
    			{
                    format(_string, 128, "Contas/%s.ini", ReturnFullName(playerid));
		            SetPVarString(playerid, "PassW", inputtext);
                    INI_ParseFile(_string, "Logar", false, true, playerid);
                    return 1;
    			}
                OnPlayerRegister(playerid,inputtext);
            }
            return 1;
        }
        case DIALOG_CREATION:
        {
            if(response)
            {
    	        PlayerInfo[playerid][pSex] = 1;
                ShowPlayerDialog(playerid, DIALOG_CREATION+1, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Etnia", "Digite aqui a nacionalidade de seu personagem.\nExemplo: Se voc� veio do Brasil, digite Brasileiro.", "Selecionar", "Voltar");
        	    return 0;
    		}
            else
    	   	{
    	   	    PlayerInfo[playerid][pSex] = 2;
                ShowPlayerDialog(playerid, DIALOG_CREATION+1, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Etnia", "Digite aqui a nacionalidade de seu personagem.\nExemplo: Se voc� veio do Brasil, digite Brasileiro.", "Selecionar", "Voltar");
    		    return 0;
    		}
        }
        case DIALOG_CREATION+1:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION, DIALOG_STYLE_MSGBOX, "Cria��o de Personagens || {FF0000}Sexo", "Selecione se seu personagem ser� Masculino ou Feminino.", "Masculino", "Feminino");
            new text[64];
            strmid(text, inputtext, 0, 64);
            PlayerInfo[playerid][pOrigin] = text;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+2, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Idade", "Digite a data de seu nascimento\nFormato: Dia/M�s/Ano (Somente n�meros!)", "Ok", "Voltar");
        }
        case DIALOG_CREATION+2:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+1, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Idade", "Digite aqui a nacionalidade de seu personagem.\nExemplo: Se voc� veio do Brasil, digite Brasileiro.", "Selecionar", "Voltar");
    	    {
                new year, month, day;
                getdate(year, month, day);
    	        new DateInfo[3];
    			sscanf(inputtext, "p</>ddd",DateInfo[0], DateInfo[1], DateInfo[2]);
                if(DateInfo[0] < 1 || DateInfo[0] > 31 || DateInfo[1] < 1 || DateInfo[1] > 12 || year - DateInfo[2] < 18 || year - DateInfo[2] > 100)
    			{
                    ShowPlayerDialog(playerid, DIALOG_CREATION+2, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Idade", "{FF0000}ERRO! Voc� digitou uma data inv�lida.\n{A9C4E4}Digite a data de seu nascimento\nFormato: Dia/M�s/Ano (Somente n�meros!)", "Ok", "Voltar");
    			    return 0;
    			}
    			ShowPlayerDialog(playerid, DIALOG_CREATION+4, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Altura", "Digite sua Altura Abaixo, em cent�metros (Ex: 1 metro e 60 cm ficariam 160.)\n N�o coloque v�rgulas!", "Ok", "Voltar");
                return 0;
    	    }
        }
        case DIALOG_CREATION+3:
        {
            if(!response) ShowPlayerDialog(playerid, DIALOG_CREATION+2, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Idade", "Digite a data de seu nascimento\nFormato: Dia/M�s/Ano (Somente n�meros!)", "Ok", "Voltar");
            switch(listitem)
            {
                case 0: return ShowPlayerDialog(playerid, DIALOG_CREATION+4, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Altura", "Digite sua Altura Abaixo, em cent�metros (Ex: 1 metro e 60 cm ficariam 160.)\n N�o coloque v�rgulas!", "Ok", "Voltar");
                case 1: return ShowPlayerDialog(playerid, DIALOG_CREATION+5, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Peso", "Digite abaixo seu peso, em kilogramas.\n N�o coloque v�rgulas!", "Ok", "Voltar");
                case 2: return ShowPlayerDialog(playerid, DIALOG_CREATION+6, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Tatuagens", "Digite informa��es sobre suas tatuagens. (Ex: Caveira com Bandana nas Costas.)\n Limite de 128 caracteres!", "Ok", "Voltar");
                case 3: return ShowPlayerDialog(playerid, DIALOG_CREATION+7, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor do Cabelo", "Louro\nCastanho Bem Claro\nCastanho Claro\nCastanho\nCastanho Escuro\nMoreno\nPreto\nAzul\nRosa\nVermelho\nVerde", "Ok", "Voltar");
                case 4: return ShowPlayerDialog(playerid, DIALOG_CREATION+8, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor de Pele", "Negra\nParda\n�ndia\nAsi�tica\n�rabe\nCaucasiana\nAlbina", "Ok", "Voltar");
                case 5: return ShowPlayerDialog(playerid, DIALOG_CREATION+10, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Outras Descri��es", "Digite descri��es como defeitos, cicatrizes, etc, aqui.\n128 caracteres de limite!", "Ok", "Voltar");
                case 6: return ShowPlayerDialog(playerid, DIALOG_CREATION+11, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor dos Olhos", "{6B4226}Castanho Escuro\n{855E42}Castanho Claro\n{3D9140}Verde\n{3300FF}Azul", "Ok", "Voltar");
                case 7: return ShowPlayerDialog(playerid, DIALOG_CREATION+12, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Defini��o Corporal", "Muito Magro\nMagro\nEsbelto\nSarado\nBombado\nGordo\nMuito Gordo", "Ok", "Voltar");
                case 9: return ShowPlayerDialog(playerid, DIALOG_CREATION+9, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Selecione agora como voc� veio para Los Santos", "De Barco\nDe Avi�o\nDe Trem\nNascido Aqui\nVeio Ilegalmente", "Proceder", "Sair");
                case 8: return ShowPlayerDialog(playerid, DIALOG_CREATION+19, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Roupas", "Digite abaixo o n�mero da sua skin\n{FF0000}(OBS: Ela tem de ser maior que 8 e menor que 299!)", "Proceder", "Sair");
            }
        }
        case DIALOG_CREATION+4:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+2, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Idade", "Digite a data de seu nascimento\nFormato: Dia/M�s/Ano (Somente n�meros!)", "Ok", "Voltar");
            new height;
            height = strval(inputtext);
            if(height > 220 || height < 130 || height == 0) return ShowPlayerDialog(playerid, DIALOG_CREATION+4, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Altura", "Digite sua Altura Abaixo, em cent�metros (Ex: 1 metro e 60 cm ficariam 160.)\n{FF0000} Voc� deve selecionar uma altura entre 130 e 220 cent�metros!!\n N�o coloque v�rgulas!", "Ok", "Voltar");
            PlayerInfo[playerid][pHeight] = height;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+5, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Peso", "Digite abaixo seu peso, em kilogramas.\n N�o coloque v�rgulas!", "Ok", "Voltar");
        }
        case DIALOG_CREATION+5:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+4, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Altura", "Digite sua Altura Abaixo, em cent�metros (Ex: 1 metro e 60 cm ficariam 160.)\n{FF0000} Voc� deve selecionar uma altura entre 130 e 220 cent�metros!!\n N�o coloque v�rgulas!", "Ok", "Voltar");
            new weight;
            weight = strval(inputtext);
            if(weight > 170 || weight < 45 || weight == 0) return ShowPlayerDialog(playerid, DIALOG_CREATION+5, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Peso", "Digite abaixo seu peso, em kilogramas.\n{FF0000} Seu peso deve ser entre 45 e 170 kilos!\n N�o coloque v�rgulas!", "Ok", "Voltar");
            PlayerInfo[playerid][pWeight] = weight;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+6, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Tatuagens", "Digite informa��es sobre suas tatuagens. (Ex: Caveira com Bandana nas Costas.)\n Limite de 128 caracteres!", "Ok", "Voltar");
        }
        case DIALOG_CREATION+6:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+5, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Peso", "Digite abaixo seu peso, em kilogramas.\n{FF0000} Seu peso deve ser entre 45 e 170 kilos!\n N�o coloque v�rgulas!", "Ok", "Voltar");
            new tatoos[128];
            strmid(tatoos, inputtext, 0, 255);
            PlayerInfo[playerid][pTatoo] = tatoos;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+7, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor do Cabelo", "Louro\nCastanho Bem Claro\nCastanho Claro\nCastanho\nCastanho Escuro\nMoreno\nPreto\nAzul\nRosa\nVermelho\nVerde", "Ok", "Voltar");
        }
        case DIALOG_CREATION+7:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+6, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Tatuagens", "Digite informa��es sobre suas tatuagens. (Ex: Caveira com Bandana nas Costas.)\n Limite de 128 caracteres!", "Ok", "Voltar");
            PlayerInfo[playerid][pHairColor] = listitem+1;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+8, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor de Pele", "Negra\nParda\n�ndia\nAsi�tica\n�rabe\nCaucasiana\nAlbina", "Ok", "Voltar");
        }
        case DIALOG_CREATION+8:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+7, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor do Cabelo", "Louro\nCastanho Bem Claro\nCastanho Claro\nCastanho\nCastanho Escuro\nMoreno\nPreto\nAzul\nRosa\nVermelho\nVerde", "Ok", "Voltar");
            PlayerInfo[playerid][pSkinColor] = listitem+1;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+10, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Outras Descri��es", "Digite descri��es como defeitos, cicatrizes, etc, aqui.\n128 caracteres de limite!", "Ok", "Voltar");
        }
        case DIALOG_CREATION+9:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+19, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Roupas", "Digite abaixo o n�mero da sua skin\n{FF0000}(OBS: Ela tem de ser maior que 8 e menor que 299!)", "Proceder", "Sair");
            PlayerInfo[playerid][pTut] = 1;
        	TogglePlayerControllable(playerid, 1);
            SetPlayerPos(playerid, 2078.2712,1286.1401,10.8203);
            PlayerInfo[playerid][pPos][0] = 2078.2712;
            PlayerInfo[playerid][pPos][1] = 1286.1401;
            PlayerInfo[playerid][pPos][2] = 10.8203;
            OnPlayerUpdateEx(playerid);
            SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2], 0, 0, 0, 0, 0, 0, 0);
	        SendClientMessage(playerid, 0xAFAFAFFF, "[{A9C4E4}!{AFAFAF}] Voc� acaba de completar o tutorial de cria��o de seu personagem. Bom jogo! [{A9C4E4}!{AFAFAF}]");
            return SpawnPlayer(playerid);
        }
        case DIALOG_CREATION+10:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+8, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor de Pele", "Negra\nParda\n�ndia\nAsi�tica\n�rabe\nCaucasiana\nAlbina", "Ok", "Voltar");
            new desc[128];
            strmid(desc, inputtext, 0, 255);
            PlayerInfo[playerid][pCharDescription] = desc;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+11, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor dos Olhos", "{6B4226}Castanho Escuro\n{855E42}Castanho Claro\n{3D9140}Verde\n{3300FF}Azul", "Ok", "Voltar");
        }
        case DIALOG_CREATION+11:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+10, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Outras Descri��es", "Digite descri��es como defeitos, cicatrizes, etc, aqui.\n128 caracteres de limite!", "Ok", "Voltar");
            PlayerInfo[playerid][pEyeColor] = listitem+1;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+12, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Defini��o Corporal", "Muito Magro\nMagro\nEsbelto\nSarado\nBombado\nGordo\nMuito Gordo", "Ok", "Voltar");
        }
        case DIALOG_CREATION+12:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+11, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Cor dos Olhos", "{6B4226}Castanho Escuro\n{855E42}Castanho Claro\n{3D9140}Verde\n{3300FF}Azul", "Ok", "Voltar");
            PlayerInfo[playerid][pBody] = listitem+1;
            return ShowPlayerDialog(playerid, DIALOG_CREATION+19, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Roupas", "Digite abaixo o n�mero da sua skin\n{FF0000}(OBS: Ela tem de ser maior que 8 e menor que 299!)", "Proceder", "Sair");
        }
        case DIALOG_CREATION+19:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATION+12, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Defini��o Corporal", "Muito Magro\nMagro\nEsbelto\nSarado\nBombado\nGordo\nMuito Gordo", "Ok", "Voltar");
            new skin = strval(inputtext);
            if(skin < 8 || skin > 299) return ShowPlayerDialog(playerid, 20, DIALOG_STYLE_INPUT, "Cria��o de Personagens || {FF0000}Roupas", "Digite abaixo o n�mero da sua skin\n{FF0000}(OBS: Ela tem de ser maior que 8 e menor que 299!)", "Proceder", "Sair");
            PlayerInfo[playerid][pSkin] = skin;
            SetPlayerSkin(playerid, skin);
            return ShowPlayerDialog(playerid, DIALOG_CREATION+9, DIALOG_STYLE_LIST, "Cria��o de Personagens || {FF0000}Selecione agora como voc� veio para Los Santos", "De Barco\nDe Avi�o\nDe Trem\nNascido Aqui\nVeio Ilegalmente", "Proceder", "Sair");
        }
        case DIALOG_PLAYERDESCRIPTION:
        {
            if(!response) return 0;
            new textstr[256];
            new player;
            player = GetPVarInt(playerid, "PlayerSeen");
            switch (listitem)
            {
                case 0:
                {
                    new heighta, heightb;
                    if(PlayerInfo[player][pHeight] > 200) heighta = 2;
                    else heighta = 1;
                    if(PlayerInfo[player][pHeight] > 200) heightb = PlayerInfo[player][pHeight]-200;
                    else heightb = PlayerInfo[player][pHeight]-100;
                    format(textstr, 128, "A altura desta pessoa �:\n{FF0000}%d cent�metros ou %d metro e %d cent�metros.", PlayerInfo[player][pHeight],heighta, heightb);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Altura", textstr, "OK", "Voltar");
                }
                case 1:
                {
                    format(textstr, 128, "O peso desta pessoa �:\n{FF0000}%d kilogramas.", PlayerInfo[player][pWeight]);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Peso", textstr, "OK", "Voltar");
                }
                case 2:
                {
                    format(textstr, 256, "A pessoa tem as seguintes descri��es de tatuagem:\n{FF0000}%s", PlayerInfo[player][pTatoo]);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Tatuagens", textstr, "OK", "Voltar");
                }
                case 3:
                {
                    new color[24];
                    switch (PlayerInfo[player][pHairColor])
                    {
                        case 1: color = "Louro";
                        case 2: color = "Castanho Bem Claro";
                        case 3: color = "Castanho Claro";
                        case 4: color = "Castanho";
                        case 5: color = "Castanho Escuro";
                        case 6: color = "Moreno";
                        case 7: color = "Preto";
                        case 8: color = "Azul";
                        case 9: color = "Rosa";
                        case 10: color = "Vermelho";
                        case 11: color = "Verde";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A pessoa tem a seguinte cor de cabelo:\n%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Cor de Cabelo", textstr, "OK", "Voltar");
                }
                case 4:
                {
                    new color[24];
                    switch (PlayerInfo[player][pSkinColor])
                    {
                        case 1: color = "Negra";
                        case 2: color = "Parda";
                        case 3: color = "�ndia";
                        case 4: color = "Asi�tica";
                        case 5: color = "�rabe";
                        case 6: color = "Caucasiana";
                        case 7: color = "Albina";
                        default: color = "N�o definida";
                    }
                    format(textstr, 256, "A pessoa tem a seguinte cor de pele:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Cor de pele", textstr, "OK", "Voltar");
                }
                case 5:
                {
                    new color[24];
                    switch (PlayerInfo[player][pBeard])
                    {
                        case 1: color = "Louro";
                        case 2: color = "Castanho Bem Claro";
                        case 3: color = "Castanho Claro";
                        case 4: color = "Castanho";
                        case 5: color = "Castanho Escuro";
                        case 6: color = "Moreno";
                        case 7: color = "Preto";
                        case 8: color = "Azul";
                        case 9: color = "Rosa";
                        case 10: color = "Vermelho";
                        case 11: color = "Verde";
                        case 12: color = "N�o tem";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A pessoa tem a seguinte cor de barba:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Cor da Barba", textstr, "OK", "Voltar");
                }
                case 6:
                {
                    format(textstr, 256, "A pessoa tem as seguintes descri��es:\n{FF0000}%s", PlayerInfo[player][pCharDescription]);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Tatuagens", textstr, "OK", "Voltar");
                }
                case 7:
                {
                    new color[24];
                    switch (PlayerInfo[player][pEyeColor])
                    {
                        case 1: color = "Castanho Escuro";
                        case 2: color = "Castanho Claro";
                        case 3: color = "Verde";
                        case 4: color = "Azul";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A pessoa tem a seguinte cor dos olhos:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Cor dos Olhos", textstr, "OK", "Voltar");
                }
                case 8:
                {
                    new color[24];
                    switch (PlayerInfo[player][pBody])
                    {
                        case 1: color = "Muito Magro";
                        case 2: color = "Magro";
                        case 3: color = "Esbelto";
                        case 4: color = "Sarado";
                        case 5: color = "Bombado";
                        case 6: color = "Gordo";
                        case 7: color = "Muito Gordo";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A defini��o corporal da pessoa �:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Defini��o Corporal", textstr, "OK", "Voltar");
                }
                case 9:
                {
                    new color[24];
                    switch (PlayerInfo[player][pHairStyle])
                    {
                        case 1: color = "Col�mbia";
                        case 2: color = "Black Power";
                        case 3: color = "Afro";
                        case 4: color = "Moicano";
                        case 5: color = "Moicano Punk";
                        case 6: color = "Arrepiado";
                        case 7: color = "Franjinha";
                        case 8: color = "Justin Bieber";
                        case 9: color = "Comprido";
                        case 10: color = "Careca";
                        case 11: color = "Ralinho";
                        case 12: color = "Flat Head";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A pessoa tem o seguinte estilo de cabelo:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Estilo/Corte de Cabelo", textstr, "OK", "Voltar");
                }
                case 10:
                {
                    new color[24];
                    switch (PlayerInfo[player][pBeardStyle])
                    {
                        case 1: color = "Bigodinho";
                        case 2: color = "Bigod�o";
                        case 3: color = "Barba Grande";
                        case 4: color = "Cavanhaque";
                        case 5: color = "Rasteira";
                        case 6: color = "Moustache";
                        case 7: color = "Sem Barba";
                        default: color = "N�o definido";
                    }
                    format(textstr, 256, "A pessoa tem o seguinte estilo de barba:\n{FF0000}%s.", color);
                    return ShowPlayerDialog(playerid, DIALOG_CREATION+14, DIALOG_STYLE_MSGBOX, "Estilo/Corte da Barba", textstr, "OK", "Voltar");
                }
            }
        }
    }
    return 1;
}

public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerInteriorChange] \"%s\" - %d, %d, %d", ReturnPlayerNameEx(playerid), playerid, newinteriorid, oldinteriorid);
        DebugLog(_largestring);
    #endif
	PlayerInfo[playerid][pInt] = newinteriorid;
    PlayerInfo[playerid][pVirWorld] = GetPlayerVirtualWorld(playerid);
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerKeyStateChange] \"%s\" - %d, %d, %d", ReturnPlayerNameEx(playerid), playerid, newkeys, oldkeys);
        DebugLog(_largestring);
    #endif
	if(newkeys == KEY_SECONDARY_ATTACK)
    {
        for(new i = 0; i < sizeof(BuildingInfo); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 1,BuildingInfo[i][bEntrancex], BuildingInfo[i][bEntrancey], BuildingInfo[i][bEntrancez]))
            {
                SetPlayerInterior(playerid, BuildingInfo[i][bInterior]);
            	SetPlayerVirtualWorld(playerid, BuildingInfo[i][bVW]);
                SetPlayerPos(playerid,BuildingInfo[i][bExitx],BuildingInfo[i][bExity],BuildingInfo[i][bExitz]);
                TogglePlayerControllable(playerid, 0);
                SetPVarInt(playerid, "Frozen", 1);
                SetTimerEx("Descongelar", 2000, 0, "i", playerid);
                PlayerInfo[playerid][pInt] = BuildingInfo[i][bInterior];
                PlayerInfo[playerid][pVirWorld] = BuildingInfo[i][bVW];
                SetPVarInt(playerid, "BuildingEntered", i);
            }
            if(IsPlayerInRangeOfPoint(playerid,1,BuildingInfo[i][bExitx],BuildingInfo[i][bExity],BuildingInfo[i][bExitz]))
            {
                SetPlayerInterior(playerid, BuildingInfo[i][bInterior]);
            	SetPlayerVirtualWorld(playerid, BuildingInfo[i][bVW]);
                TogglePlayerControllable(playerid, 0);
                SetPVarInt(playerid, "Frozen", 1);
                SetTimerEx("Descongelar", 2000, 0, "i", playerid);
                SetPlayerPos(playerid,BuildingInfo[i][bEntrancex],BuildingInfo[i][bEntrancey],BuildingInfo[i][bEntrancez]);
                PlayerInfo[playerid][pInt] = BuildingInfo[i][bInterior];
                PlayerInfo[playerid][pVirWorld] = BuildingInfo[i][bVW];
                SetPVarInt(playerid, "BuildingEntered", MAX_BUILDINGS+1);
            }
        }
    }
    return 1;
}


public OnPlayerText(playerid, text[])
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerText] \"%s\" - %d, \"%s\"", ReturnPlayerNameEx(playerid), playerid, text);
        DebugLog(_largestring);
    #endif
	new xstr[160];
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado."), 0;
    if(GetPVarInt(playerid, "ChatAnim"))
	{
        ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1);
	}
    if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(xstr, 128, "%s [Sotaque %s] diz: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, xstr, 10.0);
    }
    else
    {
        format(xstr, 128, "%s diz: %s", ReturnPlayerNameEx(playerid), text);
        nearByMessage(playerid, COLOR_FADE1, xstr, 10.0);
    }
    SetPlayerChatBubble(playerid, xstr, 0xFFFFFFFF, 10, 15000);
    print(xstr);
    return 0;
}

public OnPlayerRequestClass(playerid, classid)
{
	#if defined DEBUG
        format(_largestring, 1280, "[OnPlayerRequestClass] \"%s\" - %d, %d", ReturnPlayerNameEx(playerid), playerid, classid);
        DebugLog(_largestring);
    #endif
	if (GetPVarInt(playerid, "RegistrationStep") == 0 && GetPVarInt(playerid, "PlayerLogged") != 1)
	{
        if (GetPVarInt(playerid, "PlayerAccount") != 0) { format(_largestring, 256, "Bem Vindo de volta, %s!\nDetectamos que voc� tem uma conta neste servidor!\nDigite a senha referente a este personagem abaixo:", ReturnPlayerNameEx(playerid)); ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu Servidor", _largestring, "Logar", "Sair"); }
		else { format(_largestring, 256, "Bem Vindo, %s!\nDetectamos que voc� n�o tem uma conta neste servidor!\nRegistre uma senha referente a este personagem abaixo para proceder:", ReturnPlayerNameEx(playerid)); ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu Servidor", _largestring, "Proceder", "Sair"); }
	}
	else SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, _playername, sizeof(_playername));
    new namestring = strfind(_playername, "_", true);
    if(namestring == -1)
	{
		SendClientMessage(playerid, COLOR_SYSTEM, "[SYS] ERRO! Seu nome n�o est� no padr�o aceito pelo nosso servidor!");
		SendClientMessage(playerid, COLOR_SYSTEM, "[SYS] Voc� deve seguir o formato: Nome_Sobrenome, exemplos: Jason_Crambell, Maxwell_Neiman.");
		Kick(playerid);
		return 1;
	}
	for(new i = 0; i < _:pInfo; i++)
	{
		PlayerInfo[playerid][pInfo: i] = 0;
	}
	SetPlayerColor(playerid,0x00000000);
	SendClientMessage(playerid, COLOR_SYSTEM, "[SYS] Carregando...");
    SetPVarInt(playerid, "BuildingEntered", MAX_BUILDINGS+1);
    if(INI_Exist(playerid))
	{
		SetPVarInt(playerid, "PlayerAccount", 1);
	}
	else
	{
        SetPVarInt(playerid, "PlayerAccount", 0);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DeletePVar(playerid, "Logged");
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    PlayerInfo[playerid][pPos][0] = X;
    PlayerInfo[playerid][pPos][1] = Y;
    PlayerInfo[playerid][pPos][2] = Z;
    if(!GMXSet) { OnPlayerUpdateEx(playerid); }
    switch (reason)
    {
        case 0:
        {
            _playername = ReturnPlayerNameEx(playerid);
            format(_string, 128, "[SYS] Jogador {C2A2DA}%s{A9C4E4}[%d] saiu do servidor. Motivo: {C2A2DA}Crash.", _playername, playerid);
            nearByMessage(playerid, COLOR_SYSTEM, _string);
        }
        case 1:
        {
            _playername = ReturnPlayerNameEx(playerid);
            format(_string, 128, "[SYS] Jogador {C2A2DA}%s{A9C4E4}[%d] saiu do servidor. Motivo: {C2A2DA}Saiu por contra pr�pria. (/q).", _playername, playerid);
            nearByMessage(playerid, COLOR_SYSTEM, _string);
        }
        case 2:
        {
            _playername = ReturnPlayerNameEx(playerid);
            format(_string, 128, "[SYS] Jogador {C2A2DA}%s{A9C4E4}[%d] saiu do servidor. Motivo: {C2A2DA}Kickado ou Banido.", _playername, playerid);
            nearByMessage(playerid, COLOR_SYSTEM, _string);
        }
        default:
        {
            _playername = ReturnPlayerNameEx(playerid);
            format(_string, 128, "[SYS] Jogador {C2A2DA}%s{A9C4E4}[%d] saiu do servidor. Motivo: {C2A2DA}Crash.", _playername, playerid);
            nearByMessage(playerid, COLOR_SYSTEM, _string);
        }
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	_otherplayername = ReturnPlayerNameEx(killerid);
    _playername = ReturnPlayerNameEx(playerid);
    format(_string, 128, "[!] %s [%d] matou %s [%d] com a arma %s [%d].", _otherplayername, killerid, _playername, playerid, ReturnWeaponName(reason), reason);
    AdminWarning(COLOR_WARNING, _string,  1);
    nearByMessage(playerid, COLOR_PURPLE, _string, 20.0);
    SetPlayerColor(playerid,0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	#if defined DEBUG
        format(_largestring, 1280, "[OnPlayerSpawn] \"%s\"", ReturnPlayerNameEx(playerid));
        DebugLog(_largestring);
    #endif
	SetPlayerSkillLevel(playerid, 0, PlayerInfo[playerid][pPISTOL]);
	SetPlayerSkillLevel(playerid, 1, PlayerInfo[playerid][pPISTOL_SILENCED]);
	SetPlayerSkillLevel(playerid, 2, PlayerInfo[playerid][pDESERT_EAGLE]);
	SetPlayerSkillLevel(playerid, 3, PlayerInfo[playerid][pSHOTGUN]);
	SetPlayerSkillLevel(playerid, 4, PlayerInfo[playerid][pSAWNOFF_SHOTGUN]);
	SetPlayerSkillLevel(playerid, 5, PlayerInfo[playerid][pSPAS12_SHOTGUN]);
    SetPlayerSkillLevel(playerid, 6, PlayerInfo[playerid][pMICRO_UZI]);
	SetPlayerSkillLevel(playerid, 2, PlayerInfo[playerid][pMP5]);
	SetPlayerSkillLevel(playerid, 3, PlayerInfo[playerid][pAK47]);
	SetPlayerSkillLevel(playerid, 4, PlayerInfo[playerid][pM4]);
	SetPlayerSkillLevel(playerid, 5, PlayerInfo[playerid][pSNIPERRIFLE]);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	SetPlayerSpawn(playerid);
	TogglePlayerControllable(playerid, 0);
    SetPVarInt(playerid, "Frozen", 1);
    SetTimerEx("Descongelar", 2000, 0, "i", playerid);
    return 1;
}

stock ShowStats(playerid,targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new atext[7];
		if(PlayerInfo[targetid][pSex] == 1) { atext = "Homem"; }
		else if(PlayerInfo[targetid][pSex] == 2) { atext = "Mulher"; }
		new ftext[24];
        if(PlayerInfo[targetid][pFaction] != 0) { ftext = FactionInfo[PlayerInfo[targetid][pFaction]][fName]; }
		else { ftext = "Nenhuma"; }
	    new rtext[24];
        new age = PlayerInfo[targetid][pAge];
		new y = PlayerInfo[targetid][pYearsOn];
		new m = PlayerInfo[targetid][pMonthsOn];
		new d = PlayerInfo[targetid][pDaysOn];
		new h = PlayerInfo[targetid][pHoursOn];
		new mm = PlayerInfo[targetid][pMinutesOn];
		new s = PlayerInfo[targetid][pSecondsOn];
		new level = PlayerInfo[targetid][pLevel];
		new exp = PlayerInfo[targetid][pExp];
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*3;
		new intir = PlayerInfo[targetid][pInt];
		new virworld = PlayerInfo[targetid][pVirWorld];
	    new Float:health;
        _playername = ReturnPlayerNameEx(targetid);
		GetPlayerHealth(targetid,health);
        SendClientMessage(playerid, COLOR_MAROON, "[|===========================================================|]");
        format(_string, sizeof(_string), "N�vel: [%d] || Sexo: [%s] || Idade: [%d] || Experi�ncia: [%d/%d]", level,atext,age,exp,expamount);
        SendClientMessage(playerid, COLOR_CHARTREUSE, _string);
        format(_string, sizeof(_string), "Organiza��o: [%s] || Cargo: [%s]", ftext,rtext);
        SendClientMessage(playerid, COLOR_MAROON, _string);
        if(d > 0) format(_string, sizeof(_string), "Interior: [%d] Virtual World: [%d] || Tempo Jogando: [%d dias] - [%02dh:%02dmin:%02dseg]",intir,virworld, d, h, mm, s);
        else if(m > 0) format(_string, sizeof(_string), "Interior: [%d] Virtual World: [%d] || Tempo Jogando: [%d meses/%d dias] - [%02dh:%02dmin:%02dseg]",intir,virworld, m, d, h, mm, s);
        else if(y > 0) format(_string, sizeof(_string), "Interior: [%d] Virtual World: [%d] || Tempo Jogando: [%d anos/%d meses/%d dias] - [%02dh:%02dmin:%02dseg]",intir,virworld, y, m, d, h, mm, s);
        else format(_string, sizeof(_string), "Interior: [%d] Virtual World: [%d] || Tempo Jogando: [%02dh:%02dmin:%02dseg]",intir,virworld, h, mm, s);
        SendClientMessage(playerid, COLOR_CHARTREUSE, _string);
        SendClientMessage(playerid, COLOR_MAROON, "[|===========================================================|]");
	}
    return 1;
}

public OnGameModeInit()
{
    AddPlayerClass(299, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    ManualVehicleEngineAndLights();
    for(new i = 0; i < sizeof(CarInfo); i++)
    {
        new b[32];
        format(b, sizeof (b), "Carros/Veiculo %d.ini", i);
        INI_ParseFile(b, "LoadCarEx", false, true, i);
    }
    LoadWeapons();
	LoadBuildings();
 	LoadFactions();
	SetGameModeText(SCRIPT_VERSION);
    SendRconCommand("hostname Seu Servidor Aqui");
	SendRconCommand("mapname Los Santos");
	SendRconCommand("weburl Sem Site");
	gettime(ghour, gmin, gsec);
    ghour = shifthour;
	SetWorldTime(ghour);
    SetNameTagDrawDistance(10.0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
    new bc, cc;
    for(new h = 0; h < sizeof(CarInfo); h++)
	{
        if(CarInfo[h][cModel] > 400)
        {
            AddStaticVehicleEx(CarInfo[h][cModel],CarInfo[h][cLocationx],CarInfo[h][cLocationy],CarInfo[h][cLocationz]+1.0,CarInfo[h][cAngle],CarInfo[h][cColorOne],CarInfo[h][cColorTwo],60000);
            new alarm, doors, bonnet, boot, objective;
            SetVehicleParamsEx(h, false, false, alarm, doors, bonnet, boot, objective);
            SetVehicleNumberPlate(h, " ");
            SetVehicleVirtualWorld(h, CarInfo[h][cVW]);
            LinkVehicleToInterior(h, CarInfo[h][cInt]);
            cc++;
        }
    }
    for(new h = 0; h < sizeof(BuildingInfo); h++)
	{
        if(BuildingInfo[h][bName] != 0)
        {
            DestroyDynamic3DTextLabel(BuildingLabel[h]);
            DestroyDynamicPickup(BuildingPickUp[h]);
            format(_string, sizeof(_string), "[%s]\n[|Aperte F ou ENTER para entrar.|]",BuildingInfo[h][bName]);
            BuildingPickUp[h] = CreateDynamicPickup(1559, 1, BuildingInfo[h][bEntrancex], BuildingInfo[h][bEntrancey], BuildingInfo[h][bEntrancez]);
            BuildingLabel[h] = CreateDynamic3DTextLabel(_string,COLOR_SYSTEM,BuildingInfo[h][bEntrancex], BuildingInfo[h][bEntrancey], BuildingInfo[h][bEntrancez],15);
            bc++;
        }
	}
    printf("[SYS]: %d ve�culos no servidor.",cc);
	printf("[SYS]: %d interiores no servidor.",bc);
	printf("[SYS]: %d pickups no servidor carregados.",CountDynamicPickups());
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	SetWorldTime(tmphour);
	SetTimer("GlobalPlayerLoop", 1000, 1);
	return 1;
}

stock FixHour(hour)
{
	hour = timeshift+hour;
	if (hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	shifthour = hour;
	return 1;
}


stock SyncTime()
{
	//new string[64];
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		ghour = tmphour;
		SetWorldTime(tmphour);
	}
}

forward SaveAccounts();

public SaveAccounts()
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(i, X, Y, Z);
            PlayerInfo[i][pPos][0] = X;
            PlayerInfo[i][pPos][1] = Y;
            PlayerInfo[i][pPos][2] = Z;
            OnPlayerUpdateEx(i);
		}
	}
}

public GlobalPlayerLoop()
{
    gametime++;
    foreach(Player, i)
    {
        new reporttime = GetPVarInt(i, "ReportTime");
        if(reporttime > 0) SetPVarInt(i, "ReportTime", reporttime--);
        else
        {
            DeletePVar(i, "ReportTime");
        }
        if(gametime == 3600)
        {
        	if(PlayerInfo[i][pLevel] > 0)
            {
                SendClientMessage(i, COLOR_MAROON, "[!] Voc� ganhou experi�ncia!");
                PlayerInfo[i][pExp]++;
            }
        }
        PlayerInfo[i][pSecondsOn]++;
        if(PlayerInfo[i][pSecondsOn] > 59)
        {
            PlayerInfo[i][pSecondsOn] = 0;
            PlayerInfo[i][pMinutesOn]++;
            if(PlayerInfo[i][pMinutesOn] > 59)
            {
                PlayerInfo[i][pMinutesOn] = 0;
                PlayerInfo[i][pHoursOn]++;
                if(PlayerInfo[i][pHoursOn] > 24)
                {
                    PlayerInfo[i][pHoursOn] = 0;
                    PlayerInfo[i][pDaysOn]++;
                    if(PlayerInfo[i][pDaysOn] > 30)
                    {
                        if(PlayerInfo[i][pDaysOn] > 24)
                        {
                            PlayerInfo[i][pDaysOn] = 0;
                            PlayerInfo[i][pMonthsOn]++;
                            if(PlayerInfo[i][pMonthsOn] > 12)
                            {
                                PlayerInfo[i][pMonthsOn] = 0;
                                PlayerInfo[i][pYearsOn]++;
                            }
                        }
                    }
                }
            }
        }
    }
    if(gametime == 3600)
    {
        SyncTime();
        SaveAccounts();
        gametime = 0;
    }
    return 1;
}

//==============[PLAYER-RELATED SAVING/LOADING/LOGGING FUNCTIONS]===============

public OnPlayerRegister(playerid, pass[])
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerRegister] \"%s\"", ReturnPlayerNameEx(playerid));
        DebugLog(_largestring);
    #endif
	new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, MAX_PLAYER_NAME);
    new userFile[32];
    format(userFile, sizeof (userFile), "Contas/%s.ini", nome);
    new INI:file = INI_Open(userFile);
    SetPVarString(playerid, "PassW", pass);
    GetPVarString(playerid, "PassW", PlayerInfo[playerid][pKey], 24);
	INI_WriteString(file, "Key", PlayerInfo[playerid][pKey]);
    INI_WriteString(file, "RealName",PlayerInfo[playerid][pRealName]);
    INI_WriteInt(file, "Height",PlayerInfo[playerid][pHeight]);
    INI_WriteInt(file, "Weight",PlayerInfo[playerid][pWeight]);
    INI_WriteString(file, "Tatoos",PlayerInfo[playerid][pTatoo]);
    INI_WriteInt(file, "SkinColor",PlayerInfo[playerid][pSkinColor]);
    INI_WriteInt(file, "HairColor",PlayerInfo[playerid][pHairColor]);
    INI_WriteInt(file, "EyeColor",PlayerInfo[playerid][pEyeColor]);
    INI_WriteInt(file, "Beard",PlayerInfo[playerid][pBeard]);
    INI_WriteInt(file, "BeardStyle",PlayerInfo[playerid][pBeardStyle]);
    INI_WriteInt(file, "HairStyle",PlayerInfo[playerid][pHairStyle]);
    INI_WriteString(file, "CharDescription",PlayerInfo[playerid][pCharDescription]);
    INI_WriteInt(file, "Body",PlayerInfo[playerid][pBody]);
    INI_WriteInt(file, "Level",PlayerInfo[playerid][pLevel]);
    INI_WriteInt(file, "AdminLevel",PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(file, "Registered",PlayerInfo[playerid][pReg]);
    INI_WriteInt(file, "Sex",PlayerInfo[playerid][pSex]);
    INI_WriteInt(file, "Age",PlayerInfo[playerid][pAge]);
	INI_WriteString(file, "Origin",PlayerInfo[playerid][pOrigin]);
    INI_WriteInt(file, "CK",PlayerInfo[playerid][pCK]);
    INI_WriteInt(file, "Respect",PlayerInfo[playerid][pExp]);
    INI_WriteInt(file, "Kills",PlayerInfo[playerid][pKills]);
    INI_WriteInt(file, "Deaths",PlayerInfo[playerid][pDeaths]);
    INI_WriteInt(file, "Faction",PlayerInfo[playerid][pFaction]);
    INI_WriteInt(file, "Rank",PlayerInfo[playerid][pRank]);
    INI_WriteInt(file, "Skin",PlayerInfo[playerid][pSkin]);
    GetPlayerArmour(playerid,PlayerInfo[playerid][pArmor]);
	INI_WriteFloat(file, "pColete",PlayerInfo[playerid][pArmor]);
	GetPlayerHealth(playerid,PlayerInfo[playerid][pHealth]);
	INI_WriteFloat(file, "pHealth",PlayerInfo[playerid][pHealth]);
    INI_WriteInt(file, "Int",PlayerInfo[playerid][pInt]);
    INI_WriteFloat(file, "Pos_X",PlayerInfo[playerid][pPos][0]);
	INI_WriteFloat(file, "Pos_Y",PlayerInfo[playerid][pPos][1]);
	INI_WriteFloat(file, "Pos_Z",PlayerInfo[playerid][pPos][2]);
    INI_WriteInt(file, "Gun1",PlayerInfo[playerid][pGun1]);
    INI_WriteInt(file, "Gun2",PlayerInfo[playerid][pGun2]);
    INI_WriteInt(file, "Gun3",PlayerInfo[playerid][pGun3]);
    INI_WriteInt(file, "Ammo1",PlayerInfo[playerid][pAmmo1]);
    INI_WriteInt(file, "Ammo2",PlayerInfo[playerid][pAmmo2]);
    INI_WriteInt(file, "Ammo3",PlayerInfo[playerid][pAmmo3]);
    INI_WriteInt(file, "Tutorial",PlayerInfo[playerid][pTut]);
	INI_WriteString(file, "RadioAlias",PlayerInfo[playerid][pRadioAlias]);
    INI_WriteString(file, "OfficialAlias",PlayerInfo[playerid][pOfficialAlias]);
    INI_WriteInt(file, "Warnings",PlayerInfo[playerid][pWarns]);
    INI_WriteInt(file, "VirWorld",PlayerInfo[playerid][pVirWorld]);
    INI_WriteInt(file, "Fuel",PlayerInfo[playerid][pFuel]);
    INI_WriteString(file, "Sotaque",PlayerInfo[playerid][pSotaque]);
    INI_WriteInt(file, "PistolSkill",PlayerInfo[playerid][pPISTOL]);
    INI_WriteInt(file, "SilencedSkill",PlayerInfo[playerid][pPISTOL_SILENCED]);
    INI_WriteInt(file, "DesertSkill",PlayerInfo[playerid][pDESERT_EAGLE]);
    INI_WriteInt(file, "ShotgunSkill",PlayerInfo[playerid][pSHOTGUN]);
    INI_WriteInt(file, "SawnoffSkill",PlayerInfo[playerid][pSAWNOFF_SHOTGUN]);
    INI_WriteInt(file, "SpasSkill",PlayerInfo[playerid][pSPAS12_SHOTGUN]);
    INI_WriteInt(file, "UziSkill",PlayerInfo[playerid][pMICRO_UZI]);
    INI_WriteInt(file, "MP5Skill",PlayerInfo[playerid][pMP5]);
    INI_WriteInt(file, "AK47Skill",PlayerInfo[playerid][pAK47]);
    INI_WriteInt(file, "M4Skill",PlayerInfo[playerid][pM4]);
    INI_WriteInt(file, "SniperSkill",PlayerInfo[playerid][pSNIPERRIFLE]);
    INI_WriteInt(file, "AnosOnline", PlayerInfo[playerid][pYearsOn]);
    INI_WriteInt(file, "MesesOnline", PlayerInfo[playerid][pMonthsOn]);
    INI_WriteInt(file, "DiasOnline", PlayerInfo[playerid][pDaysOn]);
    INI_WriteInt(file, "HorasOnline", PlayerInfo[playerid][pHoursOn]);
    INI_WriteInt(file, "MinutosOnline", PlayerInfo[playerid][pMinutesOn]);
    INI_WriteInt(file, "SegundosOnline", PlayerInfo[playerid][pSecondsOn]);
    INI_Close(file);
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu servidor", "Voc� acaba de criar uma conta neste servidor!\nDigite a senha que voc� registrou agora.", "Logar", "Sair");
	return 1;
}

public OnPlayerUpdateEx(playerid)
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerUpdateEx] \"%s\"", ReturnPlayerNameEx(playerid));
        DebugLog(_largestring);
    #endif
	new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, MAX_PLAYER_NAME);
    new userFile[32];
    format(userFile, sizeof (userFile), "Contas/%s.ini", nome);
    new INI:file = INI_Open(userFile);
		INI_WriteString(file, "Key", PlayerInfo[playerid][pKey]);
    INI_WriteString(file, "RealName",PlayerInfo[playerid][pRealName]);
    INI_WriteInt(file, "Height",PlayerInfo[playerid][pHeight]);
    INI_WriteInt(file, "Weight",PlayerInfo[playerid][pWeight]);
    INI_WriteString(file, "Tatoos",PlayerInfo[playerid][pTatoo]);
    INI_WriteInt(file, "SkinColor",PlayerInfo[playerid][pSkinColor]);
    INI_WriteInt(file, "HairColor",PlayerInfo[playerid][pHairColor]);
    INI_WriteInt(file, "EyeColor",PlayerInfo[playerid][pEyeColor]);
    INI_WriteInt(file, "Beard",PlayerInfo[playerid][pBeard]);
    INI_WriteInt(file, "BeardStyle",PlayerInfo[playerid][pBeardStyle]);
    INI_WriteInt(file, "HairStyle",PlayerInfo[playerid][pHairStyle]);
    INI_WriteString(file, "CharDescription",PlayerInfo[playerid][pCharDescription]);
    INI_WriteInt(file, "Body",PlayerInfo[playerid][pBody]);
    INI_WriteInt(file, "Level",PlayerInfo[playerid][pLevel]);
    INI_WriteInt(file, "AdminLevel",PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(file, "Registered",PlayerInfo[playerid][pReg]);
    INI_WriteInt(file, "Sex",PlayerInfo[playerid][pSex]);
    INI_WriteInt(file, "Age",PlayerInfo[playerid][pAge]);
	INI_WriteString(file, "Origin",PlayerInfo[playerid][pOrigin]);
    INI_WriteInt(file, "CK",PlayerInfo[playerid][pCK]);
    INI_WriteInt(file, "Respect",PlayerInfo[playerid][pExp]);
    INI_WriteInt(file, "Kills",PlayerInfo[playerid][pKills]);
    INI_WriteInt(file, "Deaths",PlayerInfo[playerid][pDeaths]);
    INI_WriteInt(file, "Faction",PlayerInfo[playerid][pFaction]);
    INI_WriteInt(file, "Rank",PlayerInfo[playerid][pRank]);
    INI_WriteInt(file, "Skin",PlayerInfo[playerid][pSkin]);
    GetPlayerArmour(playerid,PlayerInfo[playerid][pArmor]);
	INI_WriteFloat(file, "pColete",PlayerInfo[playerid][pArmor]);
	GetPlayerHealth(playerid,PlayerInfo[playerid][pHealth]);
	INI_WriteFloat(file, "pHealth",PlayerInfo[playerid][pHealth]);
    INI_WriteInt(file, "Int",PlayerInfo[playerid][pInt]);
    INI_WriteFloat(file, "Pos_X",PlayerInfo[playerid][pPos][0]);
	INI_WriteFloat(file, "Pos_Y",PlayerInfo[playerid][pPos][1]);
	INI_WriteFloat(file, "Pos_Z",PlayerInfo[playerid][pPos][2]);
    INI_WriteInt(file, "Gun1",PlayerInfo[playerid][pGun1]);
    INI_WriteInt(file, "Gun2",PlayerInfo[playerid][pGun2]);
    INI_WriteInt(file, "Gun3",PlayerInfo[playerid][pGun3]);
    INI_WriteInt(file, "Ammo1",PlayerInfo[playerid][pAmmo1]);
    INI_WriteInt(file, "Ammo2",PlayerInfo[playerid][pAmmo2]);
    INI_WriteInt(file, "Ammo3",PlayerInfo[playerid][pAmmo3]);
    INI_WriteInt(file, "Tutorial",PlayerInfo[playerid][pTut]);
	INI_WriteString(file, "RadioAlias",PlayerInfo[playerid][pRadioAlias]);
    INI_WriteString(file, "OfficialAlias",PlayerInfo[playerid][pOfficialAlias]);
    INI_WriteInt(file, "Warnings",PlayerInfo[playerid][pWarns]);
    INI_WriteInt(file, "VirWorld",PlayerInfo[playerid][pVirWorld]);
    INI_WriteInt(file, "Fuel",PlayerInfo[playerid][pFuel]);
    INI_WriteString(file, "Sotaque",PlayerInfo[playerid][pSotaque]);
    INI_WriteInt(file, "PistolSkill",PlayerInfo[playerid][pPISTOL]);
    INI_WriteInt(file, "SilencedSkill",PlayerInfo[playerid][pPISTOL_SILENCED]);
    INI_WriteInt(file, "DesertSkill",PlayerInfo[playerid][pDESERT_EAGLE]);
    INI_WriteInt(file, "ShotgunSkill",PlayerInfo[playerid][pSHOTGUN]);
    INI_WriteInt(file, "SawnoffSkill",PlayerInfo[playerid][pSAWNOFF_SHOTGUN]);
    INI_WriteInt(file, "SpasSkill",PlayerInfo[playerid][pSPAS12_SHOTGUN]);
    INI_WriteInt(file, "UziSkill",PlayerInfo[playerid][pMICRO_UZI]);
    INI_WriteInt(file, "MP5Skill",PlayerInfo[playerid][pMP5]);
    INI_WriteInt(file, "AK47Skill",PlayerInfo[playerid][pAK47]);
    INI_WriteInt(file, "M4Skill",PlayerInfo[playerid][pM4]);
    INI_WriteInt(file, "SniperSkill",PlayerInfo[playerid][pSNIPERRIFLE]);
    INI_WriteInt(file, "AnosOnline", PlayerInfo[playerid][pYearsOn]);
    INI_WriteInt(file, "MesesOnline", PlayerInfo[playerid][pMonthsOn]);
    INI_WriteInt(file, "DiasOnline", PlayerInfo[playerid][pDaysOn]);
    INI_WriteInt(file, "HorasOnline", PlayerInfo[playerid][pHoursOn]);
    INI_WriteInt(file, "MinutosOnline", PlayerInfo[playerid][pMinutesOn]);
    INI_WriteInt(file, "SegundosOnline", PlayerInfo[playerid][pSecondsOn]);
    INI_Close(file);
    return 1;
}

public OnPlayerLoginEx(playerid, name[], value[])
{
    #if defined DEBUG
        format(_largestring, 1280, "[OnPlayerLoginEx] \"%s\"", ReturnPlayerNameEx(playerid));
        DebugLog(_largestring);
    #endif
	if(!strcmp(name, "Key"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        PlayerInfo[playerid][pKey] = cameo;
    }
    if(!strcmp("RealName", name)) {  strmid(PlayerInfo[playerid][pRealName], value, 0, strlen(value), 255); }
    if(!strcmp("Height", name)) {  PlayerInfo[playerid][pHeight] = strval( value ); }
    if(!strcmp("Weight", name)) {  PlayerInfo[playerid][pWeight] = strval( value ); }
    if(!strcmp("Tatoos", name)) {  strmid(PlayerInfo[playerid][pTatoo], value, 0, strlen(value), 255); }
    if(!strcmp("SkinColor", name)) {  PlayerInfo[playerid][pSkinColor] = strval( value ); }
    if(!strcmp("HairColor", name)) {  PlayerInfo[playerid][pHairColor] = strval( value ); }
    if(!strcmp("EyeColor", name)) {  PlayerInfo[playerid][pEyeColor] = strval( value ); }
    if(!strcmp("Beard", name)) {  PlayerInfo[playerid][pBeard] = strval( value ); }
    if(!strcmp("BeardStyle", name)) {  PlayerInfo[playerid][pBeardStyle] = strval( value ); }
    if(!strcmp("HairStyle", name)) {  PlayerInfo[playerid][pHairStyle] = strval( value ); }
    if(!strcmp("CharDescription", name)) {  strmid(PlayerInfo[playerid][pCharDescription], value, 0, strlen(value), 255); }
    if(!strcmp("Body", name)) {  PlayerInfo[playerid][pBody] = strval( value ); }
    if(!strcmp("Level", name)) {  PlayerInfo[playerid][pLevel] = strval( value ); }
	if(!strcmp("AdminLevel", name)) {  PlayerInfo[playerid][pAdmin] = strval( value ); }
    if(!strcmp("Registered", name)) {  PlayerInfo[playerid][pReg] = strval( value ); }
    if(!strcmp("Sex", name)) {  PlayerInfo[playerid][pSex] = strval( value ); }
    if(!strcmp("Age", name)) {  PlayerInfo[playerid][pAge] = strval( value ); }
    if(!strcmp("Origin", name)) {  strmid(PlayerInfo[playerid][pOrigin], value, 0, strlen(value), 255); }
    if(!strcmp("CK", name)) {  PlayerInfo[playerid][pCK] = strval( value ); }
    if(!strcmp("Tutorial", name)) {  PlayerInfo[playerid][pTut] = strval( value ); }
    if(!strcmp("Kills", name)) {  PlayerInfo[playerid][pKills] = strval( value ); }
    if(!strcmp("Deaths", name)) {  PlayerInfo[playerid][pDeaths] = strval( value ); }
    if(!strcmp("Faction", name)) {  PlayerInfo[playerid][pFaction] = strval( value ); }
    if(!strcmp("Rank", name)) {  PlayerInfo[playerid][pRank] = strval( value ); }
    if(!strcmp("Skin", name)) {  PlayerInfo[playerid][pSkin] = strval( value ); }
    if(!strcmp("pColete", name)) {  PlayerInfo[playerid][pArmor] = floatstr( value ); }
    if(!strcmp("pHealth", name)) {  PlayerInfo[playerid][pHealth] = floatstr( value ); }
    if(!strcmp("Int", name)) {  PlayerInfo[playerid][pInt] = strval( value ); }
    if(!strcmp("Pos_X", name)) {  PlayerInfo[playerid][pPos][0] = floatstr( value ); }
    if(!strcmp("Pos_Y", name)) {  PlayerInfo[playerid][pPos][1] = floatstr( value ); }
    if(!strcmp("Pos_Z", name)) {  PlayerInfo[playerid][pPos][2] = floatstr( value ); }
    if(!strcmp("Gun1", name)) {  PlayerInfo[playerid][pGun1] = strval( value ); }
    if(!strcmp("Gun2", name)) {  PlayerInfo[playerid][pGun2] = strval( value ); }
    if(!strcmp("Gun3", name)) {  PlayerInfo[playerid][pGun3] = strval( value ); }
    if(!strcmp("Ammo1", name)) {  PlayerInfo[playerid][pAmmo1] = strval( value ); }
    if(!strcmp("Ammo2", name)) {  PlayerInfo[playerid][pAmmo2] = strval( value ); }
    if(!strcmp("Ammo3", name)) {  PlayerInfo[playerid][pAmmo3] = strval( value ); }
    if(!strcmp("RadioAlias", name)) {  strmid(PlayerInfo[playerid][pRadioAlias], value, 0, strlen(value), 255); }
    if(!strcmp("OfficialAlias", name)) {  strmid(PlayerInfo[playerid][pOfficialAlias], value, 0, strlen(value), 255); }
    if(!strcmp("VirWorld", name)) {  PlayerInfo[playerid][pVirWorld] = strval( value ); }
    if(!strcmp("Fuel", name)) {  PlayerInfo[playerid][pFuel] = strval( value ); }
    if(!strcmp("Sotaque", name)) {  strmid(PlayerInfo[playerid][pSotaque], value, 0, strlen(value), 255); }
    if(!strcmp("PistolSkill", name)) {  PlayerInfo[playerid][pPISTOL] = strval( value );  }
    if(!strcmp("SilencedSkill", name)) {  PlayerInfo[playerid][pPISTOL_SILENCED] = strval( value );   }
    if(!strcmp("DesertSkill", name)) {  PlayerInfo[playerid][pDESERT_EAGLE] = strval( value );   }
    if(!strcmp("ShotgunSkill", name)) {  PlayerInfo[playerid][pSHOTGUN] = strval( value );   }
    if(!strcmp("SawnoffSkill", name)) {  PlayerInfo[playerid][pSAWNOFF_SHOTGUN] = strval( value );   }
    if(!strcmp("SpasSkill", name)) {  PlayerInfo[playerid][pSPAS12_SHOTGUN] = strval( value );   }
    if(!strcmp("UziSkill", name)) {  PlayerInfo[playerid][pMICRO_UZI] = strval( value );  }
    if(!strcmp("MP5Skill", name)) {  PlayerInfo[playerid][pMP5] = strval( value );  }
    if(!strcmp("AK47Skill", name)) {  PlayerInfo[playerid][pAK47] = strval( value );   }
    if(!strcmp("M4Skill", name)) {  PlayerInfo[playerid][pM4] = strval( value );   }
    if(!strcmp("SniperSkill", name)) {  PlayerInfo[playerid][pSNIPERRIFLE] = strval( value );  }
    if(!GetPVarInt(playerid, "PlayerLogged"))
    {
        SendClientMessage(playerid, COLOR_SYSTEM, "[SYS]: Processando seu login, aguarde...");
        SetTimerEx("SetLogin", 800, 0, "i", playerid);
        SetPVarInt(playerid, "PlayerLogged", 1);
        return 1;
    }
    return 1;
}

forward SetLogin(playerid);
public SetLogin(playerid)
{
    if(PlayerInfo[playerid][pCK] > 0)
	{
		SendClientMessage(playerid, COLOR_SYSTEM, "[SYS]: Sua conta esta trancada. Caso queira, fa�a uma reclama��o no f�rum seu f�rum.");
        format(_string, 128, "%s foi kickado ao logar por ter tomado CK.", ReturnPlayerNameEx(playerid));
        KickLog(_string);
        Kick(playerid);
	}
    SendClientMessage(playerid, COLOR_MAROON, "[===============================================================]");
	SendClientMessage(playerid, COLOR_CHARTREUSE,"Voc� acabou de logar no Seu servidor, bem vindo.");
	SendClientMessage(playerid, COLOR_MAROON, "F�rum: seu f�rum");
	if (PlayerInfo[playerid][pAdmin] >= 1)
	{
		format(_string, sizeof(_string), "[SYS]: Voc� logou com o n�vel %d de administrador.",PlayerInfo[playerid][pAdmin]);
		SendClientMessage(playerid, COLOR_CHARTREUSE,_string);
	}
	SendClientMessage(playerid, COLOR_MAROON, "[===============================================================]");
    new playersip[16];
    new giveplayerid = playerid;
    new giveplayer[MAX_PLAYER_NAME];
    giveplayer = ReturnPlayerNameEx(giveplayerid);
	GetPlayerIp(giveplayerid ,playersip, sizeof(playersip));
    format(_string, sizeof(_string), "[SYS]: %s acaba de se logar. IP: %s",ReturnPlayerNameEx(playerid) ,playersip);
    LoginLog(_string);
    SystemWarning(COLOR_SYSTEM,_string);
    SetPlayerSpawn(playerid);
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
    SetTimerEx("UnsetFirstSpawn", 5000, false, "i", playerid);
	SetTimerEx("UnsetCrash", 5000, false, "i", playerid);
    #if defined DEBUG
        format(_largestring, 1280, "[SetLogin] \"%s\"", ReturnPlayerNameEx(playerid));
        DebugLog(_largestring);
    #endif
	return 1;
}

forward Logar(playerid, name[],value[]);
public Logar(playerid, name[], value[])
{
    #if defined DEBUG
        format(_largestring, 1280, "[Logar] \"%s\", \"%s\", \"%s\"", ReturnPlayerNameEx(playerid), name, value);
        DebugLog(_largestring);
    #endif
	if(GetPVarInt(playerid, "PlayerLogged")) return 0;
    new file[36], lstr[24];
    format(file, 36, "Contas/%s.ini", ReturnFullName(playerid));
    new acstring[180];
    format(acstring, 180, "Bem Vindo, {FF0000}%s!\nATEN��O: Voc� registrou uma senha inv�lida!\nSe errar tr�s vezes, voc� ser� banido!{A9C4E4}\nDigite a senha que voc� acabou de registrar:", ReturnPlayerNameEx(playerid));
    if (!strcmp(name, "Key"))
    {
        new cameo[24];
        strmid(cameo, value, 0, 255);
        PlayerInfo[playerid][pKey] = cameo;
    }
    GetPVarString(playerid, "PassW", lstr, 24);
    if(!strcmp(PlayerInfo[playerid][pKey],lstr)) return INI_ParseFile(file, "OnPlayerLoginEx", false, true, playerid);
    else return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Seu servidor Roleplay", acstring, "Logar", "Sair"), 0;
}

//================================[SAVING PUBLICS]==============================

stock SaveWeapons()
{
	new idx;
	new File: file2;
	idx = 0;
 	while (idx < sizeof(ObjCoords))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d,%d,%d,%f,%f,%f\n",
		ObjectID[idx][0],// 1
		ObjectID[idx][1],// 2
		ObjectID[idx][2],// 3
		ObjCoords[idx][0],// 4
		ObjCoords[idx][1],// 5
		ObjCoords[idx][2]);// 15
		if(idx == 1)
		{
			file2 = fopen("weapons.cfg", io_write);
		}
		else
		{
			file2 = fopen("weapons.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
		//OnPropTextdrawUpdate();
	}
	return 1;
}


stock OnPropUpdate()
{
	new idx;
	while (idx < sizeof(BuildingInfo))
	{
        new userFile[32];
        format(userFile, sizeof (userFile), "Interiores/Interior %d.ini", idx);
        new INI:file = INI_Open(userFile);
        INI_WriteFloat(file, "Entrada_X", BuildingInfo[idx][bEntrancex]);
		INI_WriteFloat(file, "Entrada_Y", BuildingInfo[idx][bEntrancey]);
		INI_WriteFloat(file, "Entrada_Z", BuildingInfo[idx][bEntrancez]);
		INI_WriteFloat(file, "Saida_X", BuildingInfo[idx][bExitx]);
		INI_WriteFloat(file, "Saida_Y", BuildingInfo[idx][bExity]);
		INI_WriteFloat(file, "Saida_Z", BuildingInfo[idx][bExitz]);
		INI_WriteString(file, "Nome", BuildingInfo[idx][bName]);
		INI_WriteInt(file, "Lock", BuildingInfo[idx][bLock]);
		INI_WriteInt(file, "VW", BuildingInfo[idx][bVW]);
		INI_WriteInt(file, "Int", BuildingInfo[idx][bInterior]);
		INI_Close(file);
		idx++;
	}
	idx = 0;
	while (idx < sizeof(CarInfo))
	{
        if(CreatedCar[idx]) idx++;
        new userFile[32];
        format(userFile, sizeof (userFile), "Carros/Veiculo %d.ini", idx);
        new INI:file = INI_Open(userFile);
        INI_WriteInt(file, "Modelo", CarInfo[idx][cModel]);
    	INI_WriteFloat(file, "Pos_X", CarInfo[idx][cLocationx]);
    	INI_WriteFloat(file, "Pos_Y", CarInfo[idx][cLocationy]);
    	INI_WriteFloat(file, "Pos_Z", CarInfo[idx][cLocationz]);
    	INI_WriteFloat(file, "Angulo", CarInfo[idx][cAngle]);
    	INI_WriteInt(file, "Cor_1", CarInfo[idx][cColorOne]);
    	INI_WriteInt(file, "Cor_2", CarInfo[idx][cColorTwo]);
    	INI_WriteInt(file, "Lock", CarInfo[idx][cLock]);
        INI_WriteInt(file, "Faction", CarInfo[idx][cFaction]);
        INI_WriteInt(file, "Int", CarInfo[idx][cInt]);
        INI_WriteInt(file, "VW", CarInfo[idx][cVW]);
        INI_Close(file);
        idx++;
	}
	return 1;
}

stock SaveBuildings()
{
    for(new i = 0; i < sizeof(BuildingInfo); i++)
    {
        SaveBuildingEx(i);
    }
    return 1;
}

forward SaveBuildingEx(idx);
public SaveBuildingEx(idx)
{
    new userFile[32];
    format(userFile, sizeof (userFile), "Interiores/Interior %d.ini", idx);
    new INI:file = INI_Open(userFile);
    INI_WriteFloat(file, "Entrada_X", BuildingInfo[idx][bEntrancex]);
	INI_WriteFloat(file, "Entrada_Y", BuildingInfo[idx][bEntrancey]);
	INI_WriteFloat(file, "Entrada_Z", BuildingInfo[idx][bEntrancez]);
	INI_WriteFloat(file, "Saida_X", BuildingInfo[idx][bExitx]);
	INI_WriteFloat(file, "Saida_Y", BuildingInfo[idx][bExity]);
	INI_WriteFloat(file, "Saida_Z", BuildingInfo[idx][bExitz]);
	INI_WriteString(file, "Nome", BuildingInfo[idx][bName]);
	INI_WriteInt(file, "Lock", BuildingInfo[idx][bLock]);
	INI_WriteInt(file, "VW", BuildingInfo[idx][bVW]);
	INI_WriteInt(file, "Int", BuildingInfo[idx][bInterior]);
	INI_Close(file);
    return 1;
}

stock SaveCars()
{
    for(new i = 0; i < sizeof(CarInfo); i++)
    {
        SaveCarEx(i);
    }
    return 1;
}

forward SaveCarEx(idx);
public SaveCarEx(idx)
{
    new userFile[32];
    format(userFile, sizeof (userFile), "Carros/Veiculo %d.ini", idx);
    new INI:file = INI_Open(userFile);
    INI_WriteInt(file, "Modelo", CarInfo[idx][cModel]);
    INI_WriteFloat(file, "Pos_X", CarInfo[idx][cLocationx]);
    INI_WriteFloat(file, "Pos_Y", CarInfo[idx][cLocationy]);
    INI_WriteFloat(file, "Pos_Z", CarInfo[idx][cLocationz]);
    INI_WriteFloat(file, "Angulo", CarInfo[idx][cAngle]);
    INI_WriteInt(file, "Cor_1", CarInfo[idx][cColorOne]);
    INI_WriteInt(file, "Cor_2", CarInfo[idx][cColorTwo]);
    INI_WriteInt(file, "Lock", CarInfo[idx][cLock]);
    INI_WriteInt(file, "Faction", CarInfo[idx][cFaction]);
    INI_Close(file);
    return 1;
}

stock SaveFactions()
{
    for(new i = 0; i < sizeof(FactionInfo); i++)
    {
        new b[32];
        format(b, sizeof (b), "Times/Time %d.ini", i);
        INI_ParseFile(b, "SaveFactionEx", false, true, i);
    }
    return 1;
}

forward SaveFactionEx(idx);
public SaveFactionEx(idx)
{
    new userFile[32];
    format(userFile, sizeof (userFile), "Times/Time %d.ini", idx);
    new INI:file = INI_Open(userFile);
    INI_WriteFloat(file, "HQEN_X", FactionInfo[idx][fHQEntrnance][0]);
	INI_WriteFloat(file, "HQEN_Y", FactionInfo[idx][fHQEntrnance][1]);
	INI_WriteFloat(file, "HQEN_Z", FactionInfo[idx][fHQEntrnance][2]);
	INI_WriteFloat(file, "HQEX_X", FactionInfo[idx][fHQExit][0]);
	INI_WriteFloat(file, "HQEX_Y", FactionInfo[idx][fHQExit][1]);
	INI_WriteFloat(file, "HQEX_Z", FactionInfo[idx][fHQExit][2]);
	INI_WriteString(file, "Name", FactionInfo[idx][fName]);
	INI_WriteString(file, "Leader", FactionInfo[idx][fLeader]);
	INI_WriteInt(file, "Members", FactionInfo[idx][fMembers]);
	INI_WriteInt(file, "Interior", FactionInfo[idx][fInterior]);
	INI_WriteInt(file, "Type", FactionInfo[idx][fType]);
	INI_WriteString(file, "Rank1", FactionInfo[idx][fRank1]);
	INI_WriteString(file, "Rank2", FactionInfo[idx][fRank2]);
	INI_WriteString(file, "Rank3", FactionInfo[idx][fRank3]);
	INI_WriteString(file, "Rank4", FactionInfo[idx][fRank4]);
	INI_WriteString(file, "Rank5", FactionInfo[idx][fRank5]);
	INI_WriteString(file, "Rank6", FactionInfo[idx][fRank6]);
	INI_WriteString(file, "Rank7", FactionInfo[idx][fRank7]);
	INI_WriteString(file, "Rank8", FactionInfo[idx][fRank8]);
	INI_WriteString(file, "Rank9", FactionInfo[idx][fRank9]);
	INI_WriteString(file, "Rank10", FactionInfo[idx][fRank10]);
	INI_WriteString(file, "Rank11", FactionInfo[idx][fRank11]);
	INI_WriteString(file, "Rank12", FactionInfo[idx][fRank12]);
	INI_WriteString(file, "Rank13", FactionInfo[idx][fRank13]);
	INI_WriteString(file, "Rank14", FactionInfo[idx][fRank14]);
	INI_WriteString(file, "Rank15", FactionInfo[idx][fRank15]);
	INI_Close(file);
    return 1;
}

//================================[CHAT STOCKS]=================================


stock SendFormattedMessage(playerid, color, fstring[], {Float, _}:...)
{
    // This is the number of parameters which are not variable that are passed
    // to this function (i.e. the number of named parameters).
    static const
        STATIC_ARGS = 3;
    static const
        BYTES_PER_CELL = 4;
    // Get the number of variable arguments.
    new
        n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;
    if (n)
    {
        new
            message[128],
            arg_start,
            arg_end;

        // Load the real address of the last static parameter. Do this by
        // loading the address of the last known static parameter and then
        // adding the value of [FRM].
        #emit CONST.alt        fstring
        #emit LCTRL          5
        #emit ADD
        #emit STOR.S.pri       arg_start

        // Load the address of the last variable parameter. Do this by adding
        // the number of variable parameters on the value just loaded.
        #emit LOAD.S.alt       n
        #emit ADD
        #emit STOR.S.pri       arg_end

        // Push the variable arguments. This is done by loading the value of
        // each one in reverse order and pushing them. I'd love to be able to
        // rewrite this to use the values of pri and alt for comparison,
        // instead of having to constantly load and reload two variables.
        do
        {
            #emit LOAD.I
            #emit PUSH.pri
            arg_end -= BYTES_PER_CELL;
            #emit LOAD.S.pri     arg_end
        }
        while (arg_end > arg_start);

        // Push the static format parameters.
        #emit PUSH.S         fstring
        #emit PUSH.C         128
        #emit PUSH.ADR        message

        // Now push the number of arguments passed to format, including both
        // static and variable ones and call the function.
        n += BYTES_PER_CELL * 3;
        #emit PUSH.S         n
        #emit SYSREQ.C        format

        // Remove all data, including the return value, from the stack.
        n += BYTES_PER_CELL;
        #emit LCTRL          4
        #emit LOAD.S.alt       n
        #emit ADD
        #emit SCTRL          4

        return SendClientMessage(playerid, color, message);
        //return print(message);
    }
    else
    {
        return SendClientMessage(playerid, color, fstring);
        //return print(fstring);
    }
}

stock AdminWarning(color, string[], level = 1)
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= level && GetPVarInt(i, "ReadAdminWarning"))
			{
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "{AFAFAF}[{FF9900}A{AFAFAF}]: %s ...", lengths);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    format(message, 102, "... %s", length2);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    return 1;
                }
                else
                {
                    new message[192];
                    format(message, 192, "{AFAFAF}[{FF9900}A{AFAFAF}]: %s", string);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    return 1;
                }
			}
		}
	}
	return 1;
}

stock AdminChat(color, string[], level = 1)
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= level && GetPVarInt(i, "ReadAdminChat"))
			{
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "%s ...", lengths);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    format(message, 102, "... %s", length2);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    return 1;
                }
                else
                {
                    new message[192];
                    format(message, 192, "%s", string);
                    SendClientMessage(i, color, message);
                    AdminLog(message);
                    return 1;
                }
			}
		}
	}
	return 1;
}

stock OOCMessage(color,const string[])
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
            if(GetPVarInt(i, "OOC"))
		    {
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "%s ...", lengths);
                    SendClientMessageToAll(color, message);
                    format(message, 102, "... %s", length2);
                    SendClientMessageToAll(color, message);
                }
                else
                {
                    new message[192];
                    format(message, 192, "%s", string);
                    SendClientMessageToAll(color, message);
                }
                OOCLog(stringfull);
			}
		}
	}
    return 1;
}

stock SendWalkieMessage(member, color, string[])
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pRadioFreq] == member)
		    {
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "%s ...", lengths);
                    SendClientMessage(i, color, message);
                    format(message, 102, "... %s", length2);
                    SendClientMessage(i, color, message);
                }
                else
                {
                    new message[192];
                    format(message, 192, "%s", string);
                    SendClientMessage(i, color, message);
                }
                WalkieLog(string);
			}
		}
	}
}

stock SendRadioMessage(member, color, string[])
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pFaction] == member)
		    {
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "%s ...", lengths);
                    SendClientMessage(i, color, message);
                    format(message, 102, "... %s", length2);
                    SendClientMessage(i, color, message);
                }
                else
                {
                    new message[192];
                    format(message, 192, "%s", string);
                    SendClientMessage(i, color, message);
                }
                RadioLog(string);
			}
		}
	}
}

stock SendFactionMessage(family, color, string[])
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pFaction] == family)
		    {
                if(GetPVarInt(i, "FAC"))
                {
                    new stringfull[192];
                    new lengths[96];
                    new length2[96];
                    strmid(stringfull, string, 0, 192);
                    strmid(lengths, stringfull, 0, 96);
                    strmid(length2, string, 95, 192);
                    if(strlen(string) > 96)
                    {
                        new message[102];
                        format(message, 102, "%s ...", lengths);
                        SendClientMessage(i, color, message);
                        format(message, 102, "... %s", length2);
                        SendClientMessage(i, color, message);
                    }
                    else
                    {
                        new message[192];
                        format(message, 192, "%s", string);
                        SendClientMessage(i, color, message);
                    }
                    FactionLog(string);
				}
			}
		}
	}
}

stock SystemWarning(color, string[])
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= 1 && GetPVarInt(i, "ReadSystemWarning"))
			{
                new stringfull[192];
                new lengths[96];
                new length2[96];
                strmid(stringfull, string, 0, 192);
                strmid(lengths, stringfull, 0, 96);
                strmid(length2, string, 95, 192);
                if(strlen(string) > 96)
                {
                    new message[102];
                    format(message, 102, "{AFAFAF}[{A9C4E4}SYS{AFAFAF}]: %s ...", lengths);
                    SendClientMessage(i, color, message);
                    format(message, 102, "{AFAFAF}... %s", length2);
                    SendClientMessage(i, color, message);
                }
                else
                {
                    new message[192];
                    format(message, 192, "{AFAFAF}[{A9C4E4}SYS{AFAFAF}]: %s", string);
                    SendClientMessage(i, color, message);
                }
                SystemLog(string);
			}
		}
	}
}

stock SystemBroadcast(color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[102];
        format(message, 102, "{AFAFAF}[{A9C4E4}SYS{AFAFAF}]%s ...", lengths);
        SendClientMessageToAll(color, message);
        format(message, 102, "{AFAFAF}... %s", length2);
        SendClientMessageToAll(color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{A9C4E4}SYS{AFAFAF}]%s", string);
        SendClientMessageToAll(color, message);
    }
    SystemLog(string);
}

stock Broadcast(color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[102];
        format(message, 102, "%s ...", lengths);
        SendClientMessageToAll(color, message);
        format(message, 102, "... %s", length2);
        SendClientMessageToAll(color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "%s", string);
        SendClientMessageToAll(color, message);
    }
    SystemLog(string);
}

stock SendErrorMessage(playerid, color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{FF0000}!{AFAFAF}]%s ...", lengths);
        SendClientMessage(playerid, color, message);
        format(message, 192, "{AFAFAF}... %s", length2);
        SendClientMessage(playerid, color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{FF0000}!{AFAFAF}] %s", string);
        SendClientMessage(playerid, color, message);
	}
    return 1;
}

stock SendWarningMessage(playerid, color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{FF9900}!{AFAFAF}] %s ...",lengths);
        SendClientMessage(playerid, color, message);
        format(message, 192, "{AFAFAF}... %s", length2);
        SendClientMessage(playerid, color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{FF9900}!{AFAFAF}] %s", string);
        SendClientMessage(playerid, color, message);
	}
    return 1;
}

stock SendSystemMessage(playerid, color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{A9C4E4}!{AFAFAF}] * %s ...",lengths);
        SendClientMessage(playerid, color, message);
        format(message, 192, "{AFAFAF}... %s", length2);
        SendClientMessage(playerid, color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{A9C4E4}!{AFAFAF}] * %s", string);
        SendClientMessage(playerid, color, message);
	}
    return 1;
}

stock SendActionMessage(playerid, color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{C2A2DA}!{AFAFAF}] * %s ...",lengths);
        SendClientMessage(playerid, color, message);
        format(message, 192, "{AFAFAF}... %s", length2);
        SendClientMessage(playerid, color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}[{C2A2DA}!{AFAFAF}] * %s", string);
        SendClientMessage(playerid, color, message);
	}
    return 1;
}

stock SendCommandMessage(playerid, color, string[])
{
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, string, 95, 192);
    if(strlen(string) > 96)
    {
        new message[192];
        format(message, 192, "{AFAFAF}Uso: %s", lengths);
        SendClientMessage(playerid, color, message);
        format(message, 192, "{AFAFAF}... %s", length2);
        SendClientMessage(playerid, color, message);
    }
    else
    {
        new message[192];
        format(message, 192, "{AFAFAF}Uso: %s", string);
        SendClientMessage(playerid, color, message);
	}
    return 1;
}

stock Command_GetDisplayNamed(vixp[], playerid)
{
    #pragma unused playerid
    return vixp;
}

//==================================[COMMANDS]==================================
CMD:re(playerid, params[])
    return cmd_relatorio(playerid, params);

CMD:relatar(playerid, params[])
    return cmd_relatorio(playerid, params);

CMD:reportar(playerid, params[])
    return cmd_relatorio(playerid, params);

CMD:denunciar(playerid, params[])
    return cmd_relatorio(playerid, params);

CMD:relatorio(playerid, params[])
{
    format(_largestring, 1280, "%s - /relatorio %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "ReportTime") != 0)
    {
        format(_string, 128, "Voc� n�o pode usar isso! Espere %d segundos para usar novamente.", GetPVarInt(playerid, "ReportTime"));
        SendErrorMessage(playerid, -1, _string);
        return 1;
    }
    new otherplayerid, message[128];
    if (sscanf(params, "us[128]", otherplayerid, message))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome] [texto]\"", Command_GetDisplayNamed("relatorio", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    _playername = ReturnPlayerNameEx(playerid);
    _otherplayername = ReturnPlayerNameEx(otherplayerid);
    format(_string, sizeof(_string), "%s (%d) reportou o jogador %s (%d)", _playername, playerid, _otherplayername, otherplayerid);
	AdminWarning(COLOR_WARNING,_string,1);
	format(_string, sizeof(_string), "\"%s\"", (message));
	AdminWarning(COLOR_WARNING,_string,1);
	AdminWarning(COLOR_WARNING,"Digite \"/aceitarrelatorio (/ar) [id/nome]\" ou \"/rejeitarrelatorio (/rr) [id/nome]\"",1);
    SendWarningMessage(playerid, COLOR_SYSTEM, "Seu relat�rio foi enviado. Aguarde at� que ele seja respondido.");
	SetPVarInt(playerid, "PlayerReported", 1);
    SetPVarInt(playerid, "ReportTime", 30);
    return 1;
}

CMD:jarma(playerid, params[])
    return cmd_jogararma(playerid, params);

CMD:jogararma(playerid, params[])
{
    format(_largestring, 1280, "%s - /jogararma %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new gunID = GetPlayerWeapon(playerid);
	new gunAmmo = GetPlayerAmmo(playerid);
	if(gunID != 0 && gunAmmo != 0)
	{
		new f = maxobj+1;
		for(new a = 0; a < sizeof(ObjCoords); a++)
		{
			if(ObjCoords[a][0] == 0.0) f = a;
		}

		if(f == maxobj+1) return SendErrorMessage(playerid, 0x33AA3300, "Voc� n�o pode jogar armas no ch�o agora, tente novamente mais tarde!");
   		else
   		{
			format(_string, sizeof(_string), "Voc� deixou uma/um %s", ReturnWeaponName(gunID));
			SendActionMessage(playerid, COLOR_YELLOW, _string);
            format(_string, 128, "* %s coloca uma/um %s no ch�o.", ReturnPlayerNameEx(playerid), ReturnWeaponName(gunID));
            nearByMessage(playerid, COLOR_PURPLE, _string);
            RemovePlayerWeapon(playerid, gunID);
			ObjectID[f][0] = gunID;
			ObjectID[f][1] = gunAmmo;
			ObjectID[f][2] = GetPlayerVirtualWorld(playerid);
		    GetPlayerPos(playerid, ObjCoords[f][0], ObjCoords[f][1], ObjCoords[f][2]);
		    object[f] = CreateDynamicObject(GunObjects[gunID][0], ObjCoords[f][0], ObjCoords[f][1], ObjCoords[f][2]-1, 93.7, 120.0, 120.0, ObjectID[f][2], -1, -1, 200.0);
		    SaveWeapons();
        }
	}
    return 1;
}

CMD:parma(playerid, params[])
    return cmd_pegararma(playerid, params);

CMD:pegararma(playerid, params[])
{
    format(_largestring, 1280, "%s - /pegararma %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new f = maxobj+1;
	for(new a=0;a<sizeof(ObjCoords);a++)
	{
		if(ObjectID[a][0] != 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, ObjCoords[a][0], ObjCoords[a][1], ObjCoords[a][2]))
			f = a;
		}
	}
	if(f == maxobj+1 || Dropped[f] == 1) return SendErrorMessage(playerid, 0x33AA3300, "Voc� n�o esta perto de uma arma!");
	else
	{
        DestroyDynamicObject(object[f]);
		GivePlayerWeaponEx(playerid, ObjectID[f][0], ObjectID[f][1]);
        format(_string, sizeof(_string), "Voc� deixou uma/um %s", ReturnWeaponName(ObjectID[f][0]));
		SendActionMessage(playerid, COLOR_YELLOW, _string);
        format(_string, 128, "* %s coloca uma/um %s no ch�o.", ReturnPlayerNameEx(playerid), ReturnWeaponName(ObjectID[f][0]));
        nearByMessage(playerid, COLOR_PURPLE, _string);
		ObjectID[f][0] = 0;
        ObjectID[f][1] = 0;
        ObjectID[f][2] = 0;
		ObjCoords[f][0] = 0.0;
		ObjCoords[f][1] = 0.0;
		ObjCoords[f][2] = 0.0;
		SaveWeapons();
	}
    return 1;
}

CMD:codenome(playerid, params[])
{
    format(_largestring, 1280, "%s - /codenome %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new result[24];
    if (sscanf(params, "s[24]", result))
    {
        format(_string, sizeof (_string), "\"/%s [codenome]\" - M�ximo de 24 caracteres.", Command_GetDisplayNamed("codenome", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(!GetPVarInt(playerid, "CodenomeOn"))
    {
        PlayerInfo[playerid][pOfficialAlias] = result;
        format(_string, sizeof(_string), "Seu codenome nos r�dios principais agora �: \"%s\"", PlayerInfo[playerid][pOfficialAlias]);
        SendWarningMessage(playerid, COLOR_WHITE, _string);
        SetPVarInt(playerid, "CodenomeOn", 1);
        return 1;
    }
    else
    {
        DeletePVar(playerid, "CodenomeOn");
        return SendWarningMessage(playerid, COLOR_GRAD2, " Voc� desligou seu codenome.");
    }
}

CMD:codenomewt(playerid, params[])
{
    format(_largestring, 1280, "%s - /codenomewt %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new result[24];
    if (sscanf(params, "s[24]", result))
    {
        format(_string, sizeof (_string), "\"/%s [codenome]\" - M�ximo de 24 caracteres.", Command_GetDisplayNamed("codenomewt", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(!GetPVarInt(playerid, "CodenomeWTOn"))
    {
        PlayerInfo[playerid][pRadioAlias] = result;
        format(_string, sizeof(_string), "Seu codenome nos r�dios de walkie talkie agora �: \"%s\"", PlayerInfo[playerid][pRadioAlias]);
        SendWarningMessage(playerid, COLOR_WHITE, _string);
        SetPVarInt(playerid, "CodenomeWTOn", 1);
        return 1;
    }
    else
    {
        DeletePVar(playerid, "CodenomeOn");
        return SendWarningMessage(playerid, COLOR_GRAD2, " Voc� desligou seu codenome.");
    }
}

CMD:descricao(playerid, params[])
{
    format(_largestring, 1280, "%s - /descricao %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new result[128];
    if (sscanf(params, "s[128]", result))
    {
        format(_string, sizeof (_string), "\"/%s [descri��o]\" - M�ximo de 128 caracteres.", Command_GetDisplayNamed("descricao", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(GetPVarInt(playerid, "PlayerDescriptionOn"))
    {
        DeletePVar(playerid, "PlayerDescriptionOn");
        DestroyDynamic3DTextLabel(PlayerDescription[playerid]);
        return SendWarningMessage(playerid, 0xFFFFFFFF, "Voc� desligou sua descri��o.");
	}
    SetPVarInt(playerid, "PlayerDescriptionOn", 1);
    format(_string,sizeof(_string),"[DESCRI��O]\n\"%s\"",(result));
    PlayerDescription[playerid] = CreateDynamic3DTextLabel(_string, 0xC2A2DAFF, 0.0, 0.0, 0.3, 35, playerid);
    format(_string, sizeof(_string), "Sua descri��o agora � \"%s\", digite \"/descricao\" novamente para retir�-la.", result);
	SendWarningMessage(playerid, COLOR_WHITE, _string);
    return 1;
}

CMD:sotaque(playerid, params[])
{
    format(_largestring, 1280, "%s - /sotaque %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new result[24];
    if (sscanf(params, "s[24]", result))
    {
        format(_string, sizeof (_string), "\"/%s [sotaque]\" - M�ximo de 24 caracteres.", Command_GetDisplayNamed("sotaque", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(GetPVarInt(playerid, "SotaqueOn"))
    {
        DeletePVar(playerid, "SotaqueOn");
        return SendWarningMessage(playerid, 0xFFFFFFFF, "Voc� retirou seu sotaque.");
	}
    SetPVarInt(playerid, "SotaqueOn", 1);
    strins(PlayerInfo[playerid][pSotaque],result, 0);
    format(_string, sizeof(_string), "Seu sotaque agora � \"%s\", digite \"/sotaque\" novamente para retir�-lo.", result);
	SendWarningMessage(playerid, COLOR_WHITE, _string);
    return 1;
}

CMD:sos(playerid, params[])
    return cmd_duvida(playerid, params);

CMD:duvida(playerid, params[])
{
    format(_largestring, 1280, "%s - /duvida %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "ReportTime") != 0)
    {
        format(_string, 128, "Voc� n�o pode usar isso! Espere %d segundos para usar novamente.", GetPVarInt(playerid, "ReportTime"));
        SendErrorMessage(playerid, -1, _string);
        return 1;
    }
    new message[128];
    if (sscanf(params, "s[128]", message))
    {
        format(_string, sizeof (_string), "\"/%s [d�vida]\"", Command_GetDisplayNamed("duvida", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    _playername = ReturnPlayerNameEx(playerid);
    format(_string, sizeof(_string), "%s (%d) enviou um pedido de ajuda", _playername, playerid);
	AdminWarning(COLOR_WARNING,_string,1);
	format(_string, sizeof(_string), "\"%s\"", (message));
	AdminWarning(COLOR_WARNING,_string,1);
    SendWarningMessage(playerid, COLOR_SYSTEM, "Seu pedido de ajuda foi enviado. Aguarde at� que ele seja respondido.");
    SetPVarInt(playerid, "ReportTime", 30);
    return 1;
}

CMD:anims(playerid, params[])
    return cmd_animacoes(playerid, params);

CMD:animlist(playerid, params[])
    return cmd_animacoes(playerid, params);

CMD:animhelp(playerid, params[])
    return cmd_animacoes(playerid, params);

CMD:animacoes(playerid, params[]) {
    format(_largestring, 1280, "%s - /animacoes %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    SendClientMessage(playerid, COLOR_SYSTEM, "[===================[ANIMA��ES]===================]");
    SendClientMessage(playerid, COLOR_SYSTEM, "- Algumas anima��es tem mais de 1 comando para a mesma, exemplo: /maosalto � a mesma de /handsup.");
    SendClientMessage(playerid, COLOR_SYSTEM, "/maosalto - /maosatraz - /bebado - /bomba - /roubar - /rir - /olhar - /roubarhomem - /esconder - /vomitar");
    SendClientMessage(playerid, COLOR_SYSTEM, "/comer - /baternabunda - /dedodomeio - /crack - /taichi - /olharhoras - /dormir - /ferido - /abrirporta");
    SendClientMessage(playerid, COLOR_SYSTEM, "/acenarbaixo - /maosatraz - /ps - /mergulhar - /semostrar - /oculos - /chorar - /jogar - /roubado - /ferido");
    SendClientMessage(playerid, COLOR_SYSTEM, "/caixa - /lavarmaos - /cocarsaco - /saudar - /masturbar - /parar - /rap - /conversar - /gestos - /deitar");
    SendClientMessage(playerid, COLOR_SYSTEM, "/acenar - /sinal - /cansado - /cair - /andar - /loco - /olhar - /strip - /fumar - /dj - /recarregar");
    SendClientMessage(playerid, COLOR_SYSTEM, "/pixar - /negociar - /cruzarbracos - /taco - /comemorar - /sentar - /comersentado - /bar - /dancar");
    SendClientMessage(playerid, COLOR_SYSTEM, "- Para parar as anima��es, digite /stopanim ou /pararanimacoes.");
	return 1;
}

CMD:mijar(playerid, params[]) {
    SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:handsup(playerid, params[])
    return cmd_maosalto(playerid, params);

CMD:maosalto(playerid, params[]) {
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:maostraz(playerid, params[])
    return cmd_maostraz(playerid, params);

CMD:algemado(playerid, params[])
    return cmd_maosatraz(playerid, params);

CMD:maosatraz(playerid, params[]) {
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CUFFED);
	return 1;
}

CMD:bebado(playerid, params[]) {
    ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 0);
	return 1;
}

CMD:bomba(playerid, params[]) {
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:roubar(playerid, params[]) {
    ApplyAnimation(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 0);
 	return 1;
}

CMD:rir(playerid, params[]) {
    ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:olhar(playerid, params[]) {
    ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:roubarhomem(playerid, params[]) {
    ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:esconder(playerid, params[]) {
    ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:vomitar(playerid, params[]) {
    ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:comer(playerid, params[]) {
    ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:baternabunda(playerid, params[]) {
    ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:crack(playerid, params[]) {
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}


CMD:fodase(playerid, params[])
    return cmd_dedomeio(playerid, params);

CMD:dedodomeio(playerid, params[])
    return cmd_dedomeio(playerid, params);

CMD:dedomeio(playerid, params[]) {
    ApplyAnimation(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:taichi(playerid, params[]) {
    ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:beber(playerid, params[]) {
    ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:olharhoras(playerid, params[]) {
    ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:dormir(playerid, params[]) {
    ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:morrendo(playerid, params[]) {
    ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:abrirporta(playerid, params[]) {
    ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:acenarbaixo(playerid, params[]) {
    ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:primeirossocorros(playerid, params[])
    return cmd_ps(playerid, params);

CMD:massagemcardiaca(playerid, params[])
    return cmd_ps(playerid, params);

CMD:ps(playerid, params[]) {
    ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:mergulhar(playerid, params[]) {
    ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0);
   	return 1;
}

CMD:semostrar(playerid, params[]) {
    ApplyAnimation(playerid, "Freeweights", "gym_free_celebrate", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:oculos(playerid, params[]) {
    ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:chorar(playerid, params[]) {
    ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:jogar(playerid, params[]) {
    ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:roubado(playerid, params[]) {
    ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:ferido(playerid, params[]) {
   	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:caixa(playerid, params[]) {
    ApplyAnimation(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:lavarmaos(playerid, params[]) {
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:cocar(playerid, params[])
    return cmd_coceira(playerid, params);

CMD:cocarsaco(playerid, params[])
    return cmd_coceira(playerid, params);

CMD:coceira(playerid, params[]) {
    ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:saudar(playerid, params[]) {
    ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0);
   	return 1;
}

CMD:masturbar(playerid, params[]) {
    ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:parar(playerid, params[]) {
    ApplyAnimation(playerid, "PED", "endchat_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:rap(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/rap [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
      	default: SendCommandMessage(playerid, COLOR_GREY, "/rap [1-3]");
   	}
   	return 1;
 }

CMD:conversar(playerid, params[]) {
    new animid;
	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/conversar [1-7]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0, 0, 0, 0, 0, 0);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0, 0, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0, 0, 0, 0, 0, 0);
	    case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/chat [1-7]");
 	}
 	return 1;
}

CMD:gestos(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/gestos [1-15]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0);
        case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0);
        case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0);
        case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0);
        case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0);
        case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
        case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
        case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0);
        case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0);
        case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0);
        case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0);
        case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/gestos [1-15]");
   	}
   	return 1;
}

CMD:deitar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/deitar [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/deitar [1-3]");
 	}
 	return 1;
}

CMD:acenar(playerid, params[]) {
     new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/acenar [1-3]");
	switch(animid) {
 		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
 		case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.0, 0, 0, 0, 0, 0);
 		case 3: ApplyAnimation(playerid, "PED", "endchat_03", 4.0, 0, 0, 0, 0, 0);
 		default: SendCommandMessage(playerid, COLOR_GREY, "/acenar [1-3]");
 	}
 	return 1;
}

CMD:sinal(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/sinal [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/sinal [1-2]");
   	}
   	return 1;
}

CMD:cansado(playerid, params[])
    return cmd_semar(playerid, params);

CMD:semar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/semar [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
     	default: SendCommandMessage(playerid, COLOR_GREY, "/semar [1-3]");
 	}
 	return 1;
}

CMD:cair(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/cair [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0);
    	case 2: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0);
     	case 3: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0);
      	default: SendCommandMessage(playerid, COLOR_GREY, "/cair [1-3]");
 	}
 	return 1;
}

CMD:andar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/andar [1-26]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1);
    	case 2: ApplyAnimation(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimation(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimation(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimation(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimation(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimation(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1);
     	case 9: ApplyAnimation(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1);
      	case 10: ApplyAnimation(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1);
       	case 11: ApplyAnimation(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimation(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimation(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimation(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimation(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimation(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1);
	    case 17: ApplyAnimation(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1);
	    case 18: ApplyAnimation(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1);
	    case 19: ApplyAnimation(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1);
	    case 20: ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1);
	    case 21: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 22: ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1);
	    case 23: ApplyAnimation(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1);
     	case 24: ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1);
  		case 25: ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1);
  		case 26: ApplyAnimation(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/andar [1-26]");
 	}
	return 1;
}

CMD:loco(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/loco [1-9]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
      	case 4: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0);
       	case 5: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0);
       	case 7: ApplyAnimation(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0);
        default: SendCommandMessage(playerid, COLOR_GREY, "/loco [1-9]");
   	}
   	return 1;
}

CMD:strip(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/strip [1-2]");
	switch(animid) {

       	case 1: ApplyAnimation(playerid, "STRIP", "PLY_CASH", 4.0, 0, 0, 0, 0, 0);
       	case 2: ApplyAnimation(playerid, "STRIP", "PUN_CASH", 4.0, 0, 0, 0, 0, 0);
       	default: SendCommandMessage(playerid, COLOR_GREY, "/strip [1-2]");
 	}
 	return 1;
}

CMD:fumar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/fumar [1-3]");
	switch(animid) {

		case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/fumar [1-2]");
 	}
 	return 1;
}

CMD:dj(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/dj [1-4]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0);
     	case 4: ApplyAnimation(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0);
      	default: SendCommandMessage(playerid, COLOR_GREY, "/dj [1-4]");
 	}
	return 1;
}

CMD:recarregar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/recarregar - 1 (Pistola), 2 (Espingarda), 3 (Metralhadora/Fuzil)");
	switch(animid) {
		case 1: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
 		case 3: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.0,0,0,0,0,0);
		default: SendCommandMessage(playerid, COLOR_GREY, "/recarregar - 1 (Pistola), 2 (Espingarda), 3 (Metralhadora/Fuzil)");
 	}
 	return 1;
}

CMD:pixar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/pixar [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/pixar [1-2]");
 	}
 	return 1;
}

CMD:negociar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/negociar [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/negociar [1-2]");
 	}
 	return 1;
}

CMD:stopanim(playerid, params[])
    return cmd_pararanim(playerid, params);

CMD:stopani(playerid, params[])
    return cmd_pararanim(playerid, params);

CMD:pararanim(playerid, params[]) {
    format(_largestring, 1280, "%s - /pararanim %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPlayerState(playerid) == 1) {
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		SendWarningMessage(playerid, COLOR_WHITE, "Anima��es paradas.");
 	    ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else SendClientMessage(playerid, COLOR_GREY, "Voc� n�o pode fazer isso.");
	return 1;
}

CMD:crossarms(playerid, params[])
    return cmd_cruzarbracos(playerid, params);

CMD:cruzarbracos(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/cruzarbracos [1-4]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
  		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/cruzarbracos [1-4]");
 	}
 	return 1;
}

CMD:taco(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/taco [1-2]");
	switch(animid) {
		case 1: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
		default: SendCommandMessage(playerid, COLOR_GREY, "/taco [1-2]");
 	}
 	return 1;
}

CMD:comemorar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/comemorar [1-8]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.0, 0, 0, 0, 0, 0);
  		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.0, 0, 0, 0, 0, 0);
  		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/comemorar [1-8]");
 	}
   	return 1;
}

CMD:sentar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/sentar [1-6]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "PED", "SEAT_down", 4.0, 0, 1, 1, 1, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/sentar [1-6]");
 	}
 	return 1;
}

CMD:comersentado(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/comersentado [1-2]");
	switch(animid) {

		case 1: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/comersentado [1-2]");
   	}
   	return 1;
}

CMD:bar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/bar [1-5]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0);
	    case 5: ApplyAnimation(playerid, "BAR", "BARman_idle", 4.0, 0, 0, 0, 0, 0);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/bar [1-5]");
 	}
   	return 1;
}

CMD:dancar(playerid, params[]) {
    new animid;
   	if(sscanf(params,"d",animid)) return SendCommandMessage(playerid, COLOR_GREY, "/dancar [1-4]");
	switch(animid) {

  		case 1: SetPlayerSpecialAction(playerid, 5);
	    case 2: SetPlayerSpecialAction(playerid, 6);
        case 3: SetPlayerSpecialAction(playerid, 7);
	    case 4: SetPlayerSpecialAction(playerid, 8);
  		default: SendCommandMessage(playerid, COLOR_GREY, "/dancar [style 1-4]");
	}
 	return 1;
}

CMD:pegarip(playerid, params[])
{
    format(_largestring, 1280, "%s - /pegarip %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, otherplayerip[16];
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome]\"", Command_GetDisplayNamed("pegarip", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        GetPlayerIp(otherplayerid, otherplayerip, 16);
        format(_string, sizeof(_string), "[SYS] Jogador: %s (%d) - IP: \"%s\"", ReturnPlayerNameEx(otherplayerid), otherplayerid, otherplayerip);
        SendClientMessage(playerid, COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:desbanirip(playerid, params[])
{
    format(_largestring, 1280, "%s - /desbanirip %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new unbanip[16];
    if (sscanf(params, "s[16]", unbanip))
    {
        format(_string, sizeof (_string), "\"/%s [ip]\"", Command_GetDisplayNamed("desbanirip", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        format(_string, sizeof(_string), "unbanip %s", unbanip);
        SendRconCommand(_string);
		SendRconCommand("reloadbans");
        format(_string, sizeof(_string), "%s desbaniu o IP: \"%s\"", ReturnPlayerNameEx(playerid), unbanip);
        AdminWarning(COLOR_WHITE, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:explodir(playerid, params[])
{
    format(_largestring, 1280, "%s - /explodir %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("explodir", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        new Float:boomx, Float:boomy, Float:boomz;
		GetPlayerPos(otherplayerid,boomx, boomy, boomz);
		CreateExplosion(boomx, boomy , boomz, 7, 10);
        format(_string, sizeof(_string), "%s explodiu %s (%d).", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_WHITE, _string);
        format(_string, 128, "%s (%d) lhe explodiu.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(playerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:checararmas(playerid, params[])
{
    format(_largestring, 1280, "%s - /checararmas %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("checararmas", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        format(_string, sizeof(_string), "%s tem as seguintes armas:", ReturnPlayerNameEx(otherplayerid));
        SendClientMessage(playerid, COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "Arma 1: %s || Muni��o: %d", ReturnWeaponName(PlayerInfo[playerid][pGun1]), PlayerInfo[playerid][pAmmo1]);
        SendClientMessage(playerid, COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "Arma 2: %s || Muni��o: %d", ReturnWeaponName(PlayerInfo[playerid][pGun2]), PlayerInfo[playerid][pAmmo2]);
        SendClientMessage(playerid, COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "Arma 3: %s || Muni��o: %d", ReturnWeaponName(PlayerInfo[playerid][pGun3]), PlayerInfo[playerid][pAmmo3]);
        SendClientMessage(playerid, COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:carid(playerid, params[])
    return cmd_iddocarro(playerid, params);

CMD:vehid(playerid, params[])
    return cmd_iddocarro(playerid, params);

CMD:idcar(playerid, params[])
    return cmd_iddocarro(playerid, params);

CMD:iddocarro(playerid, params[]) {
    format(_largestring, 1280, "%s - /iddocarro %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(IsPlayerInAnyVehicle(playerid)) {
        format(_string, 128, "ID deste ve�culo: %i || Modelo: %i.", GetPlayerVehicleID(playerid), GetVehicleModel(GetPlayerVehicleID(playerid)));
        SendWarningMessage(playerid, COLOR_WHITE, _string);
	}
	else SendClientMessage(playerid, COLOR_GREY, "Voc� n�o est� em um ve�culo.");
	return 1;
}

CMD:ar(playerid, params[])
    return cmd_aceitarrelatorio(playerid, params);

CMD:aceitarrelatorio(playerid, params[])
{
    format(_largestring, 1280, "%s - /aceitarrelatorio %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome]\"", Command_GetDisplayNamed("aceitarrelatorio", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!GetPVarInt(otherplayerid, "PlayerReported")) return SendErrorMessage(playerid, -1, "Este jogador n�o mandou um relat�rio!");
        DeletePVar(otherplayerid, "PlayerReported");
        format(_string, sizeof(_string), "%s aceitou o relat�rio de %s (%d)", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s {00CF00}aceitou{AFAFAF} seu relat�rio. Em instantes, ele entrar� em contato com voc�.", ReturnPlayerNameEx(playerid));
        SendWarningMessage(otherplayerid, COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:rr(playerid, params[])
    return cmd_rejeitarrelatorio(playerid, params);

CMD:rejeitarrelatorio(playerid, params[])
{
    format(_largestring, 1280, "%s - /rejeitarrelatorio %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome]\"", Command_GetDisplayNamed("rejeitarrelatorio", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!GetPVarInt(otherplayerid, "PlayerReported")) return SendErrorMessage(playerid, -1, "Este jogador n�o mandou um relat�rio!");
        DeletePVar(otherplayerid, "PlayerReported");
        format(_string, sizeof(_string), "%s rejeitou o relat�rio de %s (%d)", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s {CF0000}rejeitou{AFAFAF} seu relat�rio. Em instantes, ele entrar� em contato com voc�.", ReturnPlayerNameEx(playerid));
        SendWarningMessage(otherplayerid, COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:aj(playerid, params[])
    return cmd_aceitarajuda(playerid, params);

CMD:aceitarajuda(playerid, params[])
{
    format(_largestring, 1280, "%s - /aceitarajuda %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome]\"", Command_GetDisplayNamed("aceitarajuda", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!GetPVarInt(otherplayerid, "PlayerReported")) return SendErrorMessage(playerid, -1, "Este jogador n�o mandou um pedido de ajuda!");
        DeletePVar(otherplayerid, "PlayerReported");
        format(_string, sizeof(_string), "%s atendeu o pedido de ajuda de %s (%d)", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s atendeu a seu pedido de ajuda, e entrar� em contato com voc� em instantes.", ReturnPlayerNameEx(playerid));
        SendWarningMessage(otherplayerid, COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:salvarcontas(playerid, params[])
{
    format(_largestring, 1280, "%s - /salvarcontas %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        SaveAccounts();
        format(_string, sizeof(_string), "%s salvou todas as contas do servidor.", ReturnPlayerNameEx(playerid));
        AdminWarning(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "[SYS] Todas as contas do servidor foram salvas por %s.", ReturnPlayerNameEx(playerid));
        OOCMessage(COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:o(playerid, params[])
    return cmd_ooc(playerid, params);

CMD:ooc(playerid, params[])
{
    format(_largestring, 1280, "%s - /ooc %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("ooc", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(!GetPVarInt(playerid, "Muted") && gOOC)
    {
        format(_string, sizeof(_string), "[OOC] %s [%d]: %s", ReturnPlayerNameEx(playerid), playerid, text);
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:desligarooc(playerid, params[])
    return cmd_noooc(playerid, params);

CMD:noooc(playerid, params[])
{
    format(_largestring, 1280, "%s - /noooc %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
    if(gOOC)
    {
        gOOC = 0;
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s acaba de {CF0000}desligar{AFAFAF} o chat OOC!", ReturnPlayerNameEx(playerid));
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }
    else
    {
        gOOC = 1;
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s acaba de {00CF00}ligar{AFAFAF} o chat OOC!", ReturnPlayerNameEx(playerid));
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }

}

CMD:ao(playerid, params[])
    return cmd_adminooc(playerid, params);

CMD:aooc(playerid, params[])
    return cmd_adminooc(playerid, params);

CMD:adminooc(playerid, params[])
{
    format(_largestring, 1280, "%s - /adminooc %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("adminooc", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        format(_string, sizeof(_string), "{AFAFAF}[AW] %s [%d]: {A9C4E4}%s", ReturnPlayerNameEx(playerid), playerid, text);
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:rg(playerid, params[])
    return cmd_stats(playerid, params);

CMD:stats(playerid, params[]) {
    format(_largestring, 1280, "%s - /stats %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    ShowStats(playerid,playerid);
	return 1;
}

CMD:checar(playerid, params[])
{
    format(_largestring, 1280, "%s - /checar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("checar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        ShowStats(playerid,otherplayerid);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:lerooc(playerid, params[]) {

    format(_largestring, 1280, "%s - /lerooc %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "OOC"))
    {
        DeletePVar(playerid, "OOC");
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler as mensagens do chat Out of Character Globais.");
    }
    else
    {
        SetPVarInt(playerid, "OOC", 1);
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler mensagens do chat Out of Character Globais.");
    }
	return 1;
}

CMD:lerfam(playerid, params[]) {

    format(_largestring, 1280, "%s - /lerfam %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "FAC"))
    {
        DeletePVar(playerid, "FAC");
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler as mensagens do chat Out of Character de sua fac��o.");
    }
    else
    {
        SetPVarInt(playerid, "FAC", 1);
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler mensagens do chat Out of Character de sua fac��o.");
    }
	return 1;
}

CMD:lerpm(playerid, params[]) {

    format(_largestring, 1280, "%s - /lerpm %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "PM"))
    {
        DeletePVar(playerid, "PM");
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler as mensagens particulares.");
    }
    else
    {
        SetPVarInt(playerid, "PM", 1);
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler mensagens particulares.");
    }
	return 1;
}

CMD:verpm(playerid, params[])
{

    format(_largestring, 1280, "%s - /verpm %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(playerid, "LerPM"))
        {
            DeletePVar(playerid, "LerPM");
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler as mensagens particulares de todo mundo.");
        }
        else
        {
            SetPVarInt(playerid, "LerPM", 1);
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler mensagens particulares de todo mundo.");
        }
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
    return 1;
}

CMD:togcanim(playerid, params[])
    return cmd_chatanim(playerid, params);

CMD:chatanim(playerid, params[]) {

    format(_largestring, 1280, "%s - /chatanim %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "ChatAnim"))
    {
        DeletePVar(playerid, "ChatAnim");
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� desabilitou a anima��o autom�tica de chat.");
    }
    else
    {
        SetPVarInt(playerid, "ChatAnim", 1);
        SendWarningMessage(playerid, COLOR_GRAD2, "Voc� habilitou a anima��o autom�tica de chat.");
    }
	return 1;
}

CMD:lac(playerid, params[])
    return cmd_leradminchat(playerid, params);

CMD:leradminchat(playerid, params[])
{
    format(_largestring, 1280, "%s - /leradminchat %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(playerid, "ReadAdminChat"))
        {
            DeletePVar(playerid, "ReadAdminChat");
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler o chat de Administra��o.");
            format(_string, 128, "%s (%d) desativou a leitura do chat administrativo.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
        else
        {
            SetPVarInt(playerid, "ReadAdminChat", 1);
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler o chat de Administra��o.");
            format(_string, 128, "%s (%d) ativou a leitura do chat administrativo.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
    return 1;
}

CMD:law(playerid, params[])
    return cmd_leradminwarning(playerid, params);

CMD:leradminwarning(playerid, params[]) {
    format(_largestring, 1280, "%s - /leradminwarning %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(playerid, "ReadAdminWarning"))
        {
            DeletePVar(playerid, "ReadAdminWarning");
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler os avisos administrativos.");
            format(_string, 128, "%s (%d) desativou a leitura dos avisos administrativos.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
        else
        {
            SetPVarInt(playerid, "ReadAdminWarning", 1);
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler os avisos administrativos.");
            format(_string, 128, "%s (%d) ativou a leitura dos avisos administrativos.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
    }
	return 1;
}

CMD:lsw(playerid, params[])
    return cmd_lersystemwarning(playerid, params);

CMD:lersystemwarning(playerid, params[]) {
    format(_largestring, 1280, "%s - /lersystemwarning %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(playerid, "ReadSystemWarning"))
        {
            DeletePVar(playerid, "ReadSystemWarning");
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� n�o ir� mais ler os avisos do sistema.");
            format(_string, 128, "%s (%d) desativou a leitura dos avisos do sistema.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
        else
        {
            SetPVarInt(playerid, "ReadSystemWarning", 1);
            SendWarningMessage(playerid, COLOR_GRAD2, "Voc� passou a ler os avisos do sistema.");
            format(_string, 128, "%s (%d) ativou a leitura dos avisos do sistema.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
        }
    }
	return 1;
}

CMD:ver(playerid, params[])
{
    format(_largestring, 1280, "%s - /ver %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("ver", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(IsPlayerInRangeOfPlayer(playerid, otherplayerid, 5))
    {
        SetPVarInt(playerid, "PlayerSeen", otherplayerid);
        ShowPlayerDialog(playerid, DIALOG_PLAYERDESCRIPTION, DIALOG_STYLE_LIST, "Informa��es", "Altura\nPeso\nTatuagens\nCor do Cabelo\nCor de Pele\nBarba\nOutras descri��es\nCor dos Olhos\nDefini��o Corporal", "Ok", "Sair");
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:ame(playerid, params[])
{
    format(_largestring, 1280, "%s - /ame %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("ame", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    format(_string, sizeof(_string), "* %s %s", ReturnPlayerNameEx(playerid), text);
    SendClientMessage(playerid, COLOR_PURPLE, _string);
    new stringfull[192];
    new lengths[96];
    new length2[96];
    strmid(stringfull, _string, 0, 192);
    strmid(lengths, stringfull, 0, 96);
    strmid(length2, _string, 95, 192);
    if(strlen(_string) > 96)
    {
        new message[192];
        format(message, 192, "%s...\n...%s", lengths,length2);
        SetPlayerChatBubble(playerid, _string, COLOR_PURPLE, 15, 15000);
    }
    else
    {
        SetPlayerChatBubble(playerid, _string, COLOR_PURPLE, 15, 15000);
	}
    SendActionMessage(playerid, COLOR_OOC, _string);
    return 1;
}

CMD:me(playerid, params[])
{
    format(_largestring, 1280, "%s - /me %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("me", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    format(_string, sizeof(_string), "* %s %s", ReturnPlayerNameEx(playerid), text);
    nearByMessage(playerid, COLOR_PURPLE, _string, 15);
    return 1;
}

CMD:do(playerid, params[])
{
    format(_largestring, 1280, "%s - /do %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("do", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    format(_string, sizeof(_string), "* %s (%s)", text, ReturnPlayerNameEx(playerid));
    nearByMessage(playerid, COLOR_PURPLE, _string, 15);
    return 1;
}

CMD:l(playerid, params[])
    return cmd_falar(playerid, params);

CMD:falar(playerid, params[])
{
    format(_largestring, 1280, "%s - /falar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("falar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_string, 128, "%s [Sotaque %s] diz: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, _string, 10.0);
    }
    else
    {
        format(_string, 128, "%s diz: %s", ReturnPlayerNameEx(playerid), text);
        nearByMessage(playerid, COLOR_FADE1, _string, 10.0);
    }
    return 1;
}

CMD:b(playerid, params[])
{
    format(_largestring, 1280, "%s - /b %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new result[128];
    if (sscanf(params, "s[128]", result))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("b", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(GetPVarInt(playerid, "AdminDuty"))
    {
        format(_largestring, 200, "(( Admin %s [%d]: %s ))", ReturnPlayerNameEx(playerid), playerid, result);
        nearByMessage(playerid, COLOR_YELLOW, _string, 20.0);
    }
    else
    {
        format(_largestring, 200, "(( %s [%d]: %s ))", ReturnPlayerNameEx(playerid), playerid, result);
        nearByMessage(playerid, COLOR_GREY, _string, 20.0);
    }
    return 1;
}

CMD:ba(playerid, params[])
    return cmd_baixo(playerid, params);

CMD:baixo(playerid, params[])
{
    format(_largestring, 1280, "%s - /baixo %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("baixo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
	if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_largestring, 200, "%s [Sotaque %s] diz, em tom baixo: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 5.0);
    }
    else
    {
        format(_largestring, 200, "%s diz, em tom baixo: %s", ReturnPlayerNameEx(playerid), text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 5.0);
    }
    return 1;
}

CMD:g(playerid, params[])
    return cmd_gritar(playerid, params);

CMD:gritar(playerid, params[])
{
    format(_largestring, 1280, "%s - /gritar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("gritar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
	if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_largestring, 200, "%s [Sotaque %s] grita: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 20.0);
    }
    else
    {
        format(_largestring, 200, "%s grita: %s", ReturnPlayerNameEx(playerid), text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 20.0);
    }
    return 1;
}

CMD:frequencia(playerid, params[])
    return cmd_freq(playerid, params);

CMD:canal(playerid, params[])
    return cmd_freq(playerid, params);

CMD:freq(playerid, params[])
{
    format(_largestring, 1280, "%s - /freq %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new hz;
    if (sscanf(params, "d", hz) || hz < 1 || hz > 10)
    {
        format(_string, sizeof (_string), "\"/%s [canal]\"", Command_GetDisplayNamed("freq", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    PlayerInfo[playerid][pRadioFreq] = hz;
    format(_string, 128, "Voc� colocou o seu r�dio no canal #%d", hz);
    SendActionMessage(playerid, -1, _string);
    format(_string, 128, "* %s recolhe seu r�dio de m�o, e seleciona um canal no mesmo. ", ReturnPlayerNameEx(playerid));
    nearByMessage(playerid, -1, _string);
    return 1;
}

CMD:walkie(playerid, params[])
    return cmd_wt(playerid, params);

CMD:wt(playerid, params[])
{
    format(_largestring, 1280, "%s - /wt %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("freq", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_largestring, 200, "** %s [Sotaque %s]: %s **", PlayerInfo[playerid][pRadioAlias], PlayerInfo[playerid][pSotaque], text);
        SendWalkieMessage(PlayerInfo[playerid][pRadioFreq], 0x8D8DFFFF, _largestring);
    }
    else
    {
        format(_largestring, 200, "** %s: %s **", PlayerInfo[playerid][pRadioAlias], text);
        SendWalkieMessage(PlayerInfo[playerid][pRadioFreq], 0x8D8DFFFF, _largestring);
    }
    if(PlayerInfo[playerid][pRadioFreq] > 1 || PlayerInfo[playerid][pRadioFreq] < 10)
	{
        if(GetPVarInt(playerid, "SotaqueOn"))
        {
            format(_largestring, 200, "%s [Sotaque %s] diz, no r�dio: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
            nearByMessage(playerid, COLOR_FADE1, _largestring, 10.0);
        }
        else
        {
            format(_largestring, 200, "%s diz, no r�dio: %s", ReturnPlayerNameEx(playerid), text);
            nearByMessage(playerid, COLOR_FADE1, _largestring, 10.0);
        }
    }
    else return SendErrorMessage(playerid, -1, "Voc� n�o selecionou uma frequ�ncia para falar.");
    return 1;
}

CMD:r(playerid, params[])
    return cmd_radio(playerid, params);

CMD:radio(playerid, params[])
{
    format(_largestring, 1280, "%s - /radio %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("radio", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pFaction] > 0)
	{
        if(GetPVarInt(playerid, "SotaqueOn"))
        {
        format(_largestring, 200, "%s [Sotaque %s] diz, no r�dio: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 10.0);
        }
        else
        {
            format(_largestring, 200, "%s diz, no r�dio: %s", ReturnPlayerNameEx(playerid), text);
            nearByMessage(playerid, COLOR_FADE1, _largestring, 10.0);
        }
    }
    else return SendErrorMessage(playerid, -1, "Voc� n�o tem um r�dio desse tipo.");
    if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_largestring, 200, "** %s [Sotaque %s]: %s **", PlayerInfo[playerid][pOfficialAlias], PlayerInfo[playerid][pSotaque], text);
        SendRadioMessage(PlayerInfo[playerid][pFaction], 0x8D8DFFFF, _largestring);
    }
    else
    {
        format(_largestring, 200, "** %s %s **", PlayerInfo[playerid][pOfficialAlias], text);
        SendRadioMessage(PlayerInfo[playerid][pFaction], 0x8D8DFFFF, _largestring);
    }
    return 1;
}

CMD:mp(playerid, params[])
    return cmd_pm(playerid, params);

CMD:pm(playerid, params[])
{
    format(_largestring, 1280, "%s - /pm %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new text[128], otherplayerid;
    if (sscanf(params, "us[128]", otherplayerid, text))
    {
        format(_string, sizeof (_string), "\"/%s [id/nome] [texto]\"", Command_GetDisplayNamed("pm", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
	if(GetPVarInt(playerid, "PM") && GetPVarInt(otherplayerid, "PM"))
	{
        foreach(Player, i)
        {
            if(GetPVarInt(i, "LerPM"))
            {
                format(_string, 128, "MP de \"%s\" (%d) para \"%s\" (%d)", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
                SendClientMessage(i, COLOR_YELLOW, _string);
                format(_string, 128, "\"%s\"", text);
                SendClientMessage(i, COLOR_YELLOW, _string);
                return 1;
            }
        }
        new stringfull[128];
        new lengths[128];
        new length2[128];
        strmid(stringfull, text, 0, 128);
        strmid(lengths, stringfull, 0, 73);
        strmid(length2, text, 72, 128);
        if(strlen(text) > 72)
        {
            format(_string, 128, "MP de \"%s\" (%d): \"%s ...", ReturnPlayerNameEx(playerid), playerid, lengths);
            SendClientMessage(otherplayerid, COLOR_YELLOW, _string);
            format(_string, 128, "... %s\"", length2);
            SendClientMessage(otherplayerid, COLOR_YELLOW, _string);
            format(_string, 128, "MP enviada para \"%s\" (%d): \"%s ...", ReturnPlayerNameEx(otherplayerid), otherplayerid, lengths);
            SendClientMessage(playerid, COLOR_YELLOW, _string);
            format(_string, 128, "... %s\"", length2);
            SendClientMessage(playerid, COLOR_YELLOW, _string);
            return 1;
        }
        else
        {
            format(text, 128, "MP de \"%s\" (%d): \"%s\"", ReturnPlayerNameEx(playerid), playerid, text);
            SendClientMessage(otherplayerid, COLOR_YELLOW, _string);
            format(_string, 128, "MP enviada para \"%s\" (%d): \"%s", ReturnPlayerNameEx(otherplayerid), otherplayerid, lengths);
            SendClientMessage(playerid, COLOR_YELLOW, _string);
            return 1;
        }
    }
    else SendErrorMessage(playerid, -1, "Voc� ou a pessoa a qual voc� quer mandar uma PM n�o est�o com as PM's ativadas!");
    return 1;
}

CMD:s(playerid, params[])
    return cmd_sussurrar(playerid, params);

CMD:sussurrar(playerid, params[])
{
    format(_largestring, 1280, "%s - /sussurrar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("sussurrar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
	if(GetPVarInt(playerid, "SotaqueOn"))
    {
        format(_largestring, 200, "%s [Sotaque %s] diz, sussurrando: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 2.5);
    }
    else
    {
        format(_largestring, 200, "%s diz, sussurrando: %s", ReturnPlayerNameEx(playerid), text);
        nearByMessage(playerid, COLOR_FADE1, _largestring, 2.5);
    }
    return 1;
}

CMD:cs(playerid, params[])
    return cmd_carrosussurrar(playerid, params);

CMD:cw(playerid, params[])
    return cmd_carrosussurrar(playerid, params);

CMD:carrosussurrar(playerid, params[])
{
    format(_largestring, 1280, "%s - /carrosussurrar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("sussurrar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    foreach(Player, i)
	{
        if(IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, -1, "Voc� n�o pode usar isso fora de um carro.");
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
        {
            if(GetPVarInt(playerid, "SotaqueOn"))
            {
                new stringfull[128];
                new lengths[128];
                new length2[128];
                strmid(stringfull, text, 0, 128);
                strmid(lengths, stringfull, 0, 45);
                strmid(length2, text, 44, 128);
                if(strlen(text) > 44)
                {
                    format(_string, 128, "%s [Sotaque %s] diz, sussurrando: %s ...", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], lengths);
                    SendClientMessage(i, -1, _string);
                    format(_string, 128, "... %s", length2);
                    SendClientMessage(i, -1, _string);
                    return 1;
                }
                else
                {
                    format(_string, 128, "%s [Sotaque %s] diz, sussurrando: %s", ReturnPlayerNameEx(playerid), PlayerInfo[playerid][pSotaque], text);
                    SendClientMessage(i, -1, _string);
                    return 1;
                }
            }
            else
            {
                new stringfull[128];
                new lengths[128];
                new length2[128];
                strmid(stringfull, text, 0, 128);
                strmid(lengths, stringfull, 0, 79);
                strmid(length2, text, 78, 192);
                if(strlen(text) > 78)
                {
                    format(_string, 128, "%s diz, sussurrando: %s ...", ReturnPlayerNameEx(playerid), lengths);
                    SendClientMessage(i, -1, _string);
                    format(_string, 128, "... %s", length2);
                    SendClientMessage(i, -1, _string);
                    return 1;
                }
                else
                {
                    format(_string, 128, "%s diz, sussurrando: %s", ReturnPlayerNameEx(playerid), text);
                    SendClientMessage(i, -1, _string);
                    return 1;
                }
            }
        }
    }
    return 1;
}

CMD:a(playerid, params[])
    return cmd_admin(playerid, params);

CMD:admin(playerid, params[])
{
    format(_largestring, 1280, "%s - /a %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("admin", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        format(_string, sizeof(_string), "** %s [%d]: %s **", ReturnPlayerNameEx(playerid), playerid, text);
        AdminChat(COLOR_OOC, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:setarhoras(playerid, params[])
    return cmd_tod(playerid, params);

CMD:tod(playerid, params[])
{
    format(_largestring, 1280, "%s - /tod %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new hour;
    if (sscanf(params, "d", hour) || hour < 0 || hour > 24)
    {
        format(_string, sizeof (_string), "\"/%s [horas]\"", Command_GetDisplayNamed("tod", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        SetWorldTime(hour);
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s acaba de mudar as horas para {0064FF}%d{AFAFAF}!", ReturnPlayerNameEx(playerid), hour);
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:daradmin(playerid, params[])
{
    format(_largestring, 1280, "%s - /daradmin %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new level, otherplayerid;
    if (sscanf(params, "ud", otherplayerid, level) || level < 0)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [n�vel]\"", Command_GetDisplayNamed("daradmin", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
        PlayerInfo[otherplayerid][pAdmin] = level;
        format(_string, 128, "%s (%d) deu a %s (%d) o n�vel %d de administra��o.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, level);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu o n�vel %d de administra��o.", ReturnPlayerNameEx(playerid), playerid, level);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:darlider(playerid, params[])
{
    format(_largestring, 1280, "%s - /darlider %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, faction;
    if (sscanf(params, "ud", otherplayerid, faction) || faction < 0 || faction > MAX_FACTIONS)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [n�vel]\"", Command_GetDisplayNamed("darlider", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
        PlayerInfo[otherplayerid][pFaction] = faction;
        PlayerInfo[otherplayerid][pRank] = 10;
        format(_string, 128, "%s (%d) deu a %s (%d) a lideran�a da fac��o %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, FactionInfo[faction][fName], faction);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu a lideran�a da fac��o %s (%d).", ReturnPlayerNameEx(playerid), playerid, FactionInfo[faction][fName], faction);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:irlv(playerid, params[])
{
    format(_largestring, 1280, "%s - /irlv %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("irlv", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if (GetPlayerState(playerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid), 1699.2, 1435.1, 10.7);
		else SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
        if(otherplayerid == playerid) format(_string, 128, "%s (%d) foi at� Las Venturas.", ReturnPlayerNameEx(playerid), playerid);
        else format(_string, 128, "%s (%d) levou %s (%d) at� Las Venturas.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe mandou para Las Venturas.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:ir(playerid, params[])
{
    format(_largestring, 1280, "%s - /ir %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:plocx, Float:plocy, Float:plocz;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("ir", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        GetPlayerPos(otherplayerid, plocx, plocy, plocz);
		if(PlayerInfo[otherplayerid][pInt] > 0)
		{
			SetPlayerInterior(playerid,PlayerInfo[otherplayerid][pInt]);
            SetPlayerVirtualWorld(playerid,PlayerInfo[otherplayerid][pVirWorld]);
            PlayerInfo[playerid][pVirWorld] = PlayerInfo[otherplayerid][pVirWorld];
		}
		if (GetPlayerState(otherplayerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid), plocx, plocy+4, plocz);
		else SetPlayerPos(playerid,plocx,plocy+2, plocz);
        format(_string, 128, "%s (%d) foi/se teletransportou at� %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) se teletransportou at� voc�.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:puxar(playerid, params[])
    return cmd_trazer(playerid, params);

CMD:trazer(playerid, params[])
{
    format(_largestring, 1280, "%s - /trazer %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:plocx, Float:plocy, Float:plocz;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("trazer", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        GetPlayerPos(playerid, plocx, plocy, plocz);
		if(PlayerInfo[playerid][pInt] > 0)
		{
			SetPlayerInterior(otherplayerid,PlayerInfo[playerid][pInt]);
            SetPlayerVirtualWorld(otherplayerid,PlayerInfo[playerid][pVirWorld]);
            PlayerInfo[otherplayerid][pVirWorld] = PlayerInfo[playerid][pVirWorld];
		}
		if (GetPlayerState(otherplayerid) == 2) SetVehiclePos(GetPlayerVehicleID(otherplayerid), plocx, plocy+4, plocz);
		else SetPlayerPos(playerid,plocx,plocy+2, plocz);
        format(_string, 128, "%s (%d) puxou/trouxe %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe trouxe/puxou.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:ircarro(playerid, params[])
    return cmd_irveiculo(playerid, params);

CMD:irc(playerid, params[])
    return cmd_irveiculo(playerid, params);

CMD:irv(playerid, params[])
    return cmd_irveiculo(playerid, params);

CMD:irveiculo(playerid, params[])
{
    format(_largestring, 1280, "%s - /irveiculo %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new vehicleid, Float:vlocx, Float:vlocy, Float:vlocz;
    if (sscanf(params, "i", vehicleid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("irveiculo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(CarInfo[vehicleid][cModel] < 400) return SendErrorMessage(playerid, -1, "Este ve�culo n�o existe!");
        GetVehiclePos(vehicleid, vlocx, vlocy, vlocz);
	    if(CarInfo[vehicleid][cInt] > 0)
		{
            if (GetPlayerState(playerid) == 2)
            {
                SetVehiclePos(GetPlayerVehicleID(playerid), vlocx, vlocy+4, vlocz);
                LinkVehicleToInterior(GetPlayerVehicleID(playerid), CarInfo[vehicleid][cInt]);
                SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), CarInfo[vehicleid][cVW]);
            }
            SetPlayerInterior(playerid,CarInfo[vehicleid][cInt]);
            SetPlayerVirtualWorld(playerid,CarInfo[vehicleid][cVW]);
            PlayerInfo[playerid][pVirWorld] = CarInfo[vehicleid][cVW];
		}
		SetPlayerPos(playerid,vlocx,vlocy+2, vlocz);
        format(_string, 128, "%s (%d) foi at� um/uma %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid);
        AdminWarning(COLOR_YELLOW, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:puxarveiculo(playerid, params[])
    return cmd_puxarcarro(playerid, params);

CMD:pv(playerid, params[])
    return cmd_puxarcarro(playerid, params);

CMD:puxarcarro(playerid, params[])
{
    format(_largestring, 1280, "%s - /trazerveiculo %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new vehicleid, Float:vlocx, Float:vlocy, Float:vlocz;
    if (sscanf(params, "i", vehicleid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("trazerveiculo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(CarInfo[vehicleid][cModel] < 400) return SendErrorMessage(playerid, -1, "Este ve�culo n�o existe!");
        GetPlayerPos(vehicleid, vlocx, vlocy, vlocz);
	    if(PlayerInfo[playerid][pInt] > 0)
		{
            SetVehiclePos(vehicleid, vlocx, vlocy+4, vlocz);
            CarInfo[vehicleid][cInt] = PlayerInfo[playerid][pInt];
            LinkVehicleToInterior(vehicleid, CarInfo[vehicleid][cInt]);
            CarInfo[vehicleid][cVW] = PlayerInfo[playerid][pVirWorld];
            SetVehicleVirtualWorld(vehicleid, CarInfo[vehicleid][cVW]);
            foreach(Player, i)
            {
                if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
                {
                    SetPlayerInterior(playerid,CarInfo[vehicleid][cInt]);
                    SetPlayerVirtualWorld(playerid,CarInfo[vehicleid][cVW]);
                    PlayerInfo[playerid][pVirWorld] = CarInfo[vehicleid][cVW];
                }
            }
		}
        format(_string, 128, "%s (%d) trouxe/puxou um/uma %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid);
        AdminWarning(COLOR_YELLOW, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}


CMD:lastcar(playerid, params[])
    return cmd_veiculoanterior(playerid, params);

CMD:oldcar(playerid, params[])
    return cmd_veiculoanterior(playerid, params);

CMD:oldveh(playerid, params[])
    return cmd_veiculoanterior(playerid, params);

CMD:veiculoanterior(playerid, params[]) {
    format(_largestring, 1280, "%s - /veiculoanterior %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    format(_string, sizeof(_string), "O �ltimo carro no qual voc� entrou foi um/uma %s (%d)", ReturnVehicleNameID(GetPVarInt(playerid, "LastCar")), GetPVarInt(playerid, "LastCar"));
    SendWarningMessage(playerid, -1, _string);
    return 1;
}

CMD:dararma(playerid, params[])
{
    format(_largestring, 1280, "%s - /dararma %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, weapon, ammo;
    if (sscanf(params, "udd", otherplayerid, weapon, ammo) || weapon < 0 || weapon > 46 || ammo < 0)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [arma] [muni��o]\"", Command_GetDisplayNamed("dararma", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 4)
    {
        if(PlayerInfo[otherplayerid][pGun1] > 0 && PlayerInfo[otherplayerid][pGun2] > 0 && PlayerInfo[otherplayerid][pGun3] > 0) return SendErrorMessage(playerid, -1, "O jogador j� tem tr�s armas!");
        GivePlayerWeaponEx(playerid, weapon, ammo);
        format(_string, 128, "%s (%d) deu a %s (%d) uma %s (%d) com %d balas.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, ReturnWeaponName(weapon), weapon, ammo);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu uma %s (%d) com %d balas.", ReturnPlayerNameEx(playerid), playerid, ReturnWeaponName(weapon), weapon, ammo);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:darvida(playerid, params[])
{
    format(_largestring, 1280, "%s - /darvida %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:vida, Float:oldvida;
    if (sscanf(params, "uf", otherplayerid, vida))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("darvida", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 4)
    {
        GetPlayerHealth(otherplayerid, oldvida);
        SetPlayerHealth(otherplayerid, oldvida+vida);
        format(_string, 128, "%s (%d) deu a %s (%d) %.00f de vida. Total: %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, vida, oldvida+vida);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu %.00f de vida. Sua vida total: %.00f.", ReturnPlayerNameEx(playerid), playerid, vida, oldvida+vida);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:setarvida(playerid, params[])
{
    format(_largestring, 1280, "%s - /setarvida %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:vida;
    if (sscanf(params, "uf", otherplayerid, vida) || vida < 0)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("setarvida", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        SetPlayerHealth(otherplayerid, vida);
        format(_string, 128, "%s (%d) definiu/setou a %s (%d) %.00f de vida.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, vida);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) definiu/setou a sua vida para %.00f.", ReturnPlayerNameEx(playerid), playerid, vida);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:enchervida(playerid, params[])
{
    format(_largestring, 1280, "%s - /enchervida %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("setarvida", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 2)
    {
        SetPlayerHealth(otherplayerid, 100);
        format(_string, 128, "%s (%d) encheu a vida de %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) encheu sua vida.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:enchercolete(playerid, params[])
{
    format(_largestring, 1280, "%s - /enchercolete %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("setarvida", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 2)
    {
        SetPlayerArmour(otherplayerid, 100);
        format(_string, 128, "%s (%d) encheu o colete de %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) encheu o seu colete.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:darcolete(playerid, params[])
{
    format(_largestring, 1280, "%s - /darcolete %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:colete, Float:oldcolete;
    if (sscanf(params, "uf", otherplayerid, colete))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("darcolete", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 4)
    {
        GetPlayerArmour(otherplayerid, oldcolete);
        SetPlayerArmour(otherplayerid, oldcolete+colete);
        format(_string, 128, "%s (%d) deu a %s (%d) %.00f de colete. Total: %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid, colete, oldcolete+colete);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu %.00f de colete. Seu colete total: %.00f.", ReturnPlayerNameEx(playerid), playerid, colete, oldcolete+colete);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:setarcolete(playerid, params[])
{
    format(_largestring, 1280, "%s - /setarcolete %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:colete;
    if (sscanf(params, "uf", otherplayerid, colete) || colete < 0)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("setarcolete", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        SetPlayerArmour(otherplayerid, colete);
        format(_string, 128, "%s (%d) definiu/setou a %s (%d) %.00f de colete.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) definiu/setou o seu colete para %.00f.", ReturnPlayerNameEx(playerid), playerid, colete);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:arrumarveiculo(playerid, params[])
    return cmd_repararveiculo(playerid, params);

CMD:rv(playerid, params[])
    return cmd_repararveiculo(playerid, params);

CMD:repararveiculo(playerid, params[])
{
    format(_largestring, 1280, "%s - /repararveiculo %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new vehicleid;
    if (sscanf(params, "i", vehicleid))
    {
        format(_string, sizeof (_string), "\"/%s [ve�culo]\"", Command_GetDisplayNamed("repararveiculo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(CarInfo[vehicleid][cModel] < 400) return SendErrorMessage(playerid, -1, "Este ve�culo n�o existe!");
        RepairVehicle(vehicleid);
		SetVehicleHealth(vehicleid, 1000.0);
        format(_string, 128, "%s (%d) reparou um/uma %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid);
        AdminWarning(COLOR_YELLOW, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:arrumarveiculoplayer(playerid, params[])
    return cmd_repararveiculoplayer(playerid, params);

CMD:rvp(playerid, params[])
    return cmd_repararveiculoplayer(playerid, params);

CMD:repararveiculoplayer(playerid, params[])
{
    format(_largestring, 1280, "%s - /repararveiculoplayer %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, vehicleid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("repararveiculo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, -1, "O jogador n�o est� em um ve�culo!");
        vehicleid = GetPlayerVehicleID(otherplayerid);
        RepairVehicle(vehicleid);
        format(_string, 128, "%s (%d) reparou um/uma %s (%d) totalmente. Motorista: %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) reparou seu ve�culo totalmente.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:dvc(playerid, params[])
    return cmd_darvidacarro(playerid, params);

CMD:darvidacarro(playerid, params[])
{
    format(_largestring, 1280, "%s - /darvidacarro %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new vehicleid, Float:vida, Float:oldvida;
    if (sscanf(params, "if", vehicleid, vida))
    {
        format(_string, sizeof (_string), "\"/%s [ve�culo] [quantidade]\"", Command_GetDisplayNamed("darvidacarro", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        if(CarInfo[vehicleid][cModel] < 400) return SendErrorMessage(playerid, -1, "Este ve�culo n�o existe!");
        GetVehicleHealth(vehicleid, oldvida);
        SetVehicleHealth(vehicleid, oldvida+vida);
        format(_string, 128, "%s (%d) deu a um/uma %s (%d) %.00f de vida. Total: %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, vida, oldvida+vida);
        AdminWarning(COLOR_YELLOW, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:svc(playerid, params[])
    return cmd_setarvidacarro(playerid, params);

CMD:setarvidacarro(playerid, params[])
{
    format(_largestring, 1280, "%s - /setarvidacarro %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new vehicleid, Float:vida;
    if (sscanf(params, "if", vehicleid, vida) || vida < 0)
    {
        format(_string, sizeof (_string), "\"/%s [ve�culo] [quantidade]\"", Command_GetDisplayNamed("setarvidacarro", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 2)
    {
        if(CarInfo[vehicleid][cModel] < 400) return SendErrorMessage(playerid, -1, "Este ve�culo n�o existe!");
        SetVehicleHealth(vehicleid, vida);
        format(_string, 128, "%s (%d) definiu/setou a vida de um/uma %s (%d) para %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, vida);
        AdminWarning(COLOR_YELLOW, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:dvcp(playerid, params[])
    return cmd_darvidacarroplayer(playerid, params);

CMD:darvidacarroplayer(playerid, params[])
{
    format(_largestring, 1280, "%s - /darvidacarroplayer %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, vehicleid, Float:vida, Float:oldvida;
    if (sscanf(params, "uf", otherplayerid, vida))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("darvidacarroplayer", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, -1, "O jogador n�o est� em um ve�culo!");
        vehicleid = GetPlayerVehicleID(otherplayerid);
        GetVehicleHealth(vehicleid, oldvida);
        SetVehicleHealth(vehicleid, oldvida+vida);
        format(_string, 128, "%s (%d) deu a um/uma %s (%d), dirigida por \"%s\" (%d), %.00f de vida. Total: %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, ReturnPlayerNameEx(otherplayerid), otherplayerid, vida);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) deu ao seu/sua %s (%d) %.00f de vida. Total de vida de seu ve�culo: %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, vida, oldvida+vida);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:svcp(playerid, params[])
    return cmd_setarvidacarroplayer(playerid, params);

CMD:setarvidacarroplayer(playerid, params[])
{
    format(_largestring, 1280, "%s - /setarvidacarroplayer %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, vehicleid, Float:vida;
    if (sscanf(params, "uf", otherplayerid, vehicleid) || vida < 0)
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [quantidade]\"", Command_GetDisplayNamed("setarvidacarroplayer", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 2)
    {
        if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, -1, "O jogador n�o est� em um ve�culo!");
        vehicleid = GetPlayerVehicleID(otherplayerid);
        SetVehicleHealth(vehicleid, vida);
        format(_string, 128, "%s (%d) definiu a vida de um/uma %s (%d), dirigida por \"%s\" (%d), para %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, ReturnPlayerNameEx(otherplayerid), otherplayerid, vida);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) definiu/setou a vida de seu/sua %s (%d) para %.00f.", ReturnPlayerNameEx(playerid), playerid, ReturnVehicleNameID(vehicleid), vehicleid, vida);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:clima(playerid, params[])
    return cmd_tempo(playerid, params);

CMD:tempo(playerid, params[])
{
    format(_largestring, 1280, "%s - /tempo %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new weather;
    if (sscanf(params, "d", weather) || weather < 0)
    {
        format(_string, sizeof (_string), "\"/%s [clima]\"", Command_GetDisplayNamed("tempo", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        SetWeather(weather);
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s acaba de mudar o clima para o clima{0064FF}%d{AFAFAF}!", weather);
        OOCMessage(COLOR_OOC, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:tapa(playerid, params[])
{
    format(_largestring, 1280, "%s - /tapa %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, Float:vida, Float:slx, Float:sly, Float:slz;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("tapa", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        GetPlayerHealth(otherplayerid, vida);
		SetPlayerHealth(otherplayerid, vida-5);
		GetPlayerPos(otherplayerid, slx, sly, slz);
		SetPlayerPos(otherplayerid, slx, sly, slz+5);
		PlayerPlaySound(otherplayerid, 1130, slx, sly, slz+5);
		format(_string, 128, "%s (%d) deu um tapa em %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        format(_string, 128, "%s (%d) lhe deu um tapa.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:mute(playerid, params[])
    return cmd_calar(playerid, params);

CMD:mutar(playerid, params[])
    return cmd_calar(playerid, params);

CMD:calar(playerid, params[])
{
    format(_largestring, 1280, "%s - /calar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("calar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(otherplayerid, "Muted"))
        {
            format(_string, 128, "%s (%d) liberou %s (%d) para falar novamente.", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
            AdminWarning(COLOR_YELLOW, _string);
            format(_string, 128, "%s (%d) lhe liberou para falar novamente.", ReturnPlayerNameEx(playerid), playerid);
            SendWarningMessage(otherplayerid, -1, _string);
        }
        else
        {
            format(_string, 128, "%s (%d) proibiu de falar/calou %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
            AdminWarning(COLOR_YELLOW, _string);
            format(_string, 128, "%s (%d) lhe proibiu de falar novamente/calou.", ReturnPlayerNameEx(playerid), playerid);
            SendWarningMessage(otherplayerid, -1, _string);
        }
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:kick(playerid, params[])
{
    format(_largestring, 1280, "%s - /kick %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("kick", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            format(_string, sizeof(_string), "%s kickou %s do serivor. Motivo n�o informado.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            KickLog(_string);
            Kick(otherplayerid);
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s kickou %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        KickLog(_string);
        Kick(otherplayerid);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:fakekick(playerid, params[])
{
    format(_largestring, 1280, "%s - /fakekick %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("fakekick", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:fakekickmsg(playerid, params[])
{
    format(_largestring, 1280, "%s - /fakekickmsg %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("fakekickmsg", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            SendClientMessage(otherplayerid, 0xA9C4E4AA, "Server closed the connection.");
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s kickou %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        SendClientMessage(otherplayerid, 0xA9C4E4AA, "Server closed the connection.");
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:ban(playerid, params[])
{
    format(_largestring, 1280, "%s - /ban %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("ban", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            format(_string, sizeof(_string), "%s baniu %s do serivor. Motivo n�o informado.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            BanLog(_string);
            Ban(otherplayerid);
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s baniu %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        BanLog(_string);
        Kick(otherplayerid);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:fakeban(playerid, params[])
{
    format(_largestring, 1280, "%s - /fakeban %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("fakeban", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:fakebankick(playerid, params[])
{
    format(_largestring, 1280, "%s - /fakebankick %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("fakebankick", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            format(_string, sizeof(_string), "%s kickou %s do serivor por meio de /fakebankick. Motivo n�o informado.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            KickLog(_string);
            Kick(otherplayerid);
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        format(_string, sizeof(_string), "%s kickou %s do serivor por meio de /fakebankick. Motivo: \"%s\".", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        KickLog(_string);
        Kick(otherplayerid);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:fakebanmsg(playerid, params[])
{
    format(_largestring, 1280, "%s - /fakekickmsg %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid, reason[128];
    if (!strval(params))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id] [raz�o - opcional]\"", Command_GetDisplayNamed("fakekickmsg", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    sscanf(params, "us[128]", otherplayerid, reason);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(!strval(reason))
        {
            format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor.", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid));
            Broadcast(COLOR_SYSTEM, _string);
            SendClientMessage(otherplayerid, 0xA9C4E4AA, "Server closed the connection.");
            return 1;
        }
        format(_string, sizeof(_string), "{AFAFAF}[{FF9900}!{AFAFAF}] %s baniu %s do serivor. Motivo: \"%s\"", ReturnPlayerNameEx(playerid), ReturnPlayerNameEx(otherplayerid), reason);
        Broadcast(COLOR_SYSTEM, _string);
        SendClientMessage(otherplayerid, 0xA9C4E4AA, "Server closed the connection.");
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:congelar(playerid, params[])
{
    format(_largestring, 1280, "%s - /congelar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("congelar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(otherplayerid, "Frozen"))
        {
            format(_string, 128, "%s (%d) descongelou %s (%d)", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
            AdminWarning(COLOR_YELLOW, _string);
            DeletePVar(otherplayerid, "Frozen");
            TogglePlayerControllable(playerid, 1);
            format(_string, 128, "%s (%d) lhe descongelou.", ReturnPlayerNameEx(playerid), playerid);
            SendWarningMessage(otherplayerid, -1, _string);
        }
        else
        {
            format(_string, 128, "%s (%d) congelou %s (%d).", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
            AdminWarning(COLOR_YELLOW, _string);
            SetPVarInt(otherplayerid, "Frozen", 1);
            TogglePlayerControllable(playerid, 0);
            format(_string, 128, "%s (%d) lhe congelou.", ReturnPlayerNameEx(playerid), playerid);
            SendWarningMessage(otherplayerid, -1, _string);
        }
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:descongelar(playerid, params[])
{
    format(_largestring, 1280, "%s - /descongelar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    new otherplayerid;
    if (sscanf(params, "u", otherplayerid))
    {
        format(_string, sizeof (_string), "\"/%s [nome/id]\"", Command_GetDisplayNamed("descongelar", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        format(_string, 128, "%s (%d) descongelou %s (%d)", ReturnPlayerNameEx(playerid), playerid, ReturnPlayerNameEx(otherplayerid), otherplayerid);
        AdminWarning(COLOR_YELLOW, _string);
        DeletePVar(otherplayerid, "Frozen");
        TogglePlayerControllable(playerid, 1);
        format(_string, 128, "%s (%d) lhe descongelou.", ReturnPlayerNameEx(playerid), playerid);
        SendWarningMessage(otherplayerid, -1, _string);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:GMX(playerid, params[])
{
    format(_largestring, 1280, "%s - /gmx %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
        format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] %s inicializou um rein�cio do servidor.", ReturnPlayerNameEx(playerid));
        Broadcast(COLOR_YELLOW, _string);
        format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] Em quinze segundos, todos ser�o removidos do servidor.", ReturnPlayerNameEx(playerid));
        Broadcast(COLOR_YELLOW, _string);
        format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] Seus dados ser�o salvos nesse per�odo. Por precau��o, tire uma SS do seu /stats AGORA.", ReturnPlayerNameEx(playerid));
        Broadcast(COLOR_YELLOW, _string);
        format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] E deslogue, para ter certeza de que sua conta foi salva.", ReturnPlayerNameEx(playerid));
        printf("[SYS]: %s iniciou um GMX.", ReturnPlayerNameEx(playerid));
        SetTimer("GameModeExitFunc", 15000, 0);
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:admins(playerid, params[])
{
    format(_largestring, 1280, "%s - /admins %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}!{AFAFAF}] Pessoal Administrativo Online {AFAFAF}[{A9C4E4}!{AFAFAF}]");
    foreach(Player, i)
    {
        if(PlayerInfo[i][pAdmin] >= 1)
        {
            if(GetPVarInt(playerid, "AdminDuty")) format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] %s (%d) - N�vel %d - {00CF00}EM TRABALHO ADMINISTRATIVO{AFAFAF}.", ReturnPlayerNameEx(i), i, PlayerInfo[i][pAdmin]);
            else format(_string, 128, "{AFAFAF}[{A9C4E4}!{AFAFAF}] %s (%d) - N�vel %d - {CF0000}FORA DE TRABALHO ADMINISTRATIVO{AFAFAF}.", ReturnPlayerNameEx(i), i, PlayerInfo[i][pAdmin]);
            SendClientMessage(playerid, COLOR_YELLOW, _string);
        }
    }
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}!{AFAFAF}] ======================= {AFAFAF}[{A9C4E4}!{AFAFAF}]");
    return 1;
}

CMD:ajuda(playerid, params[])
    return cmd_comandos(playerid, params);

CMD:comandos(playerid, params[])
{
    format(_largestring, 1280, "%s - /ajuda %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    SendSystemMessage(playerid, -1, "/ajudaplayer - /ajudageral - /ajudaarma - /ajudacarro - /forum");
    SendSystemMessage(playerid, -1, "Para uma lista detalhada com todos os comandos e suas fun��es, consulte nosso f�rum.");
    if(PlayerInfo[playerid][pAdmin] >= 1) SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}!{AFAFAF}] /adminajuda /aajuda /ah {AFAFAF}[{A9C4E4}!{AFAFAF}]");
    return 1;
}

CMD:ajudaplayer(playerid, params[])
{
    format(_largestring, 1280, "%s - /ajudaplayer %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}AJUDA/CHAT{AFAFAF}] (/re)latar(/relatorio) - (/sos)/duvida - (/carid)/vehid - (/o)oc - /lerooc - /lerfam - /lerpm");
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}AJUDA/CHAT{AFAFAF}] (/togcanim)/chatanim - /ver - /membros - (/animlist)/animacoes(/anims) - /stats(/rg) - /oldcar");
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}CHAT{AFAFAF}] /codenome - /codenomewt - (/wt)/walkie - (/r)adio - /sotaque - /ame - /me - /do - (/l)/falar4");
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}CHAT{AFAFAF}] /b - (/ba)ixo - (/g)ritar - (/freq)uencia(/canal) - /pm - (/s)ussurrar - (/cs)/carrosussurrar(/cw)4");
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}OUTROS{AFAFAF}] /descricao");
    return 1;
}

CMD:ajudaarma(playerid, params[])
{
    format(_largestring, 1280, "%s - /ajudararma %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}!{AFAFAF}] (/parma)/pegararma - (/jarma)/jogararma");
    return 1;
}

CMD:aajuda(playerid, params[])
    return cmd_adminajuda(playerid, params);

CMD:ah(playerid, params[])
    return cmd_adminajuda(playerid, params);

CMD:adminajuda(playerid, params[])
{
    format(_largestring, 1280, "%s - /comandos %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, -1, "Voc� n�o tem autoriza��o pra utilizar isso.");
    new admin = PlayerInfo[playerid][pAdmin];
    if(admin >= 1)
    {
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] /pegarip - /desbanirip - /checararmas - (/ar)/aceitarrelatorio - (/rr)/rejeitarrelatorio");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] (/aj)/aceitarajuda - (/desligarooc)/noooc - (/ao)/adminooc(/aooc) - /checar");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] /verpm - (/a)dmin - (/lsw)/lersystemwarning - (/lac)/leradminchat - (/law)/leradminwarning");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] /irlv - /ir - (/puxar)/trazer - (/irv)/irveiculo - (/tv)/trazerveiculo - (/rv)/repararveiculo");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] (/rvp)/repararveiculoplayer - /tapa - (/mute)/calar - /kick - /fakekick - /fakekickmsg ");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] /ban - /fakeban - /fakebanmsg - /fakebankick - /congelar - /descongelar - /atrabalhar");
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL I{AFAFAF}] /pegarip - /desbanirip");
    }
    if(admin >= 2)
    {
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL II{AFAFAF}] /enchervida - /enchercolete - (/svc) /setarvidacarro - (/svcp) /setarvidacarroplayer");
    }
    if(admin >= 3)
    {
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL III{AFAFAF}] /setarvida - /setarcolete - (/dvc) /darvidacarro - (/dvcp) /darvidacarroplayer - (/tempo)/clima");
    }
    if(admin >= 4)
    {
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL IV{AFAFAF}] /dararma - /darvida - /darcolete");
    }
    if(admin >= 1337)
    {
        SendClientMessage(playerid, -1, "{AFAFAF}[{A9C4E4}N�VEL 1337{AFAFAF}] /gmx - /daradmin - /darlider");
    }
    return 1;
}

CMD:atrabalho(playerid, params[])
    return cmd_atrabalhar(playerid, params);

CMD:atrabalhar(playerid, params[])
{
    format(_largestring, 1280, "%s - /atrabalhar %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        if(GetPVarInt(playerid, "AdminDuty"))
        {
            format(_string, 128, "%s (%d) saiu de trabalho administrativo.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
            DeletePVar(playerid, "AdminDuty");
            SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
            SetPlayerArmour(playerid, PlayerInfo[playerid][pArmor]);
            SetPlayerColor(playerid,0xFFFFFF00);
            format(_string, 128, "{AFAFAF}[{FF9900}!{AFAFAF}]%s (%d) acaba de {CF0000}sair{AFAFAF} de trabalho administrativo.", ReturnPlayerNameEx(playerid), playerid);
            Broadcast(-1, _string);
        }
        else
        {
            format(_string, 128, "%s (%d) entrou trabalho administrativo.", ReturnPlayerNameEx(playerid), playerid);
            AdminWarning(COLOR_YELLOW, _string);
            SetPVarInt(playerid, "AdminDuty", 1);
            SetPlayerArmour(playerid, 99999999999999);
			SetPlayerHealth(playerid, 99999999999999);
			SetPlayerColor(playerid,0xFBEE04FF);
            format(_string, 128, "{AFAFAF}[{FF9900}!{AFAFAF}]%s (%d) acaba de {00CF00}entrar{AFAFAF} em trabalho administrativo.", ReturnPlayerNameEx(playerid), playerid);
            Broadcast(-1, _string);
        }
        return 1;
    }
    else return SendErrorMessage(playerid, COLOR_GRAD2, "Voc� n�o pode usar isso.");
}

CMD:f(playerid, params[])
    return cmd_factionchat(playerid, params);

CMD:factionchat(playerid, params[])
{
    format(_largestring, 1280, "%s - /factionchat %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(GetPVarInt(playerid, "Muted")) return SendErrorMessage(playerid, -1, "Voc� foi proibido de falar/calado/mutado por um administrador!");
    new text[128];
    if (sscanf(params, "s[128]", text))
    {
        format(_string, sizeof (_string), "\"/%s [texto]\"", Command_GetDisplayNamed("factionchat", playerid));
        return SendCommandMessage(playerid, -1, _string);
    }
    if(PlayerInfo[playerid][pFaction] == 0) return SendErrorMessage(playerid, -1, "Voc� n�o tem uma fac��o.");
    format(text, 128, "(( %s %s: %s ))", GetPlayerRank(playerid), ReturnPlayerNameEx(playerid), text);
    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FAMILY, text);
    return 1;
}

CMD:membros(playerid, params[])
{
    format(_largestring, 1280, "%s - /membros %s", ReturnFullName(playerid), params);
    CommandLog(_largestring);
    if(PlayerInfo[playerid][pFaction] == 0) return SendErrorMessage(playerid, -1, "Voc� n�o tem uma fac��o.");
    new faction = PlayerInfo[playerid][pFaction];
    format(_string, 128, "{AFAFAF}[{7BDDA5}!{AFAFAF}] Membros online (%s) [{7BDDA5}!{AFAFAF}]", FactionInfo[faction][fName]);
    SendClientMessage(playerid, -1, _string);
    foreach(Player, i)
    {
        if(PlayerInfo[i][pFaction] == faction)
        {
            format(_string, 128, "{AFAFAF}[{7BDDA5}!{AFAFAF}] {7BDDA5}%s{AFAFAF} - {7BDDA5}%s{AFAFAF} ({7BDDA5}%d{AFAFAF}) - Cargo {7BDDA5}%d{AFAFAF} [{7BDDA5}!{AFAFAF}]", GetPlayerRank(playerid), ReturnPlayerNameEx(i), i, PlayerInfo[i][pRank]);
            SendClientMessage(playerid, -1, _string);
        }
    }
    return 1;
}
