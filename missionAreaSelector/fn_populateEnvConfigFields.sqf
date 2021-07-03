[] spawn {
    waitUntil {!isNull findDisplay 46423};

    _now = date;

    ctrlSetText [1400, str (_now select 0)];
    ctrlSetText [1401, str (_now select 1)];
    ctrlSetText [1402, str (_now select 2)];
    ctrlSetText [1403, str (_now select 3)];
    ctrlSetText [1404, str (_now select 4)];

    sliderSetPosition [1900, (overcast * 10)];
    sliderSetPosition [1901, (fog * 10)];
};