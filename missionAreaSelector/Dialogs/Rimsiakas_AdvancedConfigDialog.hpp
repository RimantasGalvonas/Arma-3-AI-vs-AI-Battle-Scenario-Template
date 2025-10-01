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
        action = "['rotate_ccw'] remoteExecCall ['Rimsiakas_fnc_handleTransformButton', 2];";

        text = "Rotate CCW"; //--- ToDo: Localize;
        x = 6.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_RotateCW: RscButton
    {
        idc = 1004;
        action = "['rotate_cw'] remoteExecCall ['Rimsiakas_fnc_handleTransformButton', 2];";

        text = "Rotate CW"; //--- ToDo: Localize;
        x = 12.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_ScaleDown: RscButton
    {
        idc = 1005;
        action = "['scale_down'] remoteExecCall ['Rimsiakas_fnc_handleTransformButton', 2];";

        text = "Scale-"; //--- ToDo: Localize;
        x = 18.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };

    class Rimsiakas_AdvancedConfigDialog_ScaleUp: RscButton
    {
        idc = 1006;
        action = "['scale_up'] remoteExecCall ['Rimsiakas_fnc_handleTransformButton', 2];";

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
