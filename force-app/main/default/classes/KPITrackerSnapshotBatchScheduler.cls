/*
* Author: Y J, Sowmya
* Description: It's used to schedule KPITracker_Batch_Historic_KPI_Snapshot class every month of date 28.
*/

global class KPITrackerSnapshotBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        KPITracker_Batch_Historic_KPI_Snapshot b = new KPITracker_Batch_Historic_KPI_Snapshot(); 
        database.executebatch(b);
        /*KPITrackerSnapshotBatchScheduler testObj = new KPITrackerSnapshotBatchScheduler();
		  String cronexpression = '0 0 12 28 1/1 ? *';
		  System.schedule('Testing', cronexpression, testobj);
	   */
    }
}