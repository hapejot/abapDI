*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
TYPES:
  BEGIN OF lts_cont,
    dst    TYPE string,
    src    TYPE string,
    obj    TYPE REF TO object,
    single TYPE abap_bool,
  END OF lts_cont,
  ltt_cont TYPE STANDARD TABLE OF lts_cont WITH KEY dst.
