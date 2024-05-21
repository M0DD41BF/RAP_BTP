CLASS zcl_dvaluhelp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES      : if_oo_adt_classrun.
  METHODS: add_details.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DVALUHELP IMPLEMENTATION.


  METHOD add_details.
      data: lt_data type table of ZDB_VHDEPART.

    lt_data = VALUE #(
     ( department = 'Surgeon' )
      ( department = 'Pediatricians' )
      ( department = 'Cardiologist' )
      ( department = 'Gynecologist' )
      ( department = 'Dermatologist' )
                        ) .

*DELETE from ZDB_VHDEPART where
* department = 'Dermatologist'.

INSERT ZDB_VHDEPART FROM TABLE @LT_DATA.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    add_details( ).
  ENDMETHOD.
ENDCLASS.
