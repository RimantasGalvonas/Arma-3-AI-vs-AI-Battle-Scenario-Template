player createDiarySubject ["G_Revive", "Grimes Simple Revive"];

player createDiaryRecord ["G_Revive", ["Credits", 
	"
	<br/><font size='18'>Credits</font>
	<br/>I would like to extend a big thanks to the following individuals and groups, in no particular order, for their direct or indirect assistance and contribution to this project. Thank you for supporting Grimes Simple Revive!
	<br/>
	<br/>* Bohemia Interactive – For providing an amazing game and location for a fan base, in addition to provided assistance.
	<br/>* BI Forum Users – For providing an active community for Arma assistance, feedback, and collaboration. 
	<br/>    * Honorable Mention: norrin, brians200, Das Attorney, PtPau, Imperator_Pete, csk222, maximumvmo, pathfinder2, marcatore, Zio Sam, fortun, Ignotus17, Bunnylord, mech79, airfell, Droopypiles, doktorflan, runforrest, Ironman13, pvtdancer, avibird 1, Rockapes, fycj, Jnr4817, jeremyjhutton, and any whom I have failed to mention.
	<br/>* 3rd Infantry Division – For providing everything that is indescribable in a single mention, but specifically for testing assistance.
	<br/>    * Honorable Mention: Taylor, Ski, Foondle, Robertson, Townsend, and any whom I have failed to mention.
	<br/>
	"
]];

player createDiaryRecord ["G_Revive", ["Editor's Notes", 
	"
	<br/><font size='18'>Editor: KC Grimes</font>
	<br/>
	<br/>Thank you so much for choosing to use Grimes Simple Revive in your mission. I am proud to contribute to the Arma/BI community. 
	<br/>
	<br/>If you have suggestions, comments, or bug reports, please feel free to bring them up in the BI forums topic or github.
	<br/>   https://forums.bohemia.net/forums/topic/167673-grimes-simple-revive-script/
	<br/>   https://github.com/kcgrimes/grimes-simple-revive
	<br/>
	<br/>Again, thank you for choosing Grimes Simple Revive for your revive needs. Enjoy your game!
	<br/>
	"
]];

//Prepare dynamic How To based on which systems are enabled and certain associated settings
private _dynamicHowTo = [];
if (G_Revive_System ) then {
	private _incapEnabled = "Players";
	if ((count G_Revive_AI_Incapacitated) > 0) then {
		_incapEnabled = format["Players and %1 AI", G_Revive_AI_Incapacitated joinString ", "];
	};
	private _reviveClassReq = "Any class can revive Incapacitated teammates.";
	if ((count G_Revive_Can_Revive) > 0) then {
		private _reqClass = [];
		{
			_reqClass pushBack (getText (configFile >> "CfgVehicles" >> _x >> "displayName"));
		} forEach G_Revive_Can_Revive;
		_reviveClassReq = format["Only the %1 can revive Incapacitated teammates.", _reqClass joinString ", "];
	};
	private _reviveReq = "No First Aid Kits or Medikits are required in order to revive.";
	if (G_Revive_Requirement > 0) then {
		_reviveReq = format["A minimum of %1 First Aid Kit(s), or a single Medikit, are required in order to revive.", G_Revive_Requirement];
	};
	_dynamicHowTo pushBack format["
	<br/>* Revive is enabled! %1 can be Incapacitated. To Revive an Incapacitated teammate, simply approach them and use the Revive action.
	<br/>
	<br/>* %2
	<br/>
	<br/>* %3
	<br/>
	<br/>* To Drag or Carry any Incapacitated unit (doesn't have to be a teammate!), simply approach them and use the Drag or Carry action. 
	<br/>
	<br/>* To Load an Incapacitated teammate into a vehicle, simply move them or the vehicle within range and use the Load action on the Incapacitated unit. 
	<br/>
	<br/>* AI will work in pairs to navigate towards Incapacitated teammates to guard and revive them before returning to their group formation. 
	<br/>
	", _incapEnabled, _reviveClassReq, _reviveReq];
};

if (count (G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_IND + G_Mobile_Respawn_CIV) > 0) then {
	_dynamicHowTo pushBack "
	<br/>* The Mobile Respawn Vehicle (MRV) system is enabled! Simply approach the team's MRV and use the Deploy/Undeploy actions to Deploy/Undeploy the vehicle. This allows for teammates to spawn on it.
	<br/>
	";
};

if (G_Squad_Leader_Spawn) then {
	_dynamicHowTo pushBack "
	<br/>* The Squad Leader Spawn system is enabled! If your squad leader is alive, you will be able to respawn on them.
	<br/>
	";
};

if (G_Squad_Leader_Marker) then {
	_dynamicHowTo pushBack "
	<br/>* The Squad Leader Marker system is enabled! A marker will be placed on the map and updated periodically with the location of your squad leader.
	<br/>
	";
};

if (G_Unit_Tag) then {
	private _unitTagHowTo = "";
	switch (G_Unit_Tag_Display) do {
		case 0: {
			_unitTagHowTo = format["Unit Tags that are in range will be displayed after pressing %1.", call compile (keyName G_Unit_Tag_Display_Key)];
		};
		case 1: {
			_unitTagHowTo = "Unit Tags will be displayed when cursor-targeting a unit that is in range.";
		};
		case 2: {
			_unitTagHowTo = "Unit Tags will be displayed when in range.";
		};
	};
	_dynamicHowTo pushBack format["
	<br/>* The Unit Tag System is enabled! %1
	<br/>
	", _unitTagHowTo];
};

//Execute dynamic How To
player createDiaryRecord ["G_Revive", ["How To Use", format[
	"
	<br/><font size='18'>How To Use</font>
	<br/>
	%1
	", _dynamicHowTo joinString ""]
]];