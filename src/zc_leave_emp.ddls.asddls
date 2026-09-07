@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Projection CDS'
@Metadata.allowExtensions: true

@UI.headerInfo: {
  typeName: 'Leave Request',
  typeNamePlural: 'Leave Requests',
  title: {
    value: 'LeaveID'
  }
}

define root view entity ZC_LEAVE_EMP
provider contract transactional_query
as projection on ZR_LEAVE
{

  @EndUserText.label: 'Leave ID'
  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  key LeaveID,

  @EndUserText.label: 'Employee'
  @UI.lineItem: [{ position: 20 }]
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
  @UI.lineItem: [{ position: 30 }]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [{ position: 30 }]
  @ObjectModel.text.element: ['LeaveName']
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_LEAVE_TYPE_pv',
        element: 'LeaveTypeID'
      }
    }
  ]
  LeaveTypeID,

  @EndUserText.label: 'From Date'
  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
  FromDate,

  @EndUserText.label: 'To Date'
  @UI.lineItem: [{ position: 50 }]
  @UI.identification: [{ position: 50 }]
  ToDate,

  @EndUserText.label: 'Status'
  @UI.lineItem: [{ position: 60 }]
  @UI.selectionField: [{ position: 30 }]
  @UI.identification: [{ position: 60 }]
  @ObjectModel.text.element: ['StatusName']
  @UI.hidden: true
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_LEAVE_STATUS_pv',
        element: 'StatusID'
      }
    }
  ]
  StatusID,

  @EndUserText.label: 'Applied On'
  @UI.lineItem: [{ position: 70 }]
  @UI.identification: [{ position: 70 }]
  AppliedOn,

  @EndUserText.label: 'Reason'
  @UI.identification: [{ position: 80 }]
  Reason,

  _Employee.EmployeeName,
  _LeaveType.LeaveName,
  _Status.StatusName

}
