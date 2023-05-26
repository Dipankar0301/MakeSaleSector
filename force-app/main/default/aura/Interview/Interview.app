<aura:application extends="force:slds" implements="flexipage:availableForAllPageTypes,force:appHostable">
    <aura:attribute name="recordId" type="String"/>
    <c:Interview_Layout recId="{!v.recordId}"/>
</aura:application>