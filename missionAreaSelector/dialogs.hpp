class Rimsiakas_MissionAreaSelectorDialog
{
    import RscButton;
    import RscMapControl;
    import RscText;
    import RscEdit;
    import RscSlider;

    idd = 46421;
    movingEnabled = false;
    enableSimulation = true;

    controls[]=
    {
        Rimsiakas_MissionAreaSelectorDialog_ConfirmButton,
        Rimsiakas_MissionAreaSelectorDialog_Map,
        Rimsiakas_MissionAreaSelectorDialog_Instruction,
        Rimsiakas_MissionAreaSelectorDialog_PreviewButton,
        Rimsiakas_MissionAreaSelectorDialog_EnvConfigButton,
        Rimsiakas_MissionAreaSelectorDialog_AdvancedConfigButton
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Rimantas, v1.063, #Lihatu)
    ////////////////////////////////////////////////////////

    class Rimsiakas_MissionAreaSelectorDialog_ConfirmButton: RscButton
    {
        idc = 1000;
        action = "closeDialog 1; deleteMarkerLocal 'missionAreaMarker'; Rimsiakas_missionAreaSelected = true;";

        text = "Confirm"; //--- ToDo: Localize;
        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    class Rimsiakas_MissionAreaSelectorDialog_Map: RscMapControl
    {
        idc = 1001;

        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 39 * GUI_GRID_W;
        h = 20 * GUI_GRID_H;
    };
    class Rimsiakas_MissionAreaSelectorDialog_Instruction: RscText
    {
        idc = 1002;

        text = "Click on the map to select the mission area"; //--- ToDo: Localize;
        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 39 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
        sizeEx = 0.05;
    };
    class Rimsiakas_MissionAreaSelectorDialog_PreviewButton: RscButton
    {
        idc = 1003;
        action = "[] call Rimsiakas_fnc_previewMissionArea";

        text = "Preview"; //--- ToDo: Localize;
        x = 6.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_MissionAreaSelectorDialog_EnvConfigButton: RscButton
    {
        idc = 1004;
        action = "[] spawn {createDialog 'Rimsiakas_EnvironmentConfigurationDialog';};";

        text = "Environment Config"; //--- ToDo: Localize;
        x = 12.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////

    class Rimsiakas_MissionAreaSelectorDialog_AdvancedConfigButton: RscButton
    {
        idc = 1005;
        action = "[] spawn {call Rimsiakas_fnc_openAdvancedConfig;};";

        text = "Advanced Config"; //--- ToDo: Localize;
        x = 20.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
}


class Rimsiakas_MissionAreaPreviewDialog
{
    idd = 46422;
    movingEnabled = false;
    enableSimulation = true;

    controls[] =
    {
        BackToSelectionButton
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Rimantas, v1.063, #Lydoby)
    ////////////////////////////////////////////////////////

    class BackToSelectionButton: RscButton
    {
        idc = 1600;
        text = "Back to selection"; //--- ToDo: Localize;
        x = 15 * GUI_GRID_W + GUI_GRID_X;
        y = 22 * GUI_GRID_H + GUI_GRID_Y;
        w = 8.5 * GUI_GRID_W;
        h = 2 * GUI_GRID_H;
        action = "call Rimsiakas_fnc_terminateMissionAreaPreview";
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////
}


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
        Rimsiakas_EnvironmentConfigurationDialog_OvercastLabel
    };
    controls[]=
    {
        Rimsiakas_EnvironmentConfigurationDialog_YearField,
        Rimsiakas_EnvironmentConfigurationDialog_MonthField,
        Rimsiakas_EnvironmentConfigurationDialog_DayField,
        Rimsiakas_EnvironmentConfigurationDialog_HourField,
        Rimsiakas_EnvironmentConfigurationDialog_MinuteField,
        Rimsiakas_EnvironmentConfigurationDialog_OvercastSlider,
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
        h = 7 * GUI_GRID_H;
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
        y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_OvercastSlider: RscSlider
    {
        idc = 1900;
        sliderRange[] = {0,10};
        x = 14 * GUI_GRID_W + GUI_GRID_X;
        y = 10.71 * GUI_GRID_H + GUI_GRID_Y;
        w = 11.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_ConfirmButton: RscButton
    {
        idc = 1600;
        text = "Confirm"; //--- ToDo: Localize;
        action = "call Rimsiakas_fnc_confirmEnvConfig";

        x = 10.5 * GUI_GRID_W + GUI_GRID_X;
        y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////

}


class Rimsiakas_AdvancedConfigDialog
{
    idd = 46424;
    movingEnabled = false;
    enableSimulation = true;

    controls[]=
    {
        Rimsiakas_AdvancedConfigDialog_BackButton,
        Rimsiakas_AdvancedConfigDialog_Map,
        Rimsiakas_AdvancedConfigDialog_Instruction,
        Rimsiakas_AdvancedConfigDialog_RotateCCW,
        Rimsiakas_AdvancedConfigDialog_RotateCW,
        Rimsiakas_AdvancedConfigDialog_ScaleDown,
        Rimsiakas_AdvancedConfigDialog_ScaleUp,
        Rimsiakas_AdvancedConfigDialog_ParamsBackground,
        Rimsiakas_AdvancedConfigDialog_PatrolRadiusLabel,
        Rimsiakas_AdvancedConfigDialog_PatrolRadiusValue,
        Rimsiakas_AdvancedConfigDialog_IntelGridSizeLabel,
        Rimsiakas_AdvancedConfigDialog_IntelGridSizeValue,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceLabel,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceInfantryLabel,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceInfantryValue,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceVehiclesLabel,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceVehiclesValue,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceAirLabel,
        Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceAirValue,
        Rimsiakas_AdvancedConfigDialog_ApplyParamsBtn
    };

    class Rimsiakas_AdvancedConfigDialog_BackButton: RscButton
    {
        idc = 1000;
        action = "closeDialog 1;";

        text = "Back"; //--- ToDo: Localize;
        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    class Rimsiakas_AdvancedConfigDialog_Map: RscMapControl
    {
        idc = 1001;

        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 30 * GUI_GRID_W;
        h = 20 * GUI_GRID_H;
    };
    class Rimsiakas_AdvancedConfigDialog_Instruction: RscText
    {
        idc = 1002;

        text = "Advanced configuration"; //--- ToDo: Localize;
        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 39 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
        sizeEx = 0.05;
    };
    class Rimsiakas_AdvancedConfigDialog_RotateCCW: RscButton
    {
        idc = 1003;
        action = "[] spawn {[nil, -5] call Rimsiakas_fnc_moveMissionArea; call Rimsiakas_fnc_refreshAdvancedConfigInfo;};";

        text = "Rotate CCW"; //--- ToDo: Localize;
        x = 6.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_RotateCW: RscButton
    {
        idc = 1004;
        action = "[] spawn {[nil, 5] call Rimsiakas_fnc_moveMissionArea; call Rimsiakas_fnc_refreshAdvancedConfigInfo;};";

        text = "Rotate CW"; //--- ToDo: Localize;
        x = 12.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_ScaleDown: RscButton
    {
        idc = 1005;
        action = "[-0.1] call Rimsiakas_fnc_scaleObjectPlacement; call Rimsiakas_fnc_refreshAdvancedConfigInfo;";

        text = "Scale-"; //--- ToDo: Localize;
        x = 18.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_ScaleUp: RscButton
    {
        idc = 1006;
        action = "[0.1] call Rimsiakas_fnc_scaleObjectPlacement; call Rimsiakas_fnc_refreshAdvancedConfigInfo;";

        text = "Scale+"; //--- ToDo: Localize;
        x = 24.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_ParamsBackground: RscText
    {
        idc = 1007;
        x = 31 * GUI_GRID_W + GUI_GRID_X;
        y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 8.5 * GUI_GRID_W;
        h = 20 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
    };
    class Rimsiakas_AdvancedConfigDialog_PatrolRadiusLabel: RscText
    {
        idc = 1008;
        text = "Patrol Radius:"; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 3 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };
    class Rimsiakas_AdvancedConfigDialog_PatrolRadiusValue: RscText
    {
        idc = 1009;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 4 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_AdvancedConfigDialog_IntelGridSizeLabel: RscText
    {
        idc = 1010;
        text = "Intel Grid Size:"; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 6 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelGridSizeValue: RscEdit
    {
        idc = 1011;
        x = 32 * GUI_GRID_W + GUI_GRID_X;
        y = 7 * GUI_GRID_H + GUI_GRID_Y;
        w = 6.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "The size of colored squares on the map hinting the enemy locations. Set to 0 to disable."; //--- ToDo: Localize;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceLabel: RscText
    {
        idc = 1012;
        text = "Intel Response Dist."; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceInfantryLabel: RscText
    {
        idc = 1013;
        text = "Infantry"; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 11 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceInfantryValue: RscEdit
    {
        idc = 1014;
        x = 32 * GUI_GRID_W + GUI_GRID_X;
        y = 12 * GUI_GRID_H + GUI_GRID_Y;
        w = 6.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Maximum distance to target at which infantry groups will respond to intel about the enemy location."; //--- ToDo: Localize;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceVehiclesLabel: RscText
    {
        idc = 1015;
        text = "Vehicles"; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceVehiclesValue: RscEdit
    {
        idc = 1016;
        x = 32 * GUI_GRID_W + GUI_GRID_X;
        y = 14.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 6.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Maximum distance to target at which mounted groups will respond to intel about the enemy location."; //--- ToDo: Localize;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceAirLabel: RscText
    {
        idc = 1017;
        text = "Air"; //--- ToDo: Localize;
        x = 31.5 * GUI_GRID_W + GUI_GRID_X;
        y = 16 * GUI_GRID_H + GUI_GRID_Y;
        w = 7.5 * GUI_GRID_W;
        h = 0.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_IntelResponseDistanceAirValue: RscEdit
    {
        idc = 1018;
        x = 32 * GUI_GRID_W + GUI_GRID_X;
        y = 17 * GUI_GRID_H + GUI_GRID_Y;
        w = 6.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Maximum distance to target at which air assets will respond to intel about the enemy location."; //--- ToDo: Localize;
    };

    class Rimsiakas_AdvancedConfigDialog_ApplyParamsBtn: RscButton
    {
        idc = 1019;
        action = "call Rimsiakas_fnc_confirmAdvancedParams;";

        text = "Apply"; //--- ToDo: Localize;
        x = 32 * GUI_GRID_W + GUI_GRID_X;
        y = 20 * GUI_GRID_H + GUI_GRID_Y;
        w = 6.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
        tooltip = "Apply the input field values."; //--- ToDo: Localize;
        colorBackground[] = {-1,-1,-1,1};
    };
}



