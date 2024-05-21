CLASS zcl_hidetab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HIDETAB IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

*   DATA: lt_entity TYPE STANDARD TABLE OF Ziv_Hospital  WITH DEFAULT KEY.
*  FIELD-SYMBOLS: <fs_data> TYPE Ziv_Hospital.
*  lt_entity = CORRESPONDING #( it_original_data ).
*  LOOP AT lt_entity ASSIGNING <fs_data>.
** Set index
*    DATA(lv_index) = sy-tabix.
*    ASSIGN COMPONENT to_upper( 'VI_ITEMS' ) OF STRUCTURE ct_calculated_data[ lv_index ] TO FIELD-SYMBOL(<fs1>).
*    IF <fs_data>-HosName IS  INITIAL.
*      <fs1> = abap_true.
*    ELSE.
*      <fs1> = abap_false.
*    ENDIF.
*  ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
