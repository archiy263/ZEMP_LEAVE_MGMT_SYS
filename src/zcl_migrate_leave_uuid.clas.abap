CLASS zcl_migrate_leave_uuid DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_migrate_leave_uuid IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT *
      FROM zleave_reque
      INTO TABLE @DATA(lt_old_data).

    IF lt_old_data IS INITIAL.

      out->write( 'No existing leave records found.' ).
      RETURN.

    ENDIF.

    DATA lv_count TYPE i.

    LOOP AT lt_old_data INTO DATA(ls_old).

      DATA lv_uuid TYPE sysuuid_x16.

      TRY.

          lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

        CATCH cx_uuid_error INTO DATA(lx_uuid).

          out->write(
            |UUID generation failed for Leave ID { ls_old-leave_id }: { lx_uuid->get_text( ) }|
          ).

          CONTINUE.

      ENDTRY.


      DATA(ls_new) = VALUE zleave_reque_v2(

        client                = ls_old-client
        leave_uuid            = lv_uuid
        leave_number          = ls_old-leave_id

        employee_id           = ls_old-employee_id
        leave_type_id         = ls_old-leave_type_id

        from_date             = ls_old-from_date
        to_date               = ls_old-to_date

        reason                = ls_old-reason

        status_id             = ls_old-status_id

        applied_on            = ls_old-applied_on

        created_by            = ls_old-created_by
        created_at            = ls_old-created_at

        last_changed_by       = ls_old-last_changed_by
        last_changed_at       = ls_old-last_changed_at

        locinst_lastchange_at = ls_old-locinst_lastchange_at

      ).


      INSERT zleave_reque_v2 FROM @ls_new.

      IF sy-subrc = 0.

        lv_count = lv_count + 1.

      ELSE.

        out->write(
          |Failed to migrate Leave ID { ls_old-leave_id }.|
        ).

      ENDIF.

    ENDLOOP.


    COMMIT WORK.


    out->write(
      |Migration completed. Records migrated: { lv_count }|
    ).

  ENDMETHOD.

ENDCLASS.
