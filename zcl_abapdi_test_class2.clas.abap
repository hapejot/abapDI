CLASS zcl_abapdi_test_class2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_class TYPE REF TO zcl_abapdi_test_class1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPDI_TEST_CLASS2 IMPLEMENTATION.


  METHOD constructor.
  ENDMETHOD.
ENDCLASS.