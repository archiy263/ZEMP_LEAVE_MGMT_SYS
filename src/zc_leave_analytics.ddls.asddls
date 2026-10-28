@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manager Leave Analytics'
@Metadata.allowExtensions: true
@OData.applySupportedForAggregation: #FULL

define root view entity ZC_LEAVE_ANALYTICS
  provider contract transactional_query
  as projection on ZR_LEAVE_ANALYTICS
{
  key ManagerID,
  key EmployeeID,

      EmployeeName,
      Department,
      JoiningDate,
      LeaveBalance,

  @Aggregation.default: #SUM
  @EndUserText.label: 'Total Requests'
  TotalLeaveRequests,

  @Aggregation.default: #SUM
  @EndUserText.label: 'Pending Requests'
  PendingLeaveCount,

  @Aggregation.default: #SUM
  @EndUserText.label: 'Approved Requests'
  ApprovedLeaveCount,

  @Aggregation.default: #SUM
  @EndUserText.label: 'Rejected Requests'
  RejectedLeaveCount
}
