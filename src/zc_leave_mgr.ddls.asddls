@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Projection CDS'
@Metadata.allowExtensions: true

@UI.headerInfo: {
  typeName: 'Leave Request',
  typeNamePlural: 'Leave Requests',
  title: { value: 'LeaveNumber' }
}

define root view entity ZC_LEAVE_MGR
  provider contract transactional_query
  as projection on ZR_LEAVE
{
@UI.hidden: true
  key LeaveUUID,

  @EndUserText.label: 'Leave ID'
  @UI.lineItem: [
    { position: 10, importance: #HIGH, label: 'Leave ID', cssDefault.width: '7rem' }
  ]
  @UI.identification: [
    { position: 10 }
  ]
  LeaveNumber,

  @EndUserText.label: 'Employee'
  @UI.lineItem: [
    {
      position        : 20,
      importance      : #HIGH,
      label           : 'Employee',
      cssDefault.width: '11rem'
    }
  ]
  @UI.selectionField: [{ position: 10 }]
  @UI.identification: [{ position: 20 }]
  @ObjectModel.text.element: ['EmployeeName']
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_EMP_PV',
        element: 'EmployeeID'
      }
    }
  ]
  EmployeeID,

  @EndUserText.label: 'Leave Type'
  @UI.lineItem: [
    {
      position        : 30,
      importance      : #HIGH,
      label           : 'Leave Type',
      cssDefault.width: '11rem'
    }
  ]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [{ position: 30 }]
  @ObjectModel.text.element: ['LeaveName']
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_LEAVE_TYPE_PV',
        element: 'LeaveTypeID'
      }
    }
  ]
  LeaveTypeID,

  @EndUserText.label: 'From'
  @UI.lineItem: [
    {
      position        : 40,
      importance      : #HIGH,
      label           : 'From',
      cssDefault.width: '8rem'
    }
  ]
  @UI.identification: [{ position: 40 }]
  FromDate,

  @EndUserText.label: 'To'
  @UI.lineItem: [
    {
      position        : 50,
      importance      : #HIGH,
      label           : 'To',
      cssDefault.width: '8rem'
    }
  ]
  @UI.identification: [{ position: 50 }]
  ToDate,

  @EndUserText.label: 'Status'
  @UI.valueCriticality: [
  { value: '001', criticality: #CRITICAL },
  { value: '002', criticality: #POSITIVE },
  { value: '003', criticality: #NEGATIVE }
]
  @UI.lineItem: [
    {
      position        : 60,
      importance      : #HIGH,
      label           : 'Status',
      cssDefault.width: '8rem',
      criticality     : 'StatusCriticality'
    }
  ]
  @UI.selectionField: [{ position: 30 }]
  @UI.identification: [{ position: 60 }]
  @ObjectModel.text.element: ['StatusName']
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_LEAVE_STATUS_PV',
        element: 'StatusID'
      }
    }
  ]
  StatusID,
  
  
  
  @UI.hidden: true
  StatusCriticality,

@EndUserText.label: 'Requested On'
@UI.lineItem: [
  {
    position        : 70,
    importance      : #HIGH,
    label           : 'Requested On',
    cssDefault.width: '12rem'
  }
]
@UI.identification: [{ position: 70 }]
CreatedAt,
  
  

  @EndUserText.label: 'Reason'
  @UI.identification: [{ position: 80 }]
  Reason,

  _Employee.EmployeeName as EmployeeName,
  _Employee.Department   as Department,
  _LeaveType.LeaveName   as LeaveName,
  _Status.StatusName     as StatusName
}
