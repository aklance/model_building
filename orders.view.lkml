view: orders {
  derived_table: {
    sql: select *
              from demo_db.orders
            where {% condition start_year %} orders.created_date {% endcondition %}  ;;
  }
  filter: start_year {
    suggest_dimension: created_year
    default_value: "2018"
  }
  filter: end_year {
    suggest_dimension: created_year
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }
}
