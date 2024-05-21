@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface view for Hospital'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Ziv_Hospital as select from zdb_hospital_hd
composition [0..*] of ZIV_PATIENT as _Item 
composition [0..*] of ZIV_DOCTOR as _Doctor
composition [0..*] of ZIV_APPOINMENT as _Appoint   
{
    key zdb_hospital_hd.hos_id as HosId,
    zdb_hospital_hd.hos_name as HosName,
    zdb_hospital_hd.street as Street,
    zdb_hospital_hd.postal_code as PostalCode,
    zdb_hospital_hd.city as City,
    zdb_hospital_hd.contact_number as ContactNumber,
    zdb_hospital_hd.currency as Currency, 
    zdb_hospital_hd.active as Active,
    zdb_hospital_hd.email_address as EmailAddress,
     @Semantics.user.createdBy: true
    zdb_hospital_hd.createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    zdb_hospital_hd.createdat as Createdat,
       @Semantics.user.localInstanceLastChangedBy: true
    zdb_hospital_hd.lastchangedby as Lastchangedby,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
    zdb_hospital_hd.lastchangedat as Lastchangedat,
    zdb_hospital_hd.authority as Authority,
    zdb_hospital_hd.soft_dele as SoftDele,
   zdb_hospital_hd.action as Action,
    
      case 
      when action = 'A' then 'Approved Hospitality'
      when action = 'R' then 'Rejected Hospitality'
      else  'Hospitality'
      end as Hospital_status,
      soft_dele,
      case 
      when soft_dele = 'X' then 'Deleted'
      else 'Stored'
      end as Hospital_condition,
      case action 
      when 'A' then 3
      when 'R' then 1
      else  2
      end as crtitalstatus,
      
       _Item,  //expose
    // Make association public
    _Doctor,
    _Appoint
}
