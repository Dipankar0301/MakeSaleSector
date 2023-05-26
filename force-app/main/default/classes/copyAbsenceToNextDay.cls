global class copyAbsenceToNextDay implements FSL.CustomGanttResourceAbsenceAction {
    global String action(Id absenceId, String absenceType, Datetime ganttStartDate, Datetime ganttEndDate, Map<String, Object> additionalParameters) {
        ResourceAbsence resourceAbsence = [SELECT Id, AbsenceNumber, Start, End, ResourceId, RecordTypeId, FSL__Approved__c FROM ResourceAbsence WHERE Id =: absenceId LIMIT 1];
        ResourceAbsence raClone = resourceAbsence.clone(false, true, false, false);
        raClone.Start = resourceAbsence.Start.addDays(1);
        raClone.End = resourceAbsence.End.addDays(1);
        raClone.ResourceId = resourceAbsence.ResourceId;
	raClone.RecordTypeId = resourceAbsence.RecordTypeId;
        raClone.FSL__Approved__c = true;
        insert raClone;
        return 'Resource Absence successfully copied.';
    }
}