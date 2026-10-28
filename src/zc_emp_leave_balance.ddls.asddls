@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Leave Balance'

@UI.headerInfo: {
  typeName: 'Employee Leave Balance',
  typeNamePlural: 'Employee Leave Balances',
  title: { value: 'EmployeeName' }
}

define root view entity ZC_EMP_LEAVE_BALANCE

  provider contract transactional_query

  as projection on ZR_EMP_LEAVE_BALANCE
{
  @EndUserText.label: 'Employee ID'
  @UI.lineItem: [
    {
      position: 10,
      importance: #HIGH,
      cssDefault.width: '6rem'
    }
  ]
  @UI.selectionField: [{ position: 10 }]
  key EmployeeID,

  @EndUserText.label: 'Employee Name'
  @UI.lineItem: [
    {
      position: 20,
      importance: #HIGH,
      cssDefault.width: '12rem'
    }
  ]
  EmployeeName,

  @EndUserText.label: 'Department'
  @UI.lineItem: [
    {
      position: 30,
      importance: #HIGH,
      cssDefault.width: '9rem'
    }
  ]
  Department,

  @EndUserText.label: 'Total Balance'
  @UI.lineItem: [
    {
      position: 40,
      importance: #HIGH,
      cssDefault.width: '9rem'
    }
  ]
  TotalBalance,

  @EndUserText.label: 'Used Days'
  @UI.lineItem: [
    {
      position: 50,
      importance: #HIGH,
      cssDefault.width: '8rem'
    }
  ]
  UsedDays,

  @EndUserText.label: 'Reserved Days'
  @UI.lineItem: [
    {
      position: 60,
      importance: #HIGH,
      cssDefault.width: '9rem'
    }
  ]
  ReservedDays,

  @EndUserText.label: 'Remaining Days'
  @UI.lineItem: [
    {
      position: 70,
      importance: #HIGH,
      cssDefault.width: '10rem'
    }
  ]
  RemainingDays
}
