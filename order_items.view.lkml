view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
   }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    }


  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  dimension: is_order_paid {
    type: yesno
    sql: ${status} = 'paid' ;;
  }

# ----- Sets of fields for drilling ------
set: detail {
  fields: [
    id,
    users.id,
    users.first_name,
    users.last_name,
    inventory_items.id,
    inventory_items.product_name
  ]
  }
}
