CLASS zcl_create_leave_nr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_create_leave_nr IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA:
      lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,
      lt_interval TYPE cl_numberrange_intervals=>nr_interval,
      ls_interval TYPE cl_numberrange_intervals=>nr_nriv_line.

    lv_object = 'ZLEAVE_ID'.

    ls_interval-nrrangenr  = '01'.
    ls_interval-fromnumber = '0000000001'.
    ls_interval-tonumber   = '9999999999'.
    ls_interval-procind    = 'I'.

    APPEND ls_interval TO lt_interval.

    TRY.

        cl_numberrange_intervals=>create(
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

        IF lv_error IS INITIAL.

          out->write( 'Number range interval created successfully.' ).
          out->write( 'Object: ZLEAVE_ID' ).
          out->write( 'Interval: 01' ).
          out->write( 'From: 0000000001' ).
          out->write( 'To: 9999999999' ).

        ELSE.

          out->write( 'Error while creating number range interval.' ).

        ENDIF.

      CATCH cx_root INTO DATA(lx_error).

        out->write( lx_error->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
