setGroupIconsVisible [true, false];
Rimsiakas_missionValidationResult = ([] call Rimsiakas_fnc_validator);

if ((count Rimsiakas_missionValidationResult) > 0) then {
        [] spawn {
            sleep 0.1; // Small delay required to make sure hintC happens after the mission is initialized. Couldn't find any proper event handler for that.
            waitUntil {!isNull player};
            {
                waitUntil {isNull findDisplay 72 && isNull findDisplay 57};
                (_x select 0) hintC (_x select 1);
            } forEach Rimsiakas_missionValidationResult;
        };
} else {
    [] spawn {
        titleCut ["Initializing...", "BLACK FADED", 999];
        sleep 0.1; // Small delay required to make sure the mission is initialized, otherwise _isPlayerHighCommander is always false. Couldn't find any proper event handler for that.

        _isPlayerHighCommander = (count (hcAllGroups player) > 0);

        {
            if (_x getVariable "logicType" == "placer") then {
                _placer = _x;

                {
                    if (typeOf _x == "LOGIC") then {

                    } else {
                        _syncedUnit = _x;
                        _syncedGroup = nil;

                        if (_syncedUnit isKindOf "landVehicle") then {
                            _syncedUnit = (crew _x) select 0;
                        };
                        if (_syncedUnit isKindOf "man") then {
                            _syncedGroup = group _syncedUnit;
                        };

                        if (!isNil {_syncedGroup}) then {
                            [_syncedGroup, getPos _placer, _placer getVariable "minSpawnRadius", _placer getVariable "maxSpawnRadius", 0, 0.6, 0] call Rimsiakas_fnc_teleportSquadToRandomPosition;
                            if (_placer getVariable ["highCommandSubordinates", false] == false) then {
                                player hcRemoveGroup _syncedGroup;
                                _syncedGroup call Rimsiakas_fnc_recursiveSADWaypoint;
                            };
                        };
                    };
                } foreach synchronizedObjects _placer;

                {
                    [_placer, _x, _isPlayerHighCommander] call Rimsiakas_fnc_squadSpawner;
                } forEach (_placer getVariable "groups");
            };
        } forEach synchronizedObjects patrolCenter;


        if (_isPlayerHighCommander == false) then {
            [group player] call Rimsiakas_fnc_recursiveSADWaypoint;
        };

        /* Enable team switch */
        {
            addSwitchableUnit _x;
        } forEach units group player;

        [] execVM "createGrid.sqf";

        titleCut ["", "BLACK IN", 1];
    };
};