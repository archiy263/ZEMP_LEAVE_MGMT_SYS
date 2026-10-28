CLASS zcl_set_leave_nr_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_set_leave_nr_status IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA:
      lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,
      lt_interval TYPE cl_numberrange_intervals=>nr_interval,
      ls_interval TYPE cl_numberrange_intervals=>nr_nriv_line.

    lv_object = 'ZLEAVE_ID'.

    " Existing interval 01
    ls_interval-nrrangenr   = '01'.
    ls_interval-fromnumber = '0000000001'.
    ls_interval-tonumber   = '9999999999'.

    " Current last-used number
    " Existing Leave IDs are 0000000001 - 0000000008
    ls_interval-nrlevel     = '0000000008'.

    " Update existing interval
    ls_interval-procind     = 'U'.

    APPEND ls_interval TO lt_interval.

    TRY.

        cl_numberrange_intervals=>update(
          EXPORTING
            interval  = lt_interval
            object    = lv_object
            subobject = ' '
          IMPORTING
            error     = DATA(lv_error)
            error_inf = DATA(ls_error)
            error_iv  = DATA(lt_error_iv)
            warning   = DATA(lv_warning)
        ).

        IF lv_error = abap_true.

          out->write( 'ERROR: Number range status could not be updated.' ).

        ELSE.

          out->write( 'Number range status updated successfully.' ).
          out->write( 'Object: ZLEAVE_ID' ).
          out->write( 'Interval: 01' ).
          out->write( 'Current status: 0000000008' ).
          out->write( 'Next generated number: 0000000009' ).

        ENDIF.

      CATCH cx_root INTO DATA(lx_error).

        out->write(
          |Error: { lx_error->get_text( ) }|
        ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
