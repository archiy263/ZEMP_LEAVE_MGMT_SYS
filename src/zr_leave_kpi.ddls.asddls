@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Leave KPI'

define root view entity ZR_LEAVE_KPI
  as select from zemp_master_t as Employee
{
  key Employee.employee_id   as EmployeeID,

      Employee.leave_balance as LeaveBalance,

      12 as LeaveTarget,

      cast(
        12 - Employee.leave_balance
        as abap.int4
      ) as LeaveUsed
}
