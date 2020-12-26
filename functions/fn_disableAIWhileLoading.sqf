// Temporarily disabled to avoid firefights breaking out while mission is initializing
if (isServer) then {
    {_x disableAI "all"} forEach allUnits;
};