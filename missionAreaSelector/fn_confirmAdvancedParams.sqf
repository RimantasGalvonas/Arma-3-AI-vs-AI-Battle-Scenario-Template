patrolCenter setVariable ["patrolRadius", ceil (parseNumber (ctrlText 1009)), true];
patrolCenter setVariable ["intelGridSize", floor (parseNumber (ctrlText 1011)), true];
patrolCenter setVariable ["maxInfantryResponseDistance", floor (parseNumber (ctrlText 1014)), true];
patrolCenter setVariable ["maxVehicleResponseDistance", floor (parseNumber (ctrlText 1016)), true];
patrolCenter setVariable ["maxAirResponseDistance", floor (parseNumber (ctrlText 1018)), true];

call Rimsiakas_fnc_refreshAdvancedConfigInfo;