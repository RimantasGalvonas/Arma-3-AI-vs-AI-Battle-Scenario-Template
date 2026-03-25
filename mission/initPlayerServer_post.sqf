// Needs to be remoteExec'd from the server because all sorts of synchronization and locality problems messes up the markers for other players.

["supplies_marker_1", getPos supplies_1] remoteExec ["setMarkerPos", _playerUnit];
["supplies_marker_2", getPos supplies_2] remoteExec ["setMarkerPos", _playerUnit];
["supplies_marker_1", 1] remoteExec ["setMarkerAlpha", _playerUnit];
["supplies_marker_2", 1] remoteExec ["setMarkerAlpha", _playerUnit];

[win_trigger, triggerArea win_trigger] remoteExec ["setTriggerArea", _playerUnit];
[lose_trigger, triggerArea lose_trigger] remoteExec ["setTriggerArea", _playerUnit];
["team2_start_marker", win_trigger] remoteExec ["BIS_fnc_markerToTrigger", _playerUnit];
["team1_start_marker", lose_trigger] remoteExec ["BIS_fnc_markerToTrigger", _playerUnit];

["team2_start_marker", 1] remoteExec ["setMarkerAlpha", _playerUnit];
["team1_start_marker", 1] remoteExec ["setMarkerAlpha", _playerUnit];