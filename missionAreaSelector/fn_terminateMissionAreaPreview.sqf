[] spawn {
    Rimsiakas_missionAreaPreviewCamera cameraEffect ["terminate", "back"];
    camDestroy Rimsiakas_missionAreaPreviewCamera;
    _display = findDisplay 46422;
    _display closeDisplay 0;
    terminate Rimsiakas_missionAreaPreviewProcessId;

    removeMissionEventHandler ["Draw3D", Rimsiakas_MissionAreaPreviewHandlerId];
};