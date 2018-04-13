view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: dummy_dimension {
    case: {
      when: {
        label: "Count"
        sql: 1=1 ;;
      }
      when: {
        label: "Count Completed Orders"
        sql: 1=1 ;;
      }
    }
    }






#    Ok, so, we have a measure Company Count. If we just run that by itself, we get the total number of companies (80,536): http://c.hlp.sc/0g0h2Y0B3J1t
#    Companies have *tags*. 0 or more. http://c.hlp.sc/3Z2W2z1Q2U1S
#    I want to know of that 80,536, how many have 0 and how many have 1 or more.
#    So pivot the Company Count on whether the Tag Count is 0 or more than 0.

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

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
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

  dimension: is_order_paid {
    type: yesno
    sql: ${status} = 'paid' ;;
  }

  dimension: returned {
    type: yesno
    sql: ${TABLE}.returned_at ;;
  }

  dimension: total_amount_of_order {
    type:  number
    sql: (SELECT SUM(order_items.sale_price)
      FROM order_items
      WHERE order_items.order_id = orders.id) ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  dimension: total_cost_of_order{
    type: number
    sql: (SELECT SUM(inventory_items.cost)
      FROM order_items
      LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
      WHERE order_items.order_id = orders.id) ;;
    value_format: "usd"
  }

  measure: completed_order_count {      #count of completed orders
    type:  count
    filters: {
      field:  status
      value: " complete"
    }
    drill_fields: [id, created_date, users.last_name, users.first_name, users.id, order_items.count]
  }

  dimension: order_profit {
    type: number
    value_format: "$0.00"
    sql: ${total_amount_of_order} - ${total_cost_of_order} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: returned_count {
    type: count                   #COUNT(CASE WHEN returned = 'yes' THEN 1 ELSE null END)
    drill_fields: [details*, returned_date]
    filters: {
      field: returned
      value: "yes"
    }
  }

  measure: average_order_profit {
    type: average
    sql: ${order_profit} ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  measure: total_profit {         ##if unknown field error make sure to join inventory_items
    type:  sum
    sql: ${order_profit} ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  measure: total_revenue {
    type: sum
    sql: ${total_amount_of_order} ;;
  }

  measure: total_expenses {
    type: sum
    sql: ${total_cost_of_order} ;;
  }

  set: details {
    fields: [order_id, inventory_item_id, sale_price]
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
