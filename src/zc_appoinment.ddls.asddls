@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view for Appoinment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED    
}
define view entity ZC_APPOINMENT as projection on ZIV_APPOINMENT
{
   key Opatid,
   key HosUid,
   Name,
   Age,
   Cause,
   AppoinmentNo,
   DocUid,
   Zdate,
   Place,
   Amount,
   /* Associations */
   _header: redirected to parent ZC_HOSPITAL  
}
