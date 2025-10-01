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
        Rimsiakas_MissionAreaSelectorDialog_EnvConfigButton,
        Rimsiakas_MissionAreaSelectorDialog_AdvancedConfigButton,
        Rimsiakas_MissionAreaSelectorDialog_AiConfigButton
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

    class Rimsiakas_MissionAreaSelectorDialog_AiConfigButton: RscButton
    {
        idc = 1006;
        action = "[] spawn {createDialog 'Rimsiakas_AiConfigurationDialog';};"

        text = "AI Config"; //--- ToDo: Localize;
        x = 28.5 * GUI_GRID_W + GUI_GRID_X;
        y = 23 * GUI_GRID_H + GUI_GRID_Y;
        w = 5.5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
}