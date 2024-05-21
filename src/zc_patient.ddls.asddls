@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view for Patient'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


define view entity ZC_PATIENT as projection on ZIV_PATIENT
{
    key PatUid,
    key HospUid,
    Name,
    Age,
    Department,
    Currency,
    Place,
    authority,
    /* Associations */
    _Header:redirected to parent ZC_HOSPITAL
}
