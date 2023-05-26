//*************************************************************************************
// Name: NEPM_AvoidRecursion
// Description: To avaoid deadlock during recurssive trigger.
// Created By: G Ramesh Reddy[r.gopireddy@shell.com]
// Created Date : APr 02, 2019
/***Modification Log:
* Developer            Date                Description
* ----------------------------------------------------------

// ************************************************************************************/

public Class NEPM_AvoidRecursion{
    public static boolean firstRun = true;
    public static boolean isFirstRun(){
    if(firstRun){
      firstRun = false;
      return true;
    }else{
        return firstRun;
    }
    }
}