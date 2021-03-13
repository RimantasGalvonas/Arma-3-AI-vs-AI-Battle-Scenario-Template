params ["_positions"];

_xSum = 0;
_ySum = 0;

{
    _xSum = _xSum + (_x select 0);
    _ySum = _ySum + (_x select 1);
} forEach _positions;

[_xSum / count _positions, _ySum / count _positions];