@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Patient'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZIV_PATIENT as select from zdb_hospital_itm
association to parent Ziv_Hospital as _Header on $projection.HospUid = _Header.HosId

{
 key zdb_hospital_itm.pat_uid as PatUid,
 key zdb_hospital_itm.hosp_uid as HospUid,
 zdb_hospital_itm.name as Name,
 zdb_hospital_itm.age as Age,
 zdb_hospital_itm.department as Department,
 zdb_hospital_itm.currency as Currency,
 zdb_hospital_itm.place as Place,
 zdb_hospital_itm.authority,
 _Header  //expose 
}
