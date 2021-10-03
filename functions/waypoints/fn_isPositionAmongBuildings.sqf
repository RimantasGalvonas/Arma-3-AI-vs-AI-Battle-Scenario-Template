params ["_position"];

_numberOfPlacesWithBuildings = 0;
_numberOfPlacesToCheck = 10;
_randomBestPlaces = selectBestPlaces [_position, 60, "-houses", 30, _numberOfPlacesToCheck]; // Those 60 and 30 values just seemed to work best when testing. Hard to tell why.
{
    _place = _x;

    if (_place select 1 < -0.3) then {
        _numberOfPlacesWithBuildings = _numberOfPlacesWithBuildings + 1;
    };
} forEach _randomBestPlaces;

_averagePlacesWithBuildings = _numberOfPlacesWithBuildings / _numberOfPlacesToCheck;

if (_averagePlacesWithBuildings > 0.5) exitWith {
    true;
};
false;