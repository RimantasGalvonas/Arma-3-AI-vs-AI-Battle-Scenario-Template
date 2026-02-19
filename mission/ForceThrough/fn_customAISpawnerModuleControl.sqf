_var = [] spawn {
    while {true} do {
        _unitsPerSpawner = 20;
        _spawners = (entities "LOGIC") select {typeOf _x == "ModuleSpawnAI_F"};

        {
            _x setVariable ["manpowerCap", 10000];

            _unitsCount = 0;
            {
                _unitsCount = _unitsCount + ({alive _x} count (units _x));
            } forEach (_x getVariable "groups");

            if (_unitsCount > _unitsPerSpawner) then {
                _x setVariable ["activated", false];
            } else {
                _x setVariable ["activated", true];
            };
        } forEach _spawners;

        sleep 5;
    };
};