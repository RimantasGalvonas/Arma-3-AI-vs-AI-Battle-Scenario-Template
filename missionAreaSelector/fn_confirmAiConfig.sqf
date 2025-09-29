private _patrolFormation = lbData [1002, lbCurSel 1002];
patrolCenter setVariable ["aiConfigPatrolFormation", _patrolFormation, true];

private _attackFormation = lbData [1004, lbCurSel 1004];
patrolCenter setVariable ["aiConfigAttackFormation", _attackFormation, true];

private _defaultSpeed = lbData [1006, lbCurSel 1006];
patrolCenter setVariable ["aiConfigDefaultSpeed", _defaultSpeed, true];

private _forestSpeed = lbData [1008, lbCurSel 1008];
patrolCenter setVariable ["aiConfigForestSpeed", _forestSpeed, true];

private _buildingsSpeed = lbData [1010, lbCurSel 1010];
patrolCenter setVariable ["aiConfigBuildingsSpeed", _buildingsSpeed, true];

closeDialog 1;