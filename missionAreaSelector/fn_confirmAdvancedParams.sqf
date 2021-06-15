patrolCenter setVariable ["patrolRadius", ceil (parseNumber (ctrlText 1009)), true];
patrolCenter setVariable ["intelGridSize", floor (parseNumber (ctrlText 1011)), true];
patrolCenter setVariable ["maxInfantryResponseDistance", floor (parseNumber (ctrlText 1014)), true];
patrolCenter setVariable ["maxVehicleResponseDistance", floor (parseNumber (ctrlText 1016)), true];
patrolCenter setVariable ["maxAirResponseDistance", floor (parseNumber (ctrlText 1018)), true];

_scale = patrolCenter getVariable ["scaling", 1];
patrolCenter setVariable ["intelGridSize_original", (patrolCenter getVariable "maxInfantryResponseDistance") / _scale, true];
patrolCenter setVariable ["maxInfantryResponseDistance_original", (patrolCenter getVariable "maxInfantryResponseDistance") / _scale, true];
patrolCenter setVariable ["maxVehicleResponseDistance_original", (patrolCenter getVariable "maxVehicleResponseDistance") / _scale, true];
patrolCenter setVariable ["maxAirResponseDistance_original", (patrolCenter getVariable "maxAirResponseDistance") / _scale, true];


call Rimsiakas_fnc_refreshAdvancedConfigInfo;