call Rimsiakas_fnc_createMarkersForSyncedObjects;

[] spawn {
    waitUntil {!isNull findDisplay 46424};

    ctrlSetText [1009, str (patrolCenter getVariable "patrolRadius")];
    ctrlSetText [1011, str (patrolCenter getVariable "intelGridSize")];
    ctrlSetText [1014, str (patrolCenter getVariable "maxInfantryResponseDistance")];
    ctrlSetText [1016, str (patrolCenter getVariable "maxVehicleResponseDistance")];
    ctrlSetText [1018, str (patrolCenter getVariable "maxAirResponseDistance")];
};