*"* use this source file for your ABAP unit test classes
CLASS ltcl_di_container DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:

      instace_no_constructor FOR TESTING RAISING cx_static_check,
      instance_from_if FOR TESTING RAISING cx_static_check,
      instance_cons_mix_params FOR TESTING RAISING cx_static_check,
      singelton FOR TESTING RAISING cx_static_check,
      constructor_with_intf FOR TESTING RAISING cx_static_check,
      test5 FOR TESTING RAISING cx_static_check,
      exception FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_di_container IMPLEMENTATION.

  METHOD instace_no_constructor.
    DATA(cut) = NEW zcl_abapdi_container( ).
    DATA(d) = cut->get_instance( 'zcl_abapdi_test_class1' ).
    DATA(result) = CAST zcl_abapdi_test_class1( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

  METHOD instance_cons_mix_params.
    DATA(cut) = NEW zcl_abapdi_container( ).
    DATA(d) = cut->get_instance( 'zcl_abapdi_test_class2' ).
    DATA(result) = CAST zcl_abapdi_test_class2( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

  METHOD instance_from_if.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_abapdi_test' i_cl = 'zcl_abapdi_test_class1' ).


    DATA(d) = cut->get_instance( 'zif_abapdi_test' ).
    cl_abap_unit_assert=>assert_bound( act = cast zif_abapdi_test( d ) ).
    DATA(result) = CAST zcl_abapdi_test_class1( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

  METHOD singelton.

    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_abapdi_test' i_cl = 'zcl_abapdi_test_class1' i_single = abap_true ).
    DATA(d) = CAST zcl_abapdi_test_class1( cut->get_instance( 'zif_abapdi_test' ) ).
    DATA(d2) = CAST zcl_abapdi_test_class1( cut->get_instance( 'zif_abapdi_test' ) ).
    cl_abap_unit_assert=>assert_bound( msg = 'd not bound' act = d ).
    cl_abap_unit_assert=>assert_bound( msg = 'd2 not bound' act = d2 ).
    cl_abap_unit_assert=>assert_equals( msg = 'd and d1 not equal' exp = d act = d2 ).

  ENDMETHOD.

  METHOD constructor_with_intf.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_abapdi_test' i_cl = 'zcl_abapdi_test_class1' i_single = abap_true ).
*    cut->register( i_if = 'zcl_abapdi_test_class3' i_single = abap_true ).
    DATA(d) = CAST zcl_abapdi_test_class3( cut->get_instance( 'zcl_abapdi_test_class3' ) ).
    cl_abap_unit_assert=>assert_bound( msg = 'd not bound' act = d ).
  ENDMETHOD.

  METHOD exception.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_abapdi_test' i_cl = 'zcl_abapdi_test_class2' i_single = abap_true ).
*    cut->register( i_if = 'zcl_abapdi_test_class3' i_single = abap_true ).
    TRY.
        DATA(d) = CAST zcl_abapdi_test_class3( cut->get_instance( 'zcl_abapdi_test_class3' ) ).
        cl_abap_unit_assert=>fail( msg = 'exception not reached' ).
      CATCH cx_abap_invalid_value.
    ENDTRY.
  ENDMETHOD.

  METHOD test5.
  ENDMETHOD.

ENDCLASS.
