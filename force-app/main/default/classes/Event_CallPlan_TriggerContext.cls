public class Event_CallPlan_TriggerContext {

    public static boolean firstRun = true;

    public static boolean isFirstRun() {
        Boolean result = firstRun;
        if(result) {
            firstrun = !firstRun;
        }
        return result;
    }
	
   /* private static boolean firstRunevent = true;

    public static boolean isFirstRunevent() {
        Boolean resultevent = firstRunevent;
        if(resultevent) {
            firstrunevent = !firstRunevent;
        }
        return resultevent;
    } */
    
}