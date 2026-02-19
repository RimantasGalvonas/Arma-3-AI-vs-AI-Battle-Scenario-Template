"supplies_marker_1" setMarkerAlpha 0;
"supplies_marker_2" setMarkerAlpha 0;
"team2_start_marker" setMarkerAlpha 0;
"team1_start_marker" setMarkerAlpha 0;

player addRating -10000; // Otherwise reveals independents on the map before you teamswitch

if (!isMultiplayer) then {
    private _initialPlayable = synchronizedObjects initialPlayableUnitsManager;

    {
        deleteVehicle _x; // Doesn't delete the player
    } forEach (_initialPlayable);

    addMissionEventHandler [
        "TeamSwitch",
        {
            params ["_previousUnit", "_newUnit"];

            if (_previousUnit in (_thisArgs select 0)) then {
                deleteVehicle _previousUnit;
            };
        },
        [_initialPlayable]
    ];
};

ForceThrough_ReversePresetGenerationProcess = [] spawn ForceThrough_fnc_generateReversedDefaultPreset;