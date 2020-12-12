class G_Revive_Dialog
{
	idd = 474637;
	movingenable = false;
	onLoad = "_this call G_fnc_Dialog_Rescuer_Text; _this call G_fnc_Dialog_Downs_Text;";
	
	class controls {
		class G_giveUp: RscButton
		{
			idc = 1600;
			text = "Give Up"; //--- ToDo: Localize;
			font = TahomaB;
			sizeEx = 0.03;
			colorText[] = {0,0,0,.9};
			x = 0.85 * safezoneW + safezoneX;
			y = 0.91 * safezoneH + safezoneY;
			w = 0.07 * safezoneW;
			h = 0.03 * safezoneH;
			action = "closeDialog 0; player setDamage 1;";
		};
	};
	
	class controlsBackground 
	{
		class G_Near_Rescuers: RscText
		{
			idc = 1001;
			text = "";
			font = TahomaB;
			sizeEx = 0.03;
			style = 528;
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
		};
		class G_Downs_Remaining: RscText
		{
			idc = 1002;
			text = "";
			font = TahomaB;
			sizeEx = 0.03;
			style = 528;
			x = 0.5 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
		};
		class G_Frame_Bottom: RscText
		{
			idc = 1003;
			text = "\n\nYou are Incapacitated and awaiting revive."; //--- ToDo: Localize;
			font = TahomaB;
			sizeEx = 0.04;
			style = 530;
			x = 0 * safezoneW + safezoneX;
			y = 0.85 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
		};
	};
};