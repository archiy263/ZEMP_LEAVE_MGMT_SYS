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

    METHODS validateLeaveDates FOR VALIDATE ON SAVE
     IMPORTING keys FOR Leave~validateLeaveDates.

    METHODS setLeaveNumber FOR DETERMINE ON SAVE
     IMPORTING keys FOR Leave~setLeaveNumber.


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


METHODS get_instance_features
  FOR INSTANCE FEATURES
  IMPORTING keys
    REQUEST requested_features FOR Leave
  RESULT result.

ENDCLASS.

CLASS lhc_ZR_LEAVE IMPLEMENTATION.

METHOD setLeaveNumber.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
      FIELDS ( LeaveNumber )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_leave).

  DELETE lt_leave WHERE LeaveNumber IS NOT INITIAL.

  CHECK lt_leave IS NOT INITIAL.

  TRY.

      cl_numberrange_runtime=>number_get(
        EXPORTING
          nr_range_nr       = '01'
          object            = 'ZLEAVE_ID'
          quantity          = CONV #( lines( lt_leave ) )
        IMPORTING
          number            = DATA(lv_number)
          returncode        = DATA(lv_returncode)
          returned_quantity = DATA(lv_quantity)
      ).

    CATCH cx_number_ranges INTO DATA(lx_number_range).

      LOOP AT lt_leave INTO DATA(ls_error_leave).

        APPEND VALUE #(
          %tky = ls_error_leave-%tky
          %msg = new_message(
            id       = 'ZMSG_LEAVE'
            number   = '004'
            severity = if_abap_behv_message=>severity-error )
        ) TO reported-leave.

      ENDLOOP.

      RETURN.

  ENDTRY.

  IF lv_returncode = 2
     OR lv_returncode = 3.

    LOOP AT lt_leave INTO DATA(ls_failed_leave).

      APPEND VALUE #(
        %tky = ls_failed_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '004'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

    ENDLOOP.

    RETURN.

  ENDIF.

  IF lv_quantity <> lines( lt_leave ).

    LOOP AT lt_leave INTO DATA(ls_quantity_leave).

      APPEND VALUE #(
        %tky = ls_quantity_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '004'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

    ENDLOOP.

    RETURN.

  ENDIF.

  DATA(lv_first_number) = lv_number - lv_quantity.

  DATA lt_update TYPE TABLE FOR UPDATE ZR_LEAVE.

  LOOP AT lt_leave INTO DATA(ls_update_leave).

    lv_first_number = lv_first_number + 1.

    APPEND VALUE #(
      %tky        = ls_update_leave-%tky
      LeaveNumber = lv_first_number
    ) TO lt_update.

  ENDLOOP.

  MODIFY ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
      UPDATE FIELDS ( LeaveNumber )
      WITH lt_update.

ENDMETHOD.

METHOD get_global_authorizations.

  result-%create = if_abap_behv=>auth-allowed.
  result-%update = if_abap_behv=>auth-allowed.
  result-%delete = if_abap_behv=>auth-allowed.

ENDMETHOD.

METHOD get_instance_features.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    FIELDS ( StatusID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  result = VALUE #(
    FOR ls_leave IN lt_leave
    LET lv_enabled = COND #(
      WHEN ls_leave-StatusID = '001'
      THEN if_abap_behv=>fc-o-enabled
      ELSE if_abap_behv=>fc-o-disabled )
    IN
    (
      %tky = ls_leave-%tky

      %features-%action-Approve = lv_enabled
      %features-%action-Reject  = lv_enabled
    )
  ).

ENDMETHOD.

METHOD validateLeaveBalance.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    "------------------------------------------------------------
    " 1. Calculate requested leave days
    "------------------------------------------------------------

    DATA(lv_requested_days) =
      ls_leave-ToDate - ls_leave-FromDate + 1.


    "------------------------------------------------------------
    " 2. Get employee's assigned leave balance
    "------------------------------------------------------------

    SELECT SINGLE leave_balance
      FROM zemp_master_t
      WHERE employee_id = @ls_leave-EmployeeID
      INTO @DATA(lv_employee_balance).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '004'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.


    "------------------------------------------------------------
    " 3. Get maximum entitlement for selected leave type
    "------------------------------------------------------------

    SELECT SINGLE max_days
      FROM zleave_type_t
      WHERE leave_type_id = @ls_leave-LeaveTypeID
      INTO @DATA(lv_max_days).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '004'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.


    "------------------------------------------------------------
    " 4. Read existing requests for this employee
    "------------------------------------------------------------

    SELECT leave_uuid,
           from_date,
           to_date,
           status_id
      FROM zleave_reque_v2
      WHERE employee_id = @ls_leave-EmployeeID
        AND leave_uuid    <> @ls_leave-LeaveUUID
      INTO TABLE @DATA(lt_existing_requests).


    DATA(lv_approved_days) = 0.
    DATA(lv_pending_days)  = 0.


    "------------------------------------------------------------
    " 5. Calculate approved and pending days
    "------------------------------------------------------------

    LOOP AT lt_existing_requests INTO DATA(ls_request).

      DATA(lv_existing_days) =
        ls_request-to_date - ls_request-from_date + 1.

      CASE ls_request-status_id.

        WHEN '002'. " Approved
          lv_approved_days =
            lv_approved_days + lv_existing_days.

        WHEN '001'. " Pending
          lv_pending_days =
            lv_pending_days + lv_existing_days.

      ENDCASE.

    ENDLOOP.


    "------------------------------------------------------------
    " 6. Calculate employee's actual available balance
    "------------------------------------------------------------

    DATA(lv_available_days) =
      lv_employee_balance
      - lv_approved_days
      - lv_pending_days.


    "------------------------------------------------------------
    " 7. Do not allow request beyond employee balance
    "------------------------------------------------------------

    IF lv_requested_days > lv_available_days.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '005'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.


    "------------------------------------------------------------
    " 8. Also enforce leave-type maximum
    "------------------------------------------------------------

    IF lv_requested_days > lv_max_days.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '005'
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

    SELECT SINGLE leave_uuid
      FROM zleave_reque_v2
      WHERE employee_id   = @ls_leave-EmployeeID
        AND leave_type_id = @ls_leave-LeaveTypeID
        AND leave_uuid      <> @ls_leave-LeaveUUID
        AND status_id     IN ( '001', '002' )
        AND from_date     <= @ls_leave-ToDate
        AND to_date       >= @ls_leave-FromDate
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

METHOD validateLeaveDates.

  DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    "------------------------------------------------------------
    " 1. Check whether both dates are entered
    "------------------------------------------------------------
    IF ls_leave-FromDate IS INITIAL
       OR ls_leave-ToDate IS INITIAL.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '006'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.


    "------------------------------------------------------------
    " 2. From Date cannot be later than To Date
    "------------------------------------------------------------
    IF ls_leave-FromDate > ls_leave-ToDate.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '007'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.


    "------------------------------------------------------------
    " 3. Leave dates cannot be in the past
    "------------------------------------------------------------
    IF ls_leave-FromDate < lv_today
       OR ls_leave-ToDate < lv_today.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '008'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

    ENDIF.

  ENDLOOP.

ENDMETHOD.
METHOD Approve.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    "Only Pending requests can be approved
    IF ls_leave-StatusID <> '001'.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '009'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.

    "Change Pending to Approved
    MODIFY ENTITIES OF zr_leave IN LOCAL MODE
      ENTITY Leave
      UPDATE FIELDS ( StatusID )
      WITH VALUE #(
        (
          %tky     = ls_leave-%tky
          StatusID = '002'
        )
      ).

  ENDLOOP.

  "Return updated records
  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
  ).

ENDMETHOD.

METHOD Reject.

  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave).

  LOOP AT lt_leave INTO DATA(ls_leave).

    "Only Pending requests can be rejected
    IF ls_leave-StatusID <> '001'.

      APPEND VALUE #(
        %tky = ls_leave-%tky
      ) TO failed-leave.

      APPEND VALUE #(
        %tky = ls_leave-%tky
        %msg = new_message(
          id       = 'ZMSG_LEAVE'
          number   = '010'
          severity = if_abap_behv_message=>severity-error )
      ) TO reported-leave.

      CONTINUE.

    ENDIF.

    "Change Pending to Rejected
    MODIFY ENTITIES OF zr_leave IN LOCAL MODE
      ENTITY Leave
      UPDATE FIELDS ( StatusID )
      WITH VALUE #(
        (
          %tky     = ls_leave-%tky
          StatusID = '003'
        )
      ).

  ENDLOOP.

  "Return updated records
  READ ENTITIES OF zr_leave IN LOCAL MODE
    ENTITY Leave
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
  ).

ENDMETHOD.
ENDCLASS.
