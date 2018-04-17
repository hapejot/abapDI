*"* use this source file for your ABAP unit test classes
CLASS ltcl_di_container DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:

      is_interface_correct FOR TESTING RAISING cx_static_check,
      is_class_correct FOR TESTING RAISING cx_static_check,
      instance_std_class FOR TESTING RAISING cx_static_check,
      instace_no_constructor FOR TESTING RAISING cx_static_check,
      instance_cons_mix_params FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_di_container IMPLEMENTATION.

  METHOD is_interface_correct.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_gol_world' i_cl = 'zcl_gol_world'  ).
    DATA(d) = cut->get_instance( 'zif_gol_world' ).
    DATA(result) = CAST zif_gol_world( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

  METHOD is_class_correct.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_gol_world' i_cl = 'zcl_gol_world'  ).
    DATA(d) = cut->get_instance( 'zif_gol_world' ).
    DATA(result) = CAST zcl_gol_world( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

  METHOD instance_std_class.
    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_gol_world' i_cl = 'zcl_gol_world'  ).
    DATA(d) = cut->get_instance( 'zcl_gol_display' ).
    DATA(result) = CAST zcl_gol_display( d ).
    cl_abap_unit_assert=>assert_bound( msg = 'msg' act = result ).
  ENDMETHOD.

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
