while {patrolCenter getVariable ["aiConfigForceFormation", false]} do {
    {
        _x enableAttack false;
    } forEach allGroups;

    sleep 5;
};