params ["_unit"];
private _previouslyKnownGroups = _unit getVariable ["MARTA_reveal", []];
private _friendlyGroups = allGroups select {[side _unit, side _x] call BIS_fnc_sideIsFriendly};
private _allGroupsToShow = _previouslyKnownGroups + _friendlyGroups;
//remove duplicates
_allGroupsToShow = _allGroupsToShow arrayIntersect _allGroupsToShow;
_unit setVariable ["MARTA_reveal", _allGroupsToShow];
setGroupIconsVisible [true, false];