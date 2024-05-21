//@AbapCatalog.sqlViewName: 'zsd_view'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Association View for Patient and Hospital'
define view entity zc_hos_pat_vw as select from Ziv_Hospital
association [0..1] to ZIV_PATIENT as _patient
    on $projection.HosId = _patient.HospUid
{
key Ziv_Hospital.HosId,
Ziv_Hospital.HosName,
Ziv_Hospital.Street,
Ziv_Hospital.PostalCode,
Ziv_Hospital.City,
Ziv_Hospital.ContactNumber,
Ziv_Hospital.Currency,
Ziv_Hospital.Active,
Ziv_Hospital.EmailAddress,
Ziv_Hospital.Createdby,
Ziv_Hospital.Createdat,
Ziv_Hospital.Lastchangedby,
Ziv_Hospital.Lastchangedat,
Ziv_Hospital.Authority,
Ziv_Hospital.SoftDele,
Ziv_Hospital.Action,
Ziv_Hospital.Hospital_status,
Ziv_Hospital.soft_dele,
Ziv_Hospital.Hospital_condition,
Ziv_Hospital.crtitalstatus,
/* Associations */

    
    _patient // Make association public
}
