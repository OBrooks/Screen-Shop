# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_13_135007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "adress_for_carts", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "shipping_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "billing_info_id"
    t.index ["billing_info_id"], name: "index_adress_for_carts_on_billing_info_id"
    t.index ["cart_id"], name: "index_adress_for_carts_on_cart_id"
    t.index ["shipping_info_id"], name: "index_adress_for_carts_on_shipping_info_id"
  end

  create_table "billing_infos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "civility"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "street_number"
    t.string "street_name", default: "", null: false
    t.string "street_name2"
    t.string "zip_code", default: "", null: false
    t.string "city", default: "", null: false
    t.integer "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["user_id"], name: "index_billing_infos_on_user_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.bigint "discount_code_id"
    t.index ["delivery_id"], name: "index_carts_on_delivery_id"
    t.index ["discount_code_id"], name: "index_carts_on_discount_code_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "delivery_time"
  end

  create_table "discount_codes", force: :cascade do |t|
    t.string "code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "line_items_orders", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 8, scale: 2
    t.integer "discount", default: 0
    t.index ["order_id"], name: "index_line_items_orders_on_order_id"
    t.index ["product_id"], name: "index_line_items_orders_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shipping_info_id"
    t.bigint "delivery_id"
    t.bigint "billing_info_id"
    t.integer "status", default: 0
    t.index ["billing_info_id"], name: "index_orders_on_billing_info_id"
    t.index ["delivery_id"], name: "index_orders_on_delivery_id"
    t.index ["shipping_info_id"], name: "index_orders_on_shipping_info_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "phone_brands", force: :cascade do |t|
    t.string "brand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_models", force: :cascade do |t|
    t.string "model"
    t.bigint "phone_brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_brand_id"], name: "index_phone_models_on_phone_brand_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "product_name"
    t.string "description"
    t.decimal "price", precision: 8, scale: 2
    t.bigint "phone_brand_id"
    t.bigint "phone_model_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "status", default: 0
    t.integer "discount", default: 0
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["phone_brand_id"], name: "index_products_on_phone_brand_id"
    t.index ["phone_model_id"], name: "index_products_on_phone_model_id"
  end

  create_table "shipping_infos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "civility"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "street_number"
    t.string "street_name", default: "", null: false
    t.string "street_name2"
    t.string "zip_code", default: "", null: false
    t.string "city", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "phone_number"
    t.boolean "main_adress"
    t.index ["user_id"], name: "index_shipping_infos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "street_number"
    t.string "street_name", default: "", null: false
    t.string "street_name2"
    t.string "zip_code", default: "", null: false
    t.string "city", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "stripe_id"
    t.string "card_brand"
    t.string "card_last4"
    t.string "card_exp_month"
    t.string "card_exp_year"
    t.datetime "expires_at"
    t.integer "gender", default: 0
    t.integer "phone_number"
    t.string "stripe_customer"
    t.string "card_stripe_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adress_for_carts", "billing_infos"
  add_foreign_key "adress_for_carts", "carts"
  add_foreign_key "adress_for_carts", "shipping_infos"
  add_foreign_key "billing_infos", "users"
  add_foreign_key "carts", "deliveries"
  add_foreign_key "carts", "discount_codes"
  add_foreign_key "carts", "users"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items_orders", "orders"
  add_foreign_key "line_items_orders", "products"
  add_foreign_key "orders", "billing_infos"
  add_foreign_key "orders", "deliveries"
  add_foreign_key "orders", "shipping_infos"
  add_foreign_key "orders", "users"
  add_foreign_key "shipping_infos", "users"
end
