CLASS zcl_leave_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.



CLASS zcl_leave_data_generator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


  DATA ls_emp TYPE zemp_master_t.

  ls_emp-client = sy-mandt.
  ls_emp-employee_id = '0000000001'.
  ls_emp-employee_name = 'John Smith'.
  ls_emp-department = 'IT'.
  ls_emp-email = 'john@example.com'.
  ls_emp-phone = '9876543210'.
  ls_emp-joining_date = '20240101'.
  ls_emp-leave_balance = 20.

  INSERT zemp_master_t FROM @ls_emp.

  CLEAR ls_emp.

  ls_emp-client = sy-mandt.
  ls_emp-employee_id = '0000000002'.
  ls_emp-employee_name = 'Priya Patel'.
  ls_emp-department = 'HR'.
  ls_emp-email = 'priya@example.com'.
  ls_emp-phone = '9876543211'.
  ls_emp-joining_date = '20240115'.
  ls_emp-leave_balance = 15.

  INSERT zemp_master_t FROM @ls_emp.

  out->write( 'Employee records inserted' ).

  DATA ls_type TYPE zleave_type_t.

 ls_type-client = sy-mandt.
 ls_type-leave_type_id = '001'.
 ls_type-leave_name = 'Sick Leave'.
 ls_type-max_days = 10.
 INSERT zleave_type_t FROM @ls_type.

 CLEAR ls_type.

 ls_type-client = sy-mandt.
 ls_type-leave_type_id = '002'.
 ls_type-leave_name = 'Casual Leave'.
 ls_type-max_days = 15.
 INSERT zleave_type_t FROM @ls_type.

 CLEAR ls_type.

 ls_type-client = sy-mandt.
 ls_type-leave_type_id = '003'.
 ls_type-leave_name = 'Earned Leave'.
 ls_type-max_days = 30.
 INSERT zleave_type_t FROM @ls_type.

 out->write( 'Leave Type records inserted' ).

 DATA ls_status TYPE zleave_status_t.

 ls_status-client = sy-mandt.
 ls_status-status_id = '001'.
 ls_status-status_name = 'Pending'.
 INSERT zleave_status_t FROM @ls_status.

 CLEAR ls_status.

 ls_status-client = sy-mandt.
 ls_status-status_id = '002'.
 ls_status-status_name = 'Approved'.
 INSERT zleave_status_t FROM @ls_status.

 CLEAR ls_status.

 ls_status-client = sy-mandt.
 ls_status-status_id = '003'.
 ls_status-status_name = 'Rejected'.
 INSERT zleave_status_t FROM @ls_status.

 out->write( 'Leave Status records inserted' ).

 DATA ls_leave TYPE zleave_reque.

CLEAR ls_leave.

ls_leave-client        = sy-mandt.
ls_leave-leave_id      = '0000000001'.
ls_leave-employee_id   = '0000000001'.
ls_leave-leave_type_id = '00001'.
ls_leave-from_date     = '20260615'.
ls_leave-to_date       = '20260617'.
ls_leave-reason        = 'Medical Leave'.
ls_leave-status_id     = '001'.
ls_leave-applied_on    = '090000'.

INSERT zleave_reque FROM @ls_leave.

CLEAR ls_leave.

ls_leave-client        = sy-mandt.
ls_leave-leave_id      = '0000000002'.
ls_leave-employee_id   = '0000000002'.
ls_leave-leave_type_id = '00002'.
ls_leave-from_date     = '20260620'.
ls_leave-to_date       = '20260622'.
ls_leave-reason        = 'Family Function'.
ls_leave-status_id     = '002'.
ls_leave-applied_on    = '100000'.

INSERT zleave_reque FROM @ls_leave.

out->write( 'Leave Request records inserted' ).

  ENDMETHOD.

ENDCLASS.
