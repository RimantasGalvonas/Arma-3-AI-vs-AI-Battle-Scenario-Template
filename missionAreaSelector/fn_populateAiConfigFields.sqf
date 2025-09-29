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
        ["LIMITED", 0],
        ["NORMAL", 1]
    ];

    private _defaultSpeed = patrolCenter getVariable ["aiConfigDefaultSpeed", "NORMAL"];
    lbSetCurSel [1006, _speedHashMap get _defaultSpeed];

    private _forestSpeed = patrolCenter getVariable ["aiConfigForestSpeed", "NORMAL"];
    lbSetCurSel [1008, _speedHashMap get _forestSpeed];

    private _buildingsSpeed = patrolCenter getVariable ["aiConfigBuildingsSpeed", "NORMAL"];
    lbSetCurSel [1010, _speedHashMap get _buildingsSpeed];
};