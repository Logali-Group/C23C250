class zcl_250_data_generator definition
  public
  final
  create public .

  public section.
    interfaces if_oo_adt_classrun.

  protected section.
  private section.
endclass.



class zcl_250_data_generator implementation.

  method if_oo_adt_classrun~main.

    out->write( |----> Travel| ).

    delete from ztravel_250_a.                          "#EC CI_NOWHERE
    delete from ztravel_250_d.                          "#EC CI_NOWHERE

    insert ztravel_250_a from (
      select from /dmo/travel fields
        " client
        uuid( ) as travel_uuid,
        travel_id,
        agency_id,
        customer_id,
        begin_date,
        end_date,
        booking_fee,
        total_price,
        currency_code,
        description,
        case status when 'B' then 'A'
                    when 'P' then 'O'
                    when 'N' then 'O'
                    else 'X' end as overall_status,
        createdby as local_created_by,
        createdat as local_created_at,
        lastchangedby as local_last_changed_by,
        lastchangedat as local_last_changed_at,
        lastchangedat as last_changed_at
       where travel_id between '00000001' and '00000025'
    ).

    if sy-subrc eq 0.
      out->write( |Travel entries inserted:  { sy-dbcnt }| ).
    endif.

    " bookings
    out->write( |----> Bookings| ).

    delete from zbooking_250_a.                         "#EC CI_NOWHERE
    delete from zbooking_250_d.                         "#EC CI_NOWHERE

    insert zbooking_250_a from (
        select
          from /dmo/booking
            join ztravel_log_a on /dmo/booking~travel_id = ztravel_log_a~travel_id
            join /dmo/travel on /dmo/travel~travel_id = /dmo/booking~travel_id
          fields  "client,
                  uuid( ) as booking_uuid,
                  ztravel_log_a~travel_uuid as parent_uuid,
                  /dmo/booking~booking_id,
                  /dmo/booking~booking_date,
                  /dmo/booking~customer_id,
                  /dmo/booking~carrier_id,
                  /dmo/booking~connection_id,
                  /dmo/booking~flight_date,
                  /dmo/booking~flight_price,
                  /dmo/booking~currency_code,
                  case /dmo/travel~status when 'P' then 'N'
                                                   else /dmo/travel~status end as booking_status,
                  ztravel_log_a~last_changed_at as local_last_changed_at
    ).

    if sy-subrc eq 0.
      out->write( |Booking entries inserted:  { sy-dbcnt }| ).
    endif.


    " supplements
    out->write( |----> Bookings| ).

    delete from zbksuppl_250_a.                         "#EC CI_NOWHERE
    delete from zbksuppl_250_d.                         "#EC CI_NOWHERE

    insert zbksuppl_250_a from (
      select from /dmo/book_suppl    as supp
               join ztravel_log_a  as trvl on trvl~travel_id = supp~travel_id
               join zbooking_250_a as book on book~parent_uuid = trvl~travel_uuid
                                          and book~booking_id = supp~booking_id

        fields
          " client
          uuid( )                 as booksuppl_uuid,
          trvl~travel_uuid        as root_uuid,
          book~booking_uuid       as parent_uuid,
          supp~booking_supplement_id,
          supp~supplement_id,
          supp~price,
          supp~currency_code,
          trvl~last_changed_at    as local_last_changed_at
    ).

    if sy-subrc eq 0.
      out->write( |Supplements entries inserted:  { sy-dbcnt }| ).
    endif.

  endmethod.

endclass.
