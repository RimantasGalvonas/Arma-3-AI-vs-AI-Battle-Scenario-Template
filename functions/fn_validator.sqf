_getIncompleteParts = {
    private _placers = [];
    private _hasProperlyConfiguredPlacers = false;
    private _incompleteParts = ["Mission Area Setup", "Unit Placer Setup", "Configuring Placers To Place Units"];



    if (isNil "patrolCenter" || {isNil {patrolCenter getVariable "patrolRadius"} || isNil {patrolCenter getVariable "intelGridSize"}}) exitWith {
        _incompleteParts;
    };

    _incompleteParts deleteAt 0;



    {
        if (
            (_x getVariable ["logicType", ""]) == "placer" && {!isNil {_x getVariable "minSpawnRadius"} &&{!isNil {_x getVariable "maxSpawnRadius"}}}
        ) then {
            _placers append [_x];
        };

    } forEach (synchronizedObjects patrolCenter);

    if ((count _placers) == 0) exitWith {
        _incompleteParts;
    };

    _incompleteParts deleteAt 0;



    {
        _placer = _x;

        if (!isNil {_placer getVariable "groups"} && {count(_placer getVariable "groups") > 0}) exitWith {
            _hasProperlyConfiguredPlacers = true;
        };

        if (!isNil {_placer getVariable "camps"} && {count(_placer getVariable "camps") > 0}) exitWith {
            _hasProperlyConfiguredPlacers = true;
        };

        {
            _syncedUnit = _x;
            _syncedGroup = nil;

            if (_syncedUnit isKindOf "landVehicle") then {
                _syncedUnit = (crew _x) select 0;
            };
            if (_syncedUnit isKindOf "man") then {
                _syncedGroup = group _syncedUnit;
            };

            if (!isNil {_syncedGroup}) exitWith {
                _hasProperlyConfiguredPlacers = true;
            };
        } foreach synchronizedObjects _placer;
    } forEach _placers;

    if (_hasProperlyConfiguredPlacers == false) exitWith {
        _incompleteParts;
    };

    _incompleteParts deleteAt 0;



    _incompleteParts;
};


_incompleteParts = call _getIncompleteParts;



_allHints = [];

if ((count _incompleteParts) > 0) then {
    _incompleteSetupLines = [];
    _incompleteSetupLines append [parseText "You have successfully installed the template but the mission setup is incomplete."];
    _incompleteSetupLines append [parseText "Go to <a colorLink='#095EEA' href='https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template#mission-setup'>https://github.com/RimantasGalvonas/Arma-3-AI-vs-AI-Battle-Scenario-Template#mission-setup</a> for instructions."];
    _incompletePartsString = _incompleteParts joinString "<br/>";
    _incompleteSetupLines append [parseText ("These mandatory steps from the instructions still need completing or were done incorrectly:<br/><br/>" + _incompletePartsString)];
    _allHints append [["Mission Setup", _incompleteSetupLines]];
};

_allHints;