@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'consumption view for hospital'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_HOSPITAL  as projection on
Ziv_Hospital
{
     @UI.hidden: true
      key HosId,
      HosName,
      Street,
      @Semantics.address.zipCode: true
      PostalCode,
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZIV_VALUEHELP', element: 'city' }, 
      additionalBinding: [{ localElement: 'HosName',element: 'hosName' }]  }]
      City,
      @Semantics.telephone.type: [ #CELL ]
      ContactNumber,
      @Semantics.eMail.address: true
      EmailAddress,
      @EndUserText.label: 'Created By'
    
      Createdby,
      @EndUserText.label: 'Created At'
      
      Createdat,
      @EndUserText.label: 'Last Changed By'
   
      Lastchangedby,
      @EndUserText.label: 'Last Changed At'
   
      Lastchangedat,
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZIV_DROPDOWN', element: 'text' }}]
      Authority,
      Action,
      Active,
      SoftDele,   
      Hospital_status,
      Hospital_condition,
      crtitalstatus,      
     @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HIDETAB'  
     virtual vi_items : abap_boolean,
      _Item : redirected to composition child ZC_PATIENT,
      _Doctor: redirected to composition child Zc_Doctor,
      _Appoint : redirected to composition child ZC_APPOINMENT
}
    
 