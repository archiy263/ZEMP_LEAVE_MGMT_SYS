@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Root CDS View'

define root view entity ZR_EMP_CDS
  as select from zemp_master_t as Employee
{

  key Employee.employee_id           as EmployeeID,
      Employee.employee_name         as EmployeeName,
      Employee.department            as Department,
      Employee.email                 as Email,
      Employee.phone                 as Phone,
      Employee.joining_date          as JoiningDate,
      Employee.leave_balance         as LeaveBalance,
      Employee.last_changed_at       as LastChangedAt,
      Employee.locinst_lastchange_at as LocinstLastchangeAt

}
