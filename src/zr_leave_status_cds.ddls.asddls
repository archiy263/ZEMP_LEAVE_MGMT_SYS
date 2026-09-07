@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Status Root CDS View'
define root view entity ZR_LEAVE_STATUS_cds
  as select from zleave_status_t
{
    key status_id      as StatusID,
        status_name    as StatusName
}
