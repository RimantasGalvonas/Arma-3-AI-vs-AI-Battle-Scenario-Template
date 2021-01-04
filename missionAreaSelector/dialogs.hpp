#include "defines.hpp"

class Rimsiakas_MissionAreaSelectorDialog
{
    idd = 46421;
    movingEnabled = false;
    enableSimulation = true;

    controls[]=
    {
        Rimsiakas_MissionAreaSelectorDialog_ConfirmButton,
        Rimsiakas_MissionAreaSelectorDialog_Map,
        Rimsiakas_MissionAreaSelectorDialog_Instruction,
        Rimsiakas_MissionAreaSelectorDialog_PreviewButton,
        Rimsiakas_MissionAreaSelectorDialog_EnvConfigButton
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Rimantas, v1.063, #Lihatu)
    ////////////////////////////////////////////////////////

    class Rimsiakas_MissionAreaSelectorDialog_ConfirmButton: Rimsiakas_RscButton
    {
        idc = 1000;
        action = "[] call Rimsiakas_fnc_confirmMissionAreaSelection";

        text = "Confirm"; //--- ToDo: Localize;
        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    class Rimsiakas_MissionAreaSelectorDialog_Map: Rimsiakas_RscMapControl
    {
        idc = 1001;

        x = 0.5 * GUI_GRID_W + GUI_GRID_X;
        y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 39 * GUI_GRID_W;
        h = 20 * GUI_GRID_H;
    };
    class Rimsiakas_MissionAreaSelectorDialog_Instruction: Rimsiakas_RscText
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
    class Rimsiakas_MissionAreaSelectorDialog_PreviewButton: Rimsiakas_RscButton
    {
        idc = 1003;
        action = "[] call Rimsiakas_fnc_previewMissionArea";

        text = "Preview"; //--- ToDo: Localize;
        x = 6.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_MissionAreaSelectorDialog_EnvConfigButton: Rimsiakas_RscButton
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

    class BackToSelectionButton: Rimsiakas_RscButton
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

    class Rimsiakas_EnvironmentConfigurationDialog_Background: Rimsiakas_RscText
    {
        idc = 1000;
        x = 9.5 * GUI_GRID_W + GUI_GRID_X;
        y = 8.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 19.5 * GUI_GRID_W;
        h = 7 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateTimeLabel: Rimsiakas_RscText
    {
        idc = 1001;
        text = "Time:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateSeparator1: Rimsiakas_RscText
    {
        idc = 1002;
        text = "-"; //--- ToDo: Localize;
        x = 15.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DateSeparator2: Rimsiakas_RscText
    {
        idc = 1003;
        text = "-"; //--- ToDo: Localize;
        x = 18 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_TimeSeparator: Rimsiakas_RscText
    {
        idc = 1004;
        text = ":"; //--- ToDo: Localize;
        x = 23.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_YearField: Rimsiakas_RscEdit
    {
        idc = 1400;
        x = 12.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 3 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 4;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_MonthField: Rimsiakas_RscEdit
    {
        idc = 1401;
        x = 16.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_DayField: Rimsiakas_RscEdit
    {
        idc = 1402;
        x = 19 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_HourField: Rimsiakas_RscEdit
    {
        idc = 1403;
        x = 22 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_MinuteField: Rimsiakas_RscEdit
    {
        idc = 1404;
        x = 24.5 * GUI_GRID_W + GUI_GRID_X;
        y = 9 * GUI_GRID_H + GUI_GRID_Y;
        w = 1.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        maxChars = 2;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_OvercastLabel: Rimsiakas_RscText
    {
        idc = 1005;
        text = "Overcast:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 3.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_OvercastSlider: Rimsiakas_RscSlider
    {
        idc = 1900;
        sliderRange[] = {0,10};
        x = 14 * GUI_GRID_W + GUI_GRID_X;
        y = 10.71 * GUI_GRID_H + GUI_GRID_Y;
        w = 11.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };
    class Rimsiakas_EnvironmentConfigurationDialog_ConfirmButton: Rimsiakas_RscButton
    {
        idc = 1600;
        text = "Confirm"; //--- ToDo: Localize;
        action = "call Rimsiakas_fnc_confirmEnvConfig"

        x = 10.5 * GUI_GRID_W + GUI_GRID_X;
        y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////

}


