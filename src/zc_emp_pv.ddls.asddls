@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Projection CDS'

@UI.headerInfo: {
  typeName: 'Employee',
  typeNamePlural: 'Employees',
  title: {
      value: 'EmployeeName'
  }
}

define root view entity ZC_EMP_PV
  provider contract transactional_query
  as projection on ZR_EMP_CDS
{

  @EndUserText.label: 'Employee ID'
  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  key EmployeeID,

  @EndUserText.label: 'Employee Name'
  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  EmployeeName,

  @EndUserText.label: 'Department'
  @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
  Department,

  @EndUserText.label: 'Email'
  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
  Email,

  @EndUserText.label: 'Phone'
  @UI.lineItem: [{ position: 50 }]
  @UI.identification: [{ position: 50 }]
  Phone,

  @EndUserText.label: 'Leave Balance'
  @UI.lineItem: [{ position: 60 }]
  @UI.identification: [{ position: 60 }]
  LeaveBalance

}
