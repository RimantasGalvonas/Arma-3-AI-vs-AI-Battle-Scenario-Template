params ["_group", "_spawner", "_placer"];



private _dir = _placer getVariable "taxiDirection";

if (!isNil "_dir") then {
    {
        (vehicle _x) setDir _dir;
    } forEach (units _group);
};




if (isMultiplayer) exitWith {};

private _factionFriendly1 = spawner_01_friendly call ForceThrough_fnc_getRandomSpawnerFactionConfig;
private _factionFriendly2 = spawner_02_friendly call ForceThrough_fnc_getRandomSpawnerFactionConfig;
private _playerSide = [getNumber ((selectRandom [_factionFriendly1, _factionFriendly2]) >> "side")] call BIS_fnc_sideType;

{
    if ([_playerSide, side _x] call BIS_fnc_sideIsFriendly) then {
        addSwitchableUnit _x;
    };
} forEach (units _group);

{[_x] remoteExec ["Rimsiakas_fnc_revealFriendlyGroupsOnMap", _x]} foreach allPLayers;