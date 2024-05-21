 @AbapCatalog.sqlViewName: 'ZIV_DOCTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Doctor'
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MASTER
}
define view ZIV_DOCTOR as select from zdb_doctor as _Doctor
association to parent Ziv_Hospital as _Header on $projection.HosUid = _Header.HosId
{
    key doc_uid as DocUid,
    key hos_uid as HosUid,
    name as Name,
    age as Age,
    department as Department,
    status as Status,
    case 
    when status = 'X' then 'yes'
    else 'No'
    end as status_data,
    authority as Authority,
    place as Place,
    _Header
    
}
