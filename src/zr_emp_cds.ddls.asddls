@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Root CDS View'
define root view entity ZR_EMP_CDS
  as select from zemp_master_t as Employee

  association [0..1] to ZR_EMP_CDS as _Manager
    on $projection.ManagerID = _Manager.EmployeeID

  association [0..*] to ZR_LEAVE_ANALYTICS as _LeaveAnalytics
   on $projection.EmployeeID = _LeaveAnalytics.ManagerID
   
  association [0..1] to ZR_LEAVE_KPI as _LeaveKPI
   on $projection.EmployeeID = _LeaveKPI.EmployeeID
  
{
  key Employee.employee_id           as EmployeeID,
      Employee.manager_id            as ManagerID,
      Employee.employee_name         as EmployeeName,
      Employee.department            as Department,
      Employee.email                 as Email,
      Employee.phone                 as Phone,
      Employee.joining_date          as JoiningDate,
      Employee.leave_balance         as LeaveBalance,
      Employee.last_changed_at       as LastChangedAt,
      Employee.locinst_lastchange_at as LocinstLastchangeAt,

      _Manager,
      _LeaveAnalytics,
      _LeaveKPI
}
