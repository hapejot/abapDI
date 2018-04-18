*"* use this source file for your ABAP unit test classes
CLASS ltcl_di_container DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:

      instace_no_constructor FOR TESTING RAISING cx_static_check,
      instance_cons_mix_params FOR TESTING RAISING cx_static_check.
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

ENDCLASS.
