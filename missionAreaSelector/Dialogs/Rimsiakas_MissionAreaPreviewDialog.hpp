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
