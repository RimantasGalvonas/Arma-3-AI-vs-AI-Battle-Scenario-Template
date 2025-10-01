class Rimsiakas_EnvironmentConfigurationDialog
{
    idd = 46423;
    movingEnabled = false;
    enableSimulation = true;

    onLoad = "call Rimsiakas_fnc_populateEnvConfigFields";

    controlsBackground[]=
    {
        Rimsiakas_EnvironmentConfigurationDialog_Background,
        Rimsiakas_EnvironmentConfigurationDialog_DateTimeLabel,
        Rimsiakas_EnvironmentConfigurationDialog_DateSeparator1,
        Rimsiakas_EnvironmentConfigurationDialog_DateSeparator2,
        Rimsiakas_EnvironmentConfigurationDialog_TimeSeparator,
        Rimsiakas_EnvironmentConfigurationDialog_OvercastLabel,
        Rimsiakas_EnvironmentConfigurationDialog_FogLabel
    };
    controls[]=
    {
        Rimsiakas_EnvironmentConfigurationDialog_YearField,
        Rimsiakas_EnvironmentConfigurationDialog_MonthField,
        Rimsiakas_EnvironmentConfigurationDialog_DayField,
        Rimsiakas_EnvironmentConfigurationDialog_HourField,
        Rimsiakas_EnvironmentConfigurationDialog_MinuteField,
        Rimsiakas_EnvironmentConfigurationDialog_OvercastSlider,
        Rimsiakas_EnvironmentConfigurationDialog_FogSlider,
        Rimsiakas_EnvironmentConfigurationDialog_ConfirmButton
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Rimantas, v1.063, #Gizebo)
    ////////////////////////////////////////////////////////

    class Rimsiakas_EnvironmentConfigurationDialog_Background: RscText
    {
        idc = 1000;
        x = 9.5 * GUI_GRID_W + GUI_GRID_X;
        y = 8.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 19.5 * GUI_GRID_W;
        h = 8.5 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateTimeLabel: RscText
    {
        idc = 1001;
        text = "Time:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateSeparator1: RscText
    {
        idc = 1002;
        text = "-"; //--- ToDo: Localize;
        x = 15.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateSeparator2: RscText
    {
        idc = 1003;
        text = "-"; //--- ToDo: Localize;
        x = 18 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_TimeSeparator: RscText
    {
        idc = 1004;
        text = ":"; //--- ToDo: Localize;
        x = 23.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_YearField: RscEdit
    {
        idc = 1400;
        x = 12.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 3 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 4;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_MonthField: RscEdit
    {
        idc = 1401;
        x = 16.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DayField: RscEdit
    {
        idc = 1402;
        x = 19 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_HourField: RscEdit
    {
        idc = 1403;
        x = 22 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_MinuteField: RscEdit
    {
        idc = 1404;
        x = 24.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_OvercastLabel: RscText
    {
        idc = 1005;
        text = "Overcast:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 10.7 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_OvercastSlider: RscSlider
    {
        idc = 1900;
        sliderRange[] = {0,10};
        x = 14 * GUI_GRID_W + GUI_GRID_X;
        y = 10.91 * GUI_GRID_H + GUI_GRID_Y;
        w = 11.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_FogLabel: RscText
    {
        idc = 1006;

        text = "Fog:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_FogSlider: RscSlider
    {
        idc = 1901;
        sliderRange[] = {0,10};

        x = 14 * GUI_GRID_W + GUI_GRID_X;
        y = 12.7 * GUI_GRID_H + GUI_GRID_Y;
        w = 11.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_ConfirmButton: RscButton
        {
            idc = 1600;
            text = "Confirm"; //--- ToDo: Localize;
            action = "call Rimsiakas_fnc_confirmEnvConfig";

            x = 10.5 * GUI_GRID_W + GUI_GRID_X;
            y = 14.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
        };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////

}
