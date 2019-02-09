# abapDI
Dependency Injection Container for ABAP

Usage

Singleton

    DATA(cut) = NEW zcl_abapdi_container( ).
    cut->register( i_if = 'zif_abapdi_test' i_cl = 'zcl_abapdi_test_class1' i_single = abap_true ).
    DATA(d) = CAST zcl_abapdi_test_class1( cut->get_instance( cv_zif_abapdi_test ) ).
 
