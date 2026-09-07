@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Status Projection CDS'

@UI.headerInfo: {
  typeName: 'Leave Status',
  typeNamePlural: 'Leave Statuses',
  title: {
    value: 'StatusName'
  }
}

define root view entity ZC_LEAVE_STATUS_pv
  provider contract transactional_query
  as projection on ZR_LEAVE_STATUS_cds
{
    @UI.lineItem: [{ position: 10 }]
    key StatusID,

    @UI.lineItem: [{ position: 20 }]
    StatusName
}
