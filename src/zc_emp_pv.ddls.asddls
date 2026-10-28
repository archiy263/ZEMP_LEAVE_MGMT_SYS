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
  @UI.lineItem: [
    {
      position        : 10,
      importance      : #HIGH,
      cssDefault.width: '6rem'
    }
  ]
  @UI.identification: [{ position: 10 }]
  key EmployeeID,
  
  @EndUserText.label: 'Manager ID'
  @UI.lineItem: [
  {
    position        : 25,
    importance      : #HIGH,
    label           : 'Manager ID',
    cssDefault.width: '8rem'
  }
]
@UI.identification: [{ position: 25 }]
ManagerID,


@EndUserText.label: 'Manager'
@UI.lineItem: [
  {
    position        : 30,
    importance      : #HIGH,
    label           : 'Manager',
    cssDefault.width: '11rem'
  }
]
@UI.identification: [{ position: 30 }]
_Manager.EmployeeName as ManagerName,
  

  @EndUserText.label: 'Employee Name'
  @UI.lineItem: [
    {
      position        : 20,
      importance      : #HIGH,
      cssDefault.width: '11rem'
    }
  ]
  @UI.identification: [{ position: 20 }]
  EmployeeName,

  @EndUserText.label: 'Department'
  @UI.lineItem: [
    {
      position        : 30,
      importance      : #HIGH,
      cssDefault.width: '9rem'
    }
  ]
  @UI.identification: [{ position: 30 }]
  Department,

  @EndUserText.label: 'Email'
  @UI.lineItem: [
    {
      position        : 40,
      importance      : #HIGH,
      cssDefault.width: '15rem'
    }
  ]
  @UI.identification: [{ position: 40 }]
  Email,

  @EndUserText.label: 'Phone'
  @UI.lineItem: [
    {
      position        : 50,
      importance      : #MEDIUM,
      cssDefault.width: '9rem'
    }
  ]
  @UI.identification: [{ position: 50 }]
  Phone,

  @EndUserText.label: 'Leave Balance'
  @UI.lineItem: [
    {
      position        : 60,
      importance      : #MEDIUM,
      label           : 'Balance',
      cssDefault.width: '7rem'
    }
  ]
  @UI.identification: [{ position: 60 }]
  LeaveBalance,
  
  _Manager,

  _LeaveAnalytics : redirected to ZC_LEAVE_ANALYTICS,
  
  _LeaveKPI : redirected to ZC_LEAVE_KPI
}
