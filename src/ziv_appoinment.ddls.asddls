@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Appoinment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZIV_APPOINMENT as select from zdb_appoinment as _appoint
association to parent Ziv_Hospital as _header on $projection.HosUid = _header.HosId 
{

    key _appoint.opatid as Opatid,
    key _appoint.hos_uid as HosUid,
    _appoint.name as Name,
    _appoint.age as Age,
    _appoint.cause as Cause,
    _appoint.appoinment_no as AppoinmentNo,
    _appoint.doc_uid as DocUid,
    _appoint.zdate as Zdate,
    _appoint.place as Place,
    _appoint.amount as Amount ,
    _header 
}
