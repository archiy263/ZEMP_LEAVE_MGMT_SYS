@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Request Root CDS View'

define root view entity ZR_LEAVE
  as select from zleave_reque

  association [0..1] to ZR_EMP_CDS       as _Employee
      on $projection.EmployeeID = _Employee.EmployeeID

  association [0..1] to ZR_LEAVE_TYPE_CDS    as _LeaveType
      on $projection.LeaveTypeID = _LeaveType.LeaveTypeID

  association [0..1] to ZR_LEAVE_STATUS_cds  as _Status
      on $projection.StatusID = _Status.StatusID

{
    key leave_id      as LeaveID,

        employee_id   as EmployeeID,
        leave_type_id as LeaveTypeID,
        from_date     as FromDate,
        to_date       as ToDate,
        reason        as Reason,
        status_id     as StatusID,
        applied_on    as AppliedOn,
       last_changed_at       as LastChangedAt,
    locinst_lastchange_at as LocinstLastchangeAt,
        

        _Employee,
        _LeaveType,
        _Status
}
