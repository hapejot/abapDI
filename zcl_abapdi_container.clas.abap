CLASS zcl_abapdi_container DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS register
      IMPORTING
        i_if     TYPE string
        i_cl     TYPE string OPTIONAL
        i_ob     TYPE REF TO object OPTIONAL
        i_single TYPE abap_bool OPTIONAL.
    METHODS get_instance
      IMPORTING
        i_classname     TYPE string
      RETURNING
        VALUE(r_result) TYPE REF TO object
      RAISING
        cx_abap_invalid_value.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
            mt_cont TYPE ltt_cont.
    METHODS get_singleton
      IMPORTING
        is_spec     TYPE REF TO lts_cont
        i_classname TYPE lts_cont-src
      EXPORTING
        e_result    TYPE REF TO object.
    METHODS create_object
      IMPORTING
        i_zif_gol_world TYPE string
        i_ifname        TYPE string
      EXPORTING
        e_result        TYPE REF TO object
      RAISING
        cx_abap_invalid_value.
    METHODS get_constructor_parmbind
      IMPORTING
        target_descr TYPE REF TO cl_abap_classdescr
      EXPORTING
        result       TYPE REF TO abap_parmbind_tab.
    METHODS describe_type
      IMPORTING
        i_name         TYPE string
      RETURNING
        VALUE(rr_type) TYPE REF TO cl_abap_typedescr
      RAISING
        cx_abap_invalid_value.

ENDCLASS.



CLASS zcl_abapdi_container IMPLEMENTATION.


  METHOD create_object.

    DATA:params TYPE REF TO abap_parmbind_tab .
    DATA(lr_type) = describe_type( i_ifname ).
    TRY.
        DATA(lr_intf) = CAST cl_abap_intfdescr( lr_type ).
        DATA(ls_def) = mt_cont[ dst = lr_intf->get_relative_name( ) ].
        lr_type = describe_type( ls_def-src ).
      CATCH cx_sy_move_cast_error.
      CATCH cx_sy_itab_line_not_found.
        RAISE EXCEPTION TYPE cx_abap_invalid_param_value.
    ENDTRY.

    DATA(lr_class) = CAST cl_abap_classdescr( lr_type ).
    DATA(cons) = REF #( lr_class->methods[ name = 'CONSTRUCTOR' ] OPTIONAL ).
    IF cons IS BOUND.
      get_constructor_parmbind(
        EXPORTING
          target_descr = lr_class
        IMPORTING
          result       = params
      ).
    ENDIF.
    TRY.
        IF params IS INITIAL.
          CREATE OBJECT e_result TYPE (i_ifname).
        ELSE.
          CREATE OBJECT e_result TYPE (i_ifname) PARAMETER-TABLE params->*.
        ENDIF.
      CATCH cx_sy_create_object_error INTO DATA(exc_ref).
        MESSAGE exc_ref->get_text( ) TYPE 'I'.
    ENDTRY.
  ENDMETHOD.


  METHOD get_constructor_parmbind.
    DATA:
      constructor TYPE REF TO abap_methdescr,
      parmdescr   TYPE REF TO abap_parmdescr,
      refdescr    TYPE REF TO cl_abap_refdescr,
      dependency  TYPE REF TO cl_abap_objectdescr,
      parmbind    TYPE abap_parmbind.
    FIELD-SYMBOLS <fs> TYPE any.
    CREATE DATA result.
    READ TABLE target_descr->methods
        REFERENCE INTO constructor
        WITH KEY name = 'CONSTRUCTOR'.
    IF sy-subrc EQ 0.
      LOOP AT constructor->parameters REFERENCE INTO parmdescr.
        CHECK parmdescr->type_kind EQ cl_abap_objectdescr=>typekind_oref.
        CHECK parmdescr->parm_kind EQ cl_abap_objectdescr=>importing.
        refdescr ?= target_descr->get_method_parameter_type(
            p_method_name = constructor->name
            p_parameter_name = parmdescr->name ).
        CREATE DATA parmbind-value TYPE HANDLE refdescr.
        ASSIGN parmbind-value->* TO <fs>.
        dependency ?= refdescr->get_referenced_type( ).
        TRY.
            <fs> ?= get_instance(  |{ dependency->absolute_name }| ).
          CATCH cx_abap_invalid_value.
            "handle exception
        ENDTRY.
        parmbind-name = parmdescr->name.
        parmbind-kind = cl_abap_objectdescr=>exporting.
        INSERT parmbind INTO TABLE result->*.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_instance.

    TRY.
        DATA(ifname) = |{ i_classname CASE = UPPER }|.
        DATA(ls_spec) = REF #( mt_cont[ dst = ifname ] ).
        DATA(classname) = ls_spec->src.
        IF ls_spec->single = abap_true.
          get_singleton(
                EXPORTING
                  is_spec     = ls_spec
                  i_classname = classname
                IMPORTING
                  e_result = r_result ).
        ELSE.
          create_object(
                EXPORTING
                  i_zif_gol_world = i_classname
                  i_ifname        = classname
                IMPORTING
                  e_result = r_result ).
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
        create_object(
              EXPORTING
                i_zif_gol_world = i_classname
                i_ifname        = ifname
              IMPORTING
                e_result = r_result ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_singleton.
    IF is_spec->obj IS BOUND.
      e_result = is_spec->obj.
    ELSE.
      CREATE OBJECT e_result TYPE (i_classname). " upper case is necessary
      is_spec->obj = e_result.
    ENDIF.

  ENDMETHOD.


  METHOD register.

    APPEND VALUE #(     dst    = |{ i_if CASE = UPPER }|
                        src    = |{ i_cl CASE = UPPER }|
                        obj    = i_ob
                        single = COND #( WHEN i_ob IS BOUND THEN abap_true ELSE i_single )
                        ) TO mt_cont.
  ENDMETHOD.

  METHOD describe_type.

    CALL METHOD cl_abap_typedescr=>describe_by_name
      EXPORTING
        p_name         = i_name
      RECEIVING
        p_descr_ref    = rr_type
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
