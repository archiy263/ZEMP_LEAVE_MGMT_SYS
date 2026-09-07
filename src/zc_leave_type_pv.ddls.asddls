@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Type Projection CDS'

@UI.headerInfo: {
  typeName: 'Leave Type',
  typeNamePlural: 'Leave Types',
  title: {
      value: 'LeaveName'
  }
}

define root view entity ZC_LEAVE_TYPE_pv
  provider contract transactional_query
  as projection on ZR_LEAVE_TYPE_CDS
{
    @UI.lineItem: [{ position: 10 }]
    key LeaveTypeID,

    @UI.lineItem: [{ position: 20 }]
    LeaveName,

    @UI.lineItem: [{ position: 30 }]
    MaxDays
}
