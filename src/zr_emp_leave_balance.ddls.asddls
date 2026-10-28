@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Employee Leave Balance'

define root view entity ZR_EMP_LEAVE_BALANCE

  as select from zemp_master_t as emp

    left outer join zleave_reque as leave

      on emp.employee_id = leave.employee_id

{
  key emp.employee_id as EmployeeID,

      emp.employee_name as EmployeeName,

      emp.department as Department,

      emp.leave_balance as TotalBalance,

      sum(
        case
          when leave.status_id = '002'
          then
            dats_days_between(
              leave.from_date,
              leave.to_date
            ) + 1
          else 0
        end
      ) as UsedDays,

      sum(
        case
          when leave.status_id = '001'
          then
            dats_days_between(
              leave.from_date,
              leave.to_date
            ) + 1
          else 0
        end
      ) as ReservedDays,

      emp.leave_balance

      -

      sum(
        case
          when leave.status_id = '002'
          then
            dats_days_between(
              leave.from_date,
              leave.to_date
            ) + 1
          else 0
        end
      )

      -

      sum(
        case
          when leave.status_id = '001'
          then
            dats_days_between(
              leave.from_date,
              leave.to_date
            ) + 1
          else 0
        end
      ) as RemainingDays
}

group by
  emp.employee_id,
  emp.employee_name,
  emp.department,
  emp.leave_balance;
