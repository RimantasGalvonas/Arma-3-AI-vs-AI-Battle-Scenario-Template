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
        Rimsiakas_MissionAreaSelectorDialog_PreviewButton
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Rimantas, v1.063, #Lihatu)
    ////////////////////////////////////////////////////////

    class Rimsiakas_MissionAreaSelectorDialog_ConfirmButton: RscButton
    {
        idc = 1000;
        action = "[] call Rimsiakas_fnc_confirmMissionAreaSelection";

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
