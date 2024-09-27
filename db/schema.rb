# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_27_023758) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.string "name"
    t.integer "price"
    t.integer "production_cost"
    t.integer "net_profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_orders_on_business_id"
  end

  create_table "product_lists", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_product_lists_on_order_id"
    t.index ["product_id"], name: "index_product_lists_on_product_id"
  end

  create_table "product_lists_products", id: false, force: :cascade do |t|
    t.bigint "product_list_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_product_lists_products_on_product_id"
    t.index ["product_list_id"], name: "index_product_lists_products_on_product_list_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["business_id"], name: "index_products_on_business_id"
  end

  create_table "supplies", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.integer "cost"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo1"
    t.string "tipo2"
    t.string "tipo3"
    t.index ["business_id"], name: "index_supplies_on_business_id"
  end

  create_table "supplies_supply_lists", id: false, force: :cascade do |t|
    t.bigint "supply_list_id", null: false
    t.bigint "supply_id", null: false
    t.index ["supply_id"], name: "index_supplies_supply_lists_on_supply_id"
    t.index ["supply_list_id"], name: "index_supplies_supply_lists_on_supply_list_id"
  end

  create_table "supply_lists", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "supply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_supply_lists_on_product_id"
    t.index ["supply_id"], name: "index_supply_lists_on_supply_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.index ["business_id"], name: "index_users_on_business_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "orders", "businesses"
  add_foreign_key "product_lists", "orders"
  add_foreign_key "product_lists", "products"
  add_foreign_key "products", "businesses"
  add_foreign_key "supplies", "businesses"
  add_foreign_key "supply_lists", "products"
  add_foreign_key "supply_lists", "supplies"
  add_foreign_key "users", "businesses"
end
