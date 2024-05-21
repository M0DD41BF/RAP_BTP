 CLASS lhc_hospital DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR hospital RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hospital RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE hospital.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE hospital.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE hospital.

    METHODS read FOR READ
      IMPORTING keys FOR READ hospital RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK hospital.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ hospital\_Item FULL result_requested
      RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE hospital\_Item.

     METHODS cba_doctor FOR MODIFY
      IMPORTING entities_cba FOR CREATE hospital\_doctor.

    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION hospital~copy.

    METHODS create_action FOR MODIFY
      IMPORTING keys FOR ACTION hospital~create_action RESULT result.

    METHODS Delete_action FOR MODIFY
      IMPORTING keys FOR ACTION hospital~Delete_action RESULT result.

    METHODS fill_code FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hospital~fill_code.

    METHODS hed_itm_authority FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hospital~hed_itm_authority.

    METHODS vald FOR VALIDATE ON SAVE
      IMPORTING keys FOR hospital~vald.

    METHODS rba_appoint FOR READ
      IMPORTING keys_rba FOR READ hospital\_appoint FULL result_requested RESULT result LINK association_links.

    METHODS cba_appoint FOR MODIFY
      IMPORTING entities_cba FOR CREATE hospital\_appoint.

    METHODS rba_doctor FOR READ
      IMPORTING keys_rba FOR READ hospital\_doctor FULL result_requested RESULT result LINK association_links.

    METHODS gmail FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hospital~gmail.

ENDCLASS.

CLASS lhc_hospital IMPLEMENTATION.

  METHOD get_instance_features.

     READ ENTITIES OF ZIV_HOSPITAL IN LOCAL MODE
     ENTITY HOSPITAL ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_features).

     result = VALUE #( for ls_features IN lt_features LET
                lv_action = COND #( WHEN ( LS_FEATURES-action = 'X' )
                THEN if_abap_behv=>fc-o-disabled
                ELSE if_abap_behv=>fc-o-enabled )

                IN ( %is_draft = ls_features-%is_draft %tky = ls_features-%tky
                %features-%action-create_action = lv_action ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.


  ENDMETHOD.

  METHOD create.

      DATA: lt_hospital TYPE zdb_hospital_hd,
            lt_msg      TYPE /dmo/t_message.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_hospital>).

      lt_hospital = CORRESPONDING #( <fs_hospital> MAPPING FROM ENTITY USING CONTROL ).
       if lt_hospital is not INITIAL.
        lt_hospital-email_address = |{ lt_hospital-email_address }| & | @gmail.com |.
        ENDIF.

      INSERT zdb_hospital_hd FROM @lt_hospital.
      IF lt_hospital IS NOT INITIAL.
        mapped-hospital = VALUE #( BASE mapped-hospital ( %cid = <fs_hospital>-%cid HosId = lt_hospital-hos_id ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.

     DATA: lt_hospital  TYPE zdb_hospital_hd,
          lt_hospitalx TYPE zdb_hospital_x,
          lt_msg       TYPE /dmo/t_message.

    DATA lt_message TYPE REF TO if_abap_behv_message.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_hospital>).
      lt_hospital = CORRESPONDING #( <fs_hospital> MAPPING FROM ENTITY ).
      lt_hospitalx-hos_id = <fs_hospital>-HosId.
      lt_hospitalx =  CORRESPONDING #( <fs_hospital> MAPPING
        FROM ENTITY ).
      MODIFY zdb_hospital_hd FROM @lt_hospital.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
     loop at keys ASSIGNING FIELD-SYMBOL(<fs_delete>).
    DELETE FROM zdb_hospital_hd WHERE hos_id EQ @<fs_delete>-HosId.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA: ls_read   LIKE LINE OF result,
    ls_update TYPE zdb_hospital_hd.
*   loop at keys ASSIGNING FIELD-SYMBOL(<fs_update>).
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_update>) INDEX 1.
    SELECT SINGLE * FROM zdb_hospital_hd WHERE hos_id EQ @<fs_update>-hosid INTO
    @ls_update.
    ls_read-HosId = ls_update-hos_id.
    ls_read-HosName = ls_update-hos_name.
    ls_read-authority = ls_update-authority.
    ls_read-city = ls_update-city.
    ls_read-street = ls_update-street.
    ls_read-postalcode = ls_update-postal_code.
    ls_read-Createdby = ls_update-createdby.
    ls_read-contactnumber = ls_update-contact_number.
    ls_read-emailaddress = ls_update-email_address.
    ls_read-Createdat = ls_update-createdat.
    ls_read-Lastchangedat = ls_update-lastchangedat.
    ls_read-Lastchangedby = ls_update-lastchangedby.
    ls_read-action = ls_update-action.
    ls_read-soft_dele = ls_update-soft_dele.
    APPEND ls_read TO result.
*      ENDloop.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Item.
  ENDMETHOD.

  METHOD cba_Item.
   DATA ls_item TYPE zdb_hospital_itm.
    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs2>).
      LOOP AT <fs2>-%target ASSIGNING FIELD-SYMBOL(<fs3>).
        mapped-patient = VALUE #( BASE mapped-patient
       (  %cid = <fs3>-%cid PatUid = <fs3>-PatUid ) ).
       ls_item = CORRESPONDING #( <fs3> MAPPING FROM ENTITY USING CONTROL ).
       IF ls_item IS NOT INITIAL.
        INSERT  zdb_hospital_itm FROM @ls_item.
       ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  method cba_doctor.
    data: ls_doctor type zdb_doctor.
      loop at entities_cba ASSIGNING FIELD-SYMBOL(<fs3>).
       loop at <fs3>-%target ASSIGNING FIELD-SYMBOL(<fs4>).
         mapped-doctor = VALUE #( BASE mapped-doctor
         ( %cid = <fs4>-%cid DocUid = <fs4>-DocUid ) ).
       ls_doctor = CORRESPONDING #( <fs4> MAPPING FROM ENTITY USING CONTROL ).

       IF ls_doctor is not INITIAL.
       INSERT zdb_doctor from @ls_doctor.
       ENDIF.
       ENDLOOP.
      ENDLOOP.
  ENDMETHOD.

  METHOD copy.
    DATA : lt_copy1 TYPE TABLE FOR CREATE Ziv_hospital.
    READ ENTITIES OF Ziv_hospital
    IN LOCAL MODE ENTITY hospital
    ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_copy).
    IF lt_copy IS NOT INITIAL .
      LOOP AT lt_copy ASSIGNING FIELD-SYMBOL(<fs_copy>).
        APPEND VALUE #( %cid = keys[ KEY entity %key = <fs_copy>-%key ]-%cid
                        %is_draft = keys[ KEY entity %key = <fs_copy>-%key ]-%param-%is_draft
                         %data = CORRESPONDING #(  <fs_copy> EXCEPT hosid ) ) TO lt_copy1.
      ENDLOOP.

      MODIFY ENTITIES OF Ziv_hospital IN LOCAL MODE ENTITY hospital
           CREATE FIELDS ( HosName authority city contactnumber emailaddress postalcode street ) WITH CORRESPONDING #( lt_copy1 )
           MAPPED DATA(map_man).

    ENDIF.

    mapped-hospital = map_man-hospital.

  ENDMETHOD.

  METHOD create_action.

       READ ENTITIES OF Ziv_Hospital IN LOCAL MODE
       ENTITY hospital ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_action).

       loop at lt_action ASSIGNING FIELD-SYMBOL(<fs_action>).
        <fs_action>-action = 'A'.
       ENDLOOP.

       MODIFY ENTITIES OF ZIV_HOSPITAL IN LOCAL MODE
       ENTITY hospital UPDATE FIELDS ( action )
       WITH CORRESPONDING #( lt_action ).

       result = VALUE #( FOR ls_action IN lt_action
       ( %tky = ls_action-%tky
         %param = ls_action ) ).

  ENDMETHOD.

  METHOD Delete_action.
    READ ENTITIES OF Ziv_hospital IN LOCAL MODE
      ENTITY hospital
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_action_del).


    LOOP AT lt_action_del ASSIGNING FIELD-SYMBOL(<fs_action_del>).
      <fs_action_del>-soft_dele = 'X'.
    ENDLOOP.


    MODIFY ENTITIES OF Ziv_hospital IN LOCAL MODE
    ENTITY hospital
    UPDATE FIELDS ( soft_dele )
    WITH CORRESPONDING #( lt_action_del ).


    result = VALUE #( FOR ls_action_del IN lt_action_del
                      ( %tky = ls_action_del-%tky
                        %param = ls_action_del ) ).

  ENDMETHOD.

  METHOD fill_code.

    READ ENTITIES OF ziv_hospital IN LOCAL MODE
    ENTITY hospital
    ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_result).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result>-city = 'Jose C Paz'.
        <fs_result>-postalcode = '1665'.
        <fs_result>-ContactNumber = '+54'.
      ELSEIF
         <fs_result>-city = 'Grand Bourg'.
        <fs_result>-postalcode = '1669'.
        <fs_result>-ContactNumber = '+54'.
      ENDIF.

    ENDLOOP.

    IF <fs_result>-postalcode IS NOT INITIAL.
      MODIFY ENTITIES OF ziv_hospital IN LOCAL MODE
       ENTITY hospital UPDATE FIELDS ( postalcode ContactNumber )
        WITH CORRESPONDING #( lt_result ).
    ENDIF.
ENDMETHOD.

  METHOD gmail.
     READ entities of ZIV_HOSPITAL IN LOCAL MODE
     ENTITY hospital All FIELDS WITH CORRESPONDING #( keys ) Result data(lt_result).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_hospital>).
       if <fs_hospital> is not INITIAL.
         <fs_hospital>-EmailAddress = |{ <fs_hospital>-emailaddress }| & | @gmail.com |.
           ENDIF.
    ENDLOOP.

    IF <fs_hospital>-emailaddress IS NOT INITIAL.
      MODIFY ENTITIES OF ziv_hospital IN LOCAL MODE
       ENTITY hospital UPDATE FIELDS ( EmailAddress )
        WITH CORRESPONDING #( lt_result ).
    ENDIF.

  ENDMETHOD.

  METHOD hed_itm_authority.

    READ ENTITIES OF ziv_hospital IN LOCAL MODE
    ENTITY hospital
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    READ TABLE lt_result ASSIGNING FIELD-SYMBOL(<fs_result>) INDEX 1.
    IF <fs_result> IS NOT INITIAL.

      READ ENTITIES OF Ziv_hospital IN LOCAL MODE
         ENTITY hospital BY \_Item
         FIELDS ( authority )
         WITH VALUE #( ( %tky = <fs_result>-%tky ) )
         RESULT DATA(lt_items).


      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
        <fs_item>-authority = <fs_result>-authority.
        MODIFY ENTITIES OF Ziv_hospital IN LOCAL MODE
        ENTITY Patient
        UPDATE FIELDS ( authority )
        WITH CORRESPONDING #( lt_items ).
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD vald.

   READ ENTITIES OF Ziv_Hospital IN LOCAL MODE
    ENTITY hospital FIELDS ( contactnumber HosName )
    WITH CORRESPONDING #( keys ) RESULT DATA(lt_hospital)
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported).

    DATA(iv_state) = 'state_area'.
    APPEND VALUE #( %tky = CORRESPONDING #( lt_hospital[ 1 ]-%tky )
                    %is_draft = lt_hospital[ 1 ]-%is_draft
                    %state_area = if_abap_behv=>state_area_all
                    ) TO
                    reported-hospital.

    LOOP AT lt_hospital ASSIGNING FIELD-SYMBOL(<fs_hospital>).

      IF <fs_hospital>-contactnumber IS INITIAL.

        APPEND VALUE #( %tky = <fs_hospital>-%tky
                        %is_draft = <fs_hospital>-%is_draft ) TO
                        failed-hospital.

        APPEND VALUE #(  %tky = <fs_hospital>-%tky
        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
        text = 'contact number required' )
        %element-contactnumber = if_abap_behv=>mk-on
        %state_area = iv_state
        )
        TO reported-hospital.
      ENDIF.

      IF <fs_hospital>-HosName IS INITIAL.
       APPEND VALUE #( %tky = <fs_hospital>-%tky
                  %is_draft = <fs_hospital>-%is_draft ) TO failed-hospital.
        APPEND VALUE #( %tky = <fs_hospital>-%tky
                  %is_draft = <fs_hospital>-%is_draft
                  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                 text = 'Hospital Name required' )
                  %element-hosname = if_abap_behv=>mk-on
                  %state_area = iv_state
                  )
                  TO reported-hospital.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Appoint.
  ENDMETHOD.

  METHOD cba_Appoint.
   DATA ls_item TYPE zdb_appoinment.
    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs2>).
     LOOP AT <fs2>-%target ASSIGNING FIELD-SYMBOL(<fs3>).
        mapped-patient = VALUE #( BASE mapped-patient
       (  %cid = <fs3>-%cid PatUid = <fs3>-Opatid ) ).
       ls_item = CORRESPONDING #( <fs3> MAPPING FROM ENTITY USING CONTROL ).
       IF ls_item IS NOT INITIAL.
        INSERT zdb_appoinment FROM @ls_item.
       ENDIF.
      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

  METHOD rba_Doctor.
  ENDMETHOD.



ENDCLASS.

CLASS lhc_patient DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE patient.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE patient.

    METHODS read FOR READ
      IMPORTING keys FOR READ patient RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ patient\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_patient IMPLEMENTATION.

  METHOD update.
     DATA: lt_patient  TYPE zdb_hospital_itm,
          lt_patientx TYPE zdb_patient_x,
          lt_msg      TYPE /dmo/t_message.

    DATA lt_message TYPE REF TO if_abap_behv_message.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_patient>).
      lt_patient = CORRESPONDING #( <fs_patient> MAPPING FROM ENTITY ).
      lt_patientx-pat_uid = <fs_patient>-patuid.
* lt_patient = <fs_patient>
      lt_patientx =  CORRESPONDING #( <fs_patient> MAPPING
        FROM ENTITY ).
      MODIFY zdb_hospital_itm FROM @lt_patient.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_delete>) INDEX 1.
    DELETE FROM zdb_hospital_itm WHERE pat_uid EQ @<fs_delete>-PatUid.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZIV_HOSPITAL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZIV_HOSPITAL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.
  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_doctor DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE doctor.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE doctor.

    METHODS read FOR READ
      IMPORTING keys FOR READ doctor RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ doctor\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_doctor IMPLEMENTATION.

  METHOD update.
    DATA: lt_doctor TYPE zdb_doctor,
          lt_doctor_x type zdb_doctor_x,
          lt_msg type /dmo/t_message.
    DATA: LT_MESSAGE type REF TO if_abap_behv_message.

   loop at entities ASSIGNING FIELD-SYMBOL(<fs_doctor>).
   lt_doctor = CORRESPONDING #( <fs_doctor> mapping from entity ).
   lt_doctor_x = <fs_doctor>-DocUid.
   lt_doctor_x = CORRESPONDING #( <fs_doctor> MAPPING from entity ).

   MODIFY zdb_doctor FROM @lt_doctor.

   ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_appoint DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE appoint.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE appoint.

    METHODS read FOR READ
      IMPORTING keys FOR READ appoint RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ appoint\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_appoint IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.
