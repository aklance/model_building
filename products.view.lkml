view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: test_1 {
    type:  date
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: cost_bracket {
    case: {
      when: {
        sql: ${cost} < 15.00 ;;
        label: "Inexpensive"
      }
      when: {
        sql: ${cost} >= 15.00 and ${cost} < 40.00 ;;
        label: "Average"
      }
      when: {
        sql: ${cost} >= 40.00 and ${cost} < 100.00 ;;
        label: "Expensive"
      }
      else: "Exorbitant!"
    }
    drill_fields: [id, category, cost]
  }
  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

  measure: sum_cost {       #sum_price of products
    type:  sum
    sql: ${retail_price} ;;
  }

  measure: cheapest_product {         ##returns cheapest product
    type:  min
    sql:  ${retail_price} ;;
    drill_fields: [id, item_name, brand, category]
  }

  measure: max_sale_price {     ##returns most epensive product
    type:  max
    sql:  ${retail_price} ;;
    drill_fields: [id, item_name, brand, category]
  }

  measure: max_rank {   ##returns highest ranking product/brand/category
    type:  max
    sql: ${rank} ;;
    drill_fields: [id, item_name, brand, category]
  }

  measure: min_rank {               ##returns lowest ranking item
    type: min
    sql:${rank} ;;
    drill_fields: [id, item_name, brand, category]
  }

}
