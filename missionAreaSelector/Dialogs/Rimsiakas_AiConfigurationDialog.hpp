class Rimsiakas_AiConfigurationDialog
{
    idd = 46425;
    movingEnabled = false;
    enableSimulation = true;

    onLoad = "call Rimsiakas_fnc_populateAiConfigFields";

    controlsBackground[]=
    {
        Rimsiakas_AiConfigurationDialog_Background,
        Rimsiakas_AiConfigurationDialog_PatrolFormationLabel,
        Rimsiakas_AiConfigurationDialog_AttackFormationLabel,
        Rimsiakas_AiConfigurationDialog_MovementSpeedModeLabel,
        Rimsiakas_AiConfigurationDialog_AttackSpeedOverrideLabel,
        Rimsiakas_AiConfigurationDialog_AllowGroupJoiningLabel
    };

    controls[]=
    {
        Rimsiakas_AiConfigurationDialog_PatrolFormation,
        Rimsiakas_AiConfigurationDialog_AttackFormation,
        Rimsiakas_AiConfigurationDialog_MovementSpeedMode,
        Rimsiakas_AiConfigurationDialog_AttackSpeedOverride,
        Rimsiakas_AiConfigurationDialog_AllowGroupJoining,
        Rimsiakas_AiConfigurationDialog_ConfirmButton
    };

    class Rimsiakas_AiConfigurationDialog_Background: RscText
    {
        idc = 1000;
        x = 9.5 * GUI_GRID_W + GUI_GRID_X;
        y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 19.5 * GUI_GRID_W;
        h = 16.5 * GUI_GRID_H;
        colorBackground[] = {-1,-1,-1,0.5};
    };

    class Rimsiakas_AiConfigurationDialog_PatrolFormationLabel: RscText
    {
        idc = 1001;
        text = "Patrol formation:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 1 * GUI_GRID_H + GUI_GRID_Y;
        w = 10 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };

    class Rimsiakas_AiConfigurationDialog_PatrolFormation: RscCombo
    {
        idc = 1002;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 2 * GUI_GRID_H + GUI_GRID_Y;
        w = 18.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Group will use this formation while looking for targets or while moving towards their target";

        class Items
        {
            class Column
            {
                text = "Column";
                data = "COLUMN";
                default = 0;
            };
            class StaggeredColumn
            {
                text = "Staggered Column";
                data = "STAG COLUMN";
                default = 0;
            };
            class Wedge
            {
                text = "Wedge";
                data = "WEDGE";
                default = 1;
            };
            class EchelonLeft
            {
                text = "Echelon Left";
                data = "ECH LEFT";
                default = 0;
            };
            class EchelonRight
            {
                text = "Echelon Right";
                data = "ECH RIGHT";
                default = 0;
            };
            class Vee
            {
                text = "Vee";
                data = "VEE";
                default = 0;
            };
            class Line
            {
                text = "Line";
                data = "LINE";
                default = 0;
            };
            class File
            {
                text = "File";
                data = "FILE";
                default = 0;
            };
            class Diamond
            {
                text = "Diamond";
                data = "DIAMOND";
                default = 0;
            };
        };
    };

    class Rimsiakas_AiConfigurationDialog_AttackFormationLabel: RscText
    {
        idc = 1003;
        text = "Attack formation:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 4 * GUI_GRID_H + GUI_GRID_Y;
        w = 10 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };

    class Rimsiakas_AiConfigurationDialog_AttackFormation: RscCombo
    {
        idc = 1004;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 5 * GUI_GRID_H + GUI_GRID_Y;
        w = 18.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Group will switch to this formation when within engagement distance to their target";

        class Items
        {
            class Column
            {
                text = "Column";
                data = "COLUMN";
                default = 0;
            };
            class StaggeredColumn
            {
                text = "Staggered Column";
                data = "STAG COLUMN";
                default = 0;
            };
            class Wedge
            {
                text = "Wedge";
                data = "WEDGE";
                default = 1;
            };
            class EchelonLeft
            {
                text = "Echelon Left";
                data = "ECH LEFT";
                default = 0;
            };
            class EchelonRight
            {
                text = "Echelon Right";
                data = "ECH RIGHT";
                default = 0;
            };
            class Vee
            {
                text = "Vee";
                data = "VEE";
                default = 0;
            };
            class Line
            {
                text = "Line";
                data = "LINE";
                default = 0;
            };
            class File
            {
                text = "File";
                data = "FILE";
                default = 0;
            };
            class Diamond
            {
                text = "Diamond";
                data = "DIAMOND";
                default = 0;
            };
        };
    };

    class Rimsiakas_AiConfigurationDialog_MovementSpeedModeLabel: RscText
    {
        idc = 1005;
        text = "Group movement speed:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 7 * GUI_GRID_H + GUI_GRID_Y;
        w = 10 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };

    class Rimsiakas_AiConfigurationDialog_MovementSpeedMode: RscCombo
    {
        idc = 1006;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 8 * GUI_GRID_H + GUI_GRID_Y;
        w = 18.5 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;

        class Items
        {
            class Normal
            {
                text = "Normal";
                data = "NORMAL";
                default = 1;
            };
            class Smart
            {
                text = "Smart";
                data = "SMART";
                tooltip = "Slow in cover, fast in open areas";
                default = 0;
            };
            class Slow
            {
                text = "Slow";
                data = "SLOW";
                default = 0;
            };
        };
    };

    class Rimsiakas_AiConfigurationDialog_AttackSpeedOverrideLabel: RscText
    {
        idc = 1007;
        text = "Force normal attack speed:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 10 * GUI_GRID_H + GUI_GRID_Y;
        w = 10 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };

    class Rimsiakas_AiConfigurationDialog_AttackSpeedOverride: RscCheckBox
    {
        idc = 1008;
        x = 19.5 * GUI_GRID_W + GUI_GRID_X;
        y = 10 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Switch to Normal speed mode as soon as a target is assigned.";
        checked = 0;
    };

    class Rimsiakas_AiConfigurationDialog_AllowGroupJoiningLabel: RscText
    {
        idc = 1009;
        text = "Allow last man to join new group:"; //--- ToDo: Localize;
        x = 10 * GUI_GRID_W + GUI_GRID_X;
        y = 12 * GUI_GRID_H + GUI_GRID_Y;
        w = 12 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
    };

    class Rimsiakas_AiConfigurationDialog_AllowGroupJoining: RscCheckBox
    {
        idc = 1010;
        x = 21.5 * GUI_GRID_W + GUI_GRID_X;
        y = 12 * GUI_GRID_H + GUI_GRID_Y;
        w = 1 * GUI_GRID_W;
        h = 1 * GUI_GRID_H;
        tooltip = "Allow the last surviving AI unit to join a new group, if there is one nearby.";
        checked = 0;
    };

    class Rimsiakas_AiConfigurationDialog_ConfirmButton: RscButton
    {
        idc = 1600;
        text = "Confirm"; //--- ToDo: Localize;
        action = "call Rimsiakas_fnc_confirmAiConfig";

        x = 10.5 * GUI_GRID_W + GUI_GRID_X;
        y = 14.5 * GUI_GRID_H + GUI_GRID_Y;
        w = 5 * GUI_GRID_W;
        h = 1.5 * GUI_GRID_H;
    };
}
