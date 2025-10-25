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

private _maxAttackRatio = parseNumber (ctrlText 1012);
if (_maxAttackRatio == 0) then {_maxAttackRatio = 99;};
patrolCenter setVariable ["aiConfigMaxAttackRatio", _maxAttackRatio, true];


private _forceFormation = cbChecked (displayCtrl 1014);
patrolCenter setVariable ["aiConfigForceFormation", _forceFormation, true];

closeDialog 1;