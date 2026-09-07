@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Type Root CDS View'
define root view entity ZR_LEAVE_TYPE_CDS
  as select from zleave_type_t
{
    key leave_type_id    as LeaveTypeID,
        leave_name       as LeaveName,
        max_days         as MaxDays
}
