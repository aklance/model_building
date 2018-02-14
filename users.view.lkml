view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    label : "Customer:  ID:"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender{
    case: {
      when: {
        sql: ${TABLE}.gender is 'm';;
        label: "Male"
        }
      when: {
        sql: ${TABLE}.gender is 'f';;
        label: "Female"
      }
    else: "Unknown"
  }
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90]
    style: integer
    sql: ${age};;
    drill_fields: [id, age]
    }

  dimension: age_bracket {
    case: {
      when: {
        sql: ${age} < 18 ;;
        label: "Minor"
      }
      when: {
        sql: ${age} between 18 and 35 ;;
        label: "18-35"
      }
      when: {
        sql: ${age} between 36 and 55 ;;
        label: "36-65"
      }
      else: "Senior"
    }
    drill_fields: [id, age]
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: In_US {
    type:  yesno
    sql:  ${country} = 'USA' ;;
  }

  dimension: region {
    case: {
      when: {
        sql: ${state} in ('Washington','Oregon','California','Nevada','Utah','Wyoming','Idaho','Montana','Colorado','Alaska','Hawaii') ;;
        label: "West"
      }
      when: {
        sql: ${state} in ('Arizona','New Mexico','Texas','Oklahoma') ;;
        label: "Southwest"
      }
      when: {
        sql: ${state} in ('North Dakota','South Dakota','Iowa','Wisconsin','Minnesota','Ohio','Indiana','Missouri','Nebraska','Kansas','Michigan','Illinois') ;;
        label: "Midwest"
      }
      when: {
        sql: ${state} in ('Maryland','Delaware','New Jersey','Connecticut','Rhode Island','Maine','New Hampshire','Pennsylvania','New York','Vermont','District of Columbia', 'Massachusetts') ;;
        label: "Northeast"
      }
      when: {
        sql: ${state} in ('Arkansas','Louisiana','Mississippi','Alabama','Georgia','Florida','South Carolina','North Carolina','Virginia','Tennessee','Kentucky','West Virginia') ;;
        label: "Southeast"
      }
      else: "Unknown"
    }
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_age {
    type: average
    sql: users.age ;;
    precision: 2
    drill_fields: [id, full_name, age, order_items.count]
  }

  measure: first_order_date {
    type: min
    sql: users.date ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
