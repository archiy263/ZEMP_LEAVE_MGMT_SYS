CLASS zcl_leave_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_leave_data_generator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "============================================================
    " 1. Insert Employee Master Data
    "============================================================

    DATA ls_emp TYPE zemp_master_t.

    CLEAR ls_emp.

    ls_emp-client        = sy-mandt.
    ls_emp-employee_id   = '0000000001'.
    ls_emp-employee_name = 'John Smith'.
    ls_emp-department    = 'IT'.
    ls_emp-email         = 'john@example.com'.
    ls_emp-phone         = '9876543210'.
    ls_emp-joining_date  = '20240101'.
    ls_emp-leave_balance = 0.

    INSERT zemp_master_t FROM @ls_emp.

    IF sy-subrc = 0.
      out->write( 'Employee 0000000001 inserted successfully' ).
    ELSE.
      out->write( 'Employee 0000000001 was not inserted' ).
    ENDIF.


    CLEAR ls_emp.

    ls_emp-client        = sy-mandt.
    ls_emp-employee_id   = '0000000002'.
    ls_emp-employee_name = 'Priya Patel'.
    ls_emp-department    = 'HR'.
    ls_emp-email         = 'priya@example.com'.
    ls_emp-phone         = '9876543211'.
    ls_emp-joining_date  = '20240115'.
    ls_emp-leave_balance = 0.

    INSERT zemp_master_t FROM @ls_emp.

    IF sy-subrc = 0.
      out->write( 'Employee 0000000002 inserted successfully' ).
    ELSE.
      out->write( 'Employee 0000000002 was not inserted' ).
    ENDIF.


    "============================================================
    " 2. Insert Leave Type Master Data
    "============================================================

    DATA ls_type TYPE zleave_type_t.

    CLEAR ls_type.

    ls_type-client        = sy-mandt.
    ls_type-leave_type_id = '001'.
    ls_type-leave_name    = 'Sick Leave'.
    ls_type-max_days      = 10.

    INSERT zleave_type_t FROM @ls_type.

    IF sy-subrc = 0.
      out->write( 'Sick Leave type inserted successfully' ).
    ELSE.
      out->write( 'Sick Leave type was not inserted' ).
    ENDIF.


    CLEAR ls_type.

    ls_type-client        = sy-mandt.
    ls_type-leave_type_id = '002'.
    ls_type-leave_name    = 'Casual Leave'.
    ls_type-max_days      = 15.

    INSERT zleave_type_t FROM @ls_type.

    IF sy-subrc = 0.
      out->write( 'Casual Leave type inserted successfully' ).
    ELSE.
      out->write( 'Casual Leave type was not inserted' ).
    ENDIF.


    CLEAR ls_type.

    ls_type-client        = sy-mandt.
    ls_type-leave_type_id = '003'.
    ls_type-leave_name    = 'Earned Leave'.
    ls_type-max_days      = 30.

    INSERT zleave_type_t FROM @ls_type.

    IF sy-subrc = 0.
      out->write( 'Earned Leave type inserted successfully' ).
    ELSE.
      out->write( 'Earned Leave type was not inserted' ).
    ENDIF.


    "============================================================
    " 3. Insert Leave Status Master Data
    "============================================================

    DATA ls_status TYPE zleave_status_t.

    CLEAR ls_status.

    ls_status-client      = sy-mandt.
    ls_status-status_id   = '001'.
    ls_status-status_name = 'Pending'.

    INSERT zleave_status_t FROM @ls_status.

    IF sy-subrc = 0.
      out->write( 'Pending status inserted successfully' ).
    ELSE.
      out->write( 'Pending status was not inserted' ).
    ENDIF.


    CLEAR ls_status.

    ls_status-client      = sy-mandt.
    ls_status-status_id   = '002'.
    ls_status-status_name = 'Approved'.

    INSERT zleave_status_t FROM @ls_status.

    IF sy-subrc = 0.
      out->write( 'Approved status inserted successfully' ).
    ELSE.
      out->write( 'Approved status was not inserted' ).
    ENDIF.


    CLEAR ls_status.

    ls_status-client      = sy-mandt.
    ls_status-status_id   = '003'.
    ls_status-status_name = 'Rejected'.

    INSERT zleave_status_t FROM @ls_status.

    IF sy-subrc = 0.
      out->write( 'Rejected status inserted successfully' ).
    ELSE.
      out->write( 'Rejected status was not inserted' ).
    ENDIF.


    "============================================================
    " 4. Insert Leave Request Data
    "============================================================

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

    IF sy-subrc = 0.
      out->write( 'Leave request 0000000001 inserted successfully' ).
    ELSE.
      out->write( 'Leave request 0000000001 was not inserted' ).
    ENDIF.


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

    IF sy-subrc = 0.
      out->write( 'Leave request 0000000002 inserted successfully' ).
    ELSE.
      out->write( 'Leave request 0000000002 was not inserted' ).
    ENDIF.


    "============================================================
    " 5. Insert Employee Leave Balance Data
    "============================================================

    DATA ls_balance TYPE zemp_leave_bal_t.


    "------------------------------------------------------------
    " Employee 0000000001 - Sick Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000001'.
    ls_balance-leave_type_id = '00001'.
    ls_balance-total_days    = 10.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'John Sick Leave balance inserted successfully' ).
    ELSE.
      out->write( 'John Sick Leave balance was not inserted' ).
    ENDIF.


    "------------------------------------------------------------
    " Employee 0000000001 - Casual Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000001'.
    ls_balance-leave_type_id = '00002'.
    ls_balance-total_days    = 15.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'John Casual Leave balance inserted successfully' ).
    ELSE.
      out->write( 'John Casual Leave balance was not inserted' ).
    ENDIF.


    "------------------------------------------------------------
    " Employee 0000000001 - Earned Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000001'.
    ls_balance-leave_type_id = '00003'.
    ls_balance-total_days    = 30.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'John Earned Leave balance inserted successfully' ).
    ELSE.
      out->write( 'John Earned Leave balance was not inserted' ).
    ENDIF.


    "------------------------------------------------------------
    " Employee 0000000002 - Sick Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000002'.
    ls_balance-leave_type_id = '00001'.
    ls_balance-total_days    = 10.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'Priya Sick Leave balance inserted successfully' ).
    ELSE.
      out->write( 'Priya Sick Leave balance was not inserted' ).
    ENDIF.


    "------------------------------------------------------------
    " Employee 0000000002 - Casual Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000002'.
    ls_balance-leave_type_id = '00002'.
    ls_balance-total_days    = 15.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'Priya Casual Leave balance inserted successfully' ).
    ELSE.
      out->write( 'Priya Casual Leave balance was not inserted' ).
    ENDIF.


    "------------------------------------------------------------
    " Employee 0000000002 - Earned Leave
    "------------------------------------------------------------

    CLEAR ls_balance.

    ls_balance-client        = sy-mandt.
    ls_balance-employee_id   = '0000000002'.
    ls_balance-leave_type_id = '00003'.
    ls_balance-total_days    = 30.
    ls_balance-used_days     = 0.
    ls_balance-reserved_days = 0.

    INSERT zemp_leave_bal_t FROM @ls_balance.

    IF sy-subrc = 0.
      out->write( 'Priya Earned Leave balance inserted successfully' ).
    ELSE.
      out->write( 'Priya Earned Leave balance was not inserted' ).
    ENDIF.


    "============================================================
    " Final Output
    "============================================================

    out->write( '----------------------------------------' ).
    out->write( 'Data generation completed' ).
    out->write( '----------------------------------------' ).

  ENDMETHOD.

ENDCLASS.
