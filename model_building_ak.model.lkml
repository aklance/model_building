connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: model_building_ak_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hours"
}

persist_with: model_building_ak_default_datagroup

explore: events {
  persist_for: "4 hours"
  }

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${orders.id} = ${order_items.order_id} AND ${orders.status} = "complete"
      ;;
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    fields: [users.age,users.gender, users.city, users.full_name]
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: inner
    relationship: one_to_one
    sql_on: ${products.id} = ${inventory_items.product_id};;
  }
}

explore: orders {
  sql_always_where: ${created_year} >= 1980;;
  join: order_items {
    relationship: one_to_many
    sql_on: ${orders.id} = ${order_items.order_id} ;;
  }
  join: inventory_items {
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
}

explore: products {
  fields: [products.id, products.item_name, products.rank, products.brand]
}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  join: user_data {
    relationship: many_to_one
    view_label: "user_data"
    sql_on: ${user_data.user_id} = ${users.id} ;;
  }
}
