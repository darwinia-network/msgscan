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

ActiveRecord::Schema[7.0].define(version: 2023_04_22_132727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blockchains", force: :cascade do |t|
    t.string "name"
    t.string "explorer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rpc"
    t.integer "blocks_per_scan", default: 20000
  end

  create_table "channels", force: :cascade do |t|
    t.integer "from_blockchain_id"
    t.integer "to_blockchain_id"
    t.string "outbound_lane"
    t.string "inbound_lane"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "last_tracked_blocks", force: :cascade do |t|
    t.integer "blockchain_id"
    t.integer "last_tracked_block"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockchain_id"], name: "index_last_tracked_blocks_on_blockchain_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "nonce"
    t.integer "status"
    t.datetime "accepted_at", precision: nil
    t.string "accepted_tx"
    t.datetime "dispatched_at", precision: nil
    t.string "dispatch_error"
    t.string "dispatched_tx"
    t.datetime "delivered_at", precision: nil
    t.string "delivered_tx"
    t.string "from_dapp"
    t.string "to_dapp"
    t.text "payload"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "block_number"
    t.index ["channel_id", "nonce"], name: "index_messages_on_channel_id_and_nonce", unique: true
  end

end
