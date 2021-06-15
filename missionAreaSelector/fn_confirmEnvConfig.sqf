_newDate = [];

_newDate append [parseNumber (ctrlText 1400)];
_newDate append [parseNumber (ctrlText 1401)];
_newDate append [parseNumber (ctrlText 1402)];
_newDate append [parseNumber (ctrlText 1403)];
_newDate append [parseNumber (ctrlText 1404)];

[_newDate] remoteExecCall ["setDate", 2];

[0, ((sliderPosition 1900) / 10)] remoteExecCall ["setOvercast", 2];
remoteExecCall ["forceWeatherChange", 2];

closeDialog 1;