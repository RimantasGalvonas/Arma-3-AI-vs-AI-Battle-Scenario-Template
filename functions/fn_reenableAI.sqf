{
    private _unit = _x;

    {
        _unit forgetTarget _x; // Reset target knowledge acquired before mission start when on multiplyer
    } forEach (_unit targets []);

    _unit enableAI "all"; // Re-enable AI disabled by disableAIWhileLoading function
} forEach allUnits;