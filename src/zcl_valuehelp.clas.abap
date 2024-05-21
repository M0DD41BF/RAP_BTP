CLASS zcl_valuehelp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES      : if_oo_adt_classrun.
  METHODS: add_details.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VALUEHELP IMPLEMENTATION.


  METHOD add_details.
   data: lt_data type table of ZDB_VHELP.

    lt_data = VALUE #(
     ( city = 'Tirupattur' hos_name = 'Thangaraj' )
                        ( city = 'vellore' hos_name = 'CMC' )
                         ( city = 'Hosur' hos_name = 'Kauvery' )
                          ( city = 'Chennai' hos_name = 'Miot' )
                           ( city = 'Ekkatutangal' hos_name = 'Nila' )
                           ( city = '' hos_name = 'Gov Hospital' )
                         ) .

MODIFY ZDB_VHELP FROM TABLE @LT_DATA.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
   ADD_DETAILS( ).
  ENDMETHOD.
ENDCLASS.
