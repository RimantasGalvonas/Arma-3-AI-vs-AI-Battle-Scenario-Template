params ["_spawner"];

private _unitTypes = [];

{
    private _pool = _x;

    {
        private _groupUnits = _x;

        if (typeName _groupUnits == "CONFIG") then {
            _groupUnits = ("true" configClasses _groupUnits) apply {getText (_x >> "vehicle")};
        };

        _unitTypes append _groupUnits;
    } forEach (_pool get "groups");
} forEach (_spawner getVariable ["pools", []]);

_unitTypes;