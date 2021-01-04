_newDate = [];

_newDate append [parseNumber (ctrlText 1400)];
_newDate append [parseNumber (ctrlText 1401)];
_newDate append [parseNumber (ctrlText 1402)];
_newDate append [parseNumber (ctrlText 1403)];
_newDate append [parseNumber (ctrlText 1404)];

setDate _newDate;

0 setOvercast ((sliderPosition 1900) / 10);
forceWeatherChange;

closeDialog 1;