@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view for Doctor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zc_Doctor
   as projection on ZIV_DOCTOR 
{
    key DocUid,
    key HosUid,
    Name,
    Age,
   @Consumption.valueHelpDefinition: [{ entity: {name: 'ZIV_VDEPART', element: 'Department' }}]
    Department,
    Status,
    Authority,
    Place,
    status_data,
    /* Associations */
    _Header : redirected to parent ZC_HOSPITAL
}
