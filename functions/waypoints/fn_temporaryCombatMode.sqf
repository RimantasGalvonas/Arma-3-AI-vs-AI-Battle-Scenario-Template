params ["_group", ["_combatModeTime", 15]];

private _originalBehaviour = behaviour (leader _group);

if (leader _group == player || {_group getVariable ["hasTemporaryCombatMode", false] || {_originalBehaviour in ["COMBAT", "STEALTH"]}}) exitWith {};

[_group, _originalBehaviour, _combatModeTime] spawn {
    params ["_group", "_originalBehaviour", "_combatModeTime"];

    _group setVariable ["hasTemporaryCombatMode", true];

    _group setBehaviour "COMBAT";

    sleep _combatModeTime;

    _group setBehaviour _originalBehaviour;
    _group setVariable ["hasTemporaryCombatMode", false];
};