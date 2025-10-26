[] spawn {
    waitUntil {!isNull findDisplay 46425};

    private _formationHashMap = createHashMapFromArray [
        ["COLUMN", 0],
        ["STAG COLUMN", 1],
        ["WEDGE", 2],
        ["ECH LEFT", 3],
        ["ECH RIGHT", 4],
        ["VEE", 5],
        ["LINE", 6],
        ["FILE", 7],
        ["DIAMOND", 8]
    ];

    private _patrolFormation = patrolCenter getVariable ["aiConfigPatrolFormation", "WEDGE"];
    lbSetCurSel [1002, _formationHashMap get _patrolFormation];

    private _attackFormation = patrolCenter getVariable ["aiConfigAttackFormation", "WEDGE"];
    lbSetCurSel [1004, _formationHashMap get _attackFormation];


    private _speedHashMap = createHashMapFromArray [
        ["NORMAL", 0],
        ["SMART", 1],
        ["SLOW", 2]
    ];

    private _speedMode = patrolCenter getVariable ["aiConfigSpeedMode", "NORMAL"];
    lbSetCurSel [1006, _speedHashMap get _speedMode];

    private _attackSpeedOverride = patrolCenter getVariable ["aiConfigAttackSpeedOverride", false];
    (displayCtrl 1008) cbSetChecked _attackSpeedOverride;

    private _allowJoinGroup = patrolCenter getVariable ["aiConfigAllowLastManToJoinNewGroup", false];
    (displayCtrl 1010) cbSetChecked _allowJoinGroup;

    private _forceFormation = patrolCenter getVariable ["aiConfigForceFormation", false];
    (displayCtrl 1012) cbSetChecked _forceFormation;
};