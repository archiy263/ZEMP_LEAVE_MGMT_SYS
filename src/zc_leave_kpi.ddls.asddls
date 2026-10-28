@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Leave KPI Projection'

define root view entity ZC_LEAVE_KPI
  provider contract transactional_query
  as projection on ZR_LEAVE_KPI
{
  key EmployeeID,
      LeaveBalance,
      LeaveTarget,
      LeaveUsed
}
