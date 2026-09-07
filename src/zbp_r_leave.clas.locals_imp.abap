CLASS lsc_zr_leave DEFINITION INHERITING FROM cl_abap_behavior_saver.
ENDCLASS.

CLASS lsc_zr_leave IMPLEMENTATION.


ENDCLASS.

CLASS lhc_ZR_LEAVE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Leave RESULT result.

    METHODS validateLeaveBalance FOR VALIDATE ON SAVE
      IMPORTING keys FOR Leave~validateLeaveBalance.

    METHODS Approve
  FOR MODIFY
  IMPORTING keys FOR ACTION Leave~Approve
  RESULT result.

   METHODS Reject
  FOR MODIFY
  IMPORTING keys FOR ACTION Leave~Reject
  RESULT result.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Leave~setDefaultStatus.

    METHODS validateOverlapLeave FOR VALIDATE ON SAVE
      IMPORTING keys FOR Leave~validateOverlapLeave.




ENDCLASS.

CLASS lhc_ZR_LEAVE IMPLEMENTATION.

METHOD get_global_authorizations.

  result-%create = if_abap_behv=>auth-allowed.
  result-%update = if_abap_behv=>auth-allowed.
  result-%delete = if_abap_behv=>auth-allowed.

ENDMETHOD.


METHOD validateLeaveBalance.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    SELECT SINGLE leave_balance
      FROM zemp_master_t
      WHERE employee_id = @ls_leave-EmployeeID
      INTO @DATA(lv_balance).

    DATA(lv_days) =
      ls_leave-ToDate - ls_leave-FromDate + 1.

    IF lv_balance < lv_days.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '001'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD setDefaultStatus.

  MODIFY ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    UPDATE FIELDS ( StatusID )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky     = key-%tky
        StatusID = 1
      )
    ).

ENDMETHOD.

  METHOD validateOverlapLeave.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    SELECT SINGLE leave_id
      FROM zleave_reque
      WHERE employee_id = @ls_leave-EmployeeID
      AND leave_id <> @ls_leave-LeaveID
      AND from_date <= @ls_leave-ToDate
      AND to_date >= @ls_leave-FromDate
      INTO @DATA(lv_overlap).

    IF sy-subrc = 0.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '002'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD Approve.

  MODIFY ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    UPDATE FIELDS ( StatusID )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky     = key-%tky
        StatusID = 2
      )
    ).

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls IN lt_result
    (
      %tky   = ls-%tky
      %param = ls
    )
  ).


ENDMETHOD.


METHOD Reject.

  MODIFY ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    UPDATE FIELDS ( StatusID )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky     = key-%tky
        StatusID = 3
      )
    ).

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls IN lt_result
    (
      %tky   = ls-%tky
      %param = ls
    )
  ).

ENDMETHOD.
ENDCLASS.
