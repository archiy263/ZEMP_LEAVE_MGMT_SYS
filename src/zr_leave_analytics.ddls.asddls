
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manager Leave Analytics'

define root view entity ZR_LEAVE_ANALYTICS
  as select from zemp_master_t as Employee
    left outer join zleave_reque_v2 as Leave
      on Employee.employee_id = Leave.employee_id
{
  key Employee.manager_id   as ManagerID,
  key Employee.employee_id  as EmployeeID,

      Employee.employee_name as EmployeeName,
      Employee.department    as Department,
      Employee.joining_date  as JoiningDate,
      Employee.leave_balance as LeaveBalance,

      cast(
        sum(
          case
            when Leave.leave_uuid is not null then 1
            else 0
          end
        ) as abap.int4
      ) as TotalLeaveRequests,

      cast(
        sum(
          case
            when Leave.status_id = '001' then 1
            else 0
          end
        ) as abap.int4
      ) as PendingLeaveCount,

      cast(
        sum(
          case
            when Leave.status_id = '002' then 1
            else 0
          end
        ) as abap.int4
      ) as ApprovedLeaveCount,

      cast(
        sum(
          case
            when Leave.status_id = '003' then 1
            else 0
          end
        ) as abap.int4
      ) as RejectedLeaveCount
}
group by
  Employee.manager_id,
  Employee.employee_id,
  Employee.employee_name,
  Employee.department,
  Employee.joining_date,
  Employee.leave_balance
