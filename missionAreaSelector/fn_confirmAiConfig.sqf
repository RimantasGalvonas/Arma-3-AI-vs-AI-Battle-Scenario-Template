private _patrolFormation = lbData [1002, lbCurSel 1002];
patrolCenter setVariable ["aiConfigPatrolFormation", _patrolFormation, true];

private _attackFormation = lbData [1004, lbCurSel 1004];
patrolCenter setVariable ["aiConfigAttackFormation", _attackFormation, true];

private _speedMode = lbData [1006, lbCurSel 1006];
patrolCenter setVariable ["aiConfigSpeedMode", _speedMode, true];

private _attackSpeedOverride = cbChecked (displayCtrl 1008);
patrolCenter setVariable ["aiConfigAttackSpeedOverride", _attackSpeedOverride, true];

private _allowJoinGroup = cbChecked (displayCtrl 1010);
patrolCenter setVariable ["aiConfigAllowLastManToJoinNewGroup", _allowJoinGroup, true];

closeDialog 1;