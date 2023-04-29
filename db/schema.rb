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

ActiveRecord::Schema[7.0].define(version: 2023_04_29_061721) do
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
    t.integer "src_blockchain_id"
    t.integer "dst_blockchain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "channelable_id"
    t.string "channelable_type"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "address"
    t.string "name"
    t.integer "lane_id"
    t.integer "blockchain_id"
    t.json "events_interface"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cross_chain_messages", force: :cascade do |t|
    t.integer "src_blockchain_id"
    t.integer "nonce"
    t.integer "status"
    t.datetime "sent_at", precision: nil
    t.integer "sent_at_event_id"
    t.string "sent_at_event_type"
    t.datetime "executed_at", precision: nil
    t.integer "executed_at_event_id"
    t.string "executed_at_event_type"
    t.text "execution_error"
    t.integer "execution_error_event_id"
    t.string "execution_error_event_type"
    t.string "from_dapp"
    t.string "to_dapp"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dst_blockchain_id"
    t.integer "channel_id"
    t.index ["sent_at_event_type", "sent_at_event_id"], name: "index_cross_chain_messages_on_sent_at_event"
  end

  create_table "evm_lcmp_lanes", force: :cascade do |t|
    t.integer "src_blockchain_id"
    t.string "outbound_lane_address"
    t.integer "dst_blockchain_id"
    t.string "inbound_lane_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evm_lcmp_logs", force: :cascade do |t|
    t.integer "blockchain_id"
    t.string "address"
    t.string "topics", array: true
    t.integer "block_number"
    t.text "data"
    t.string "transaction_hash"
    t.integer "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cross_chain_message_id"
    t.string "block_hash"
    t.integer "transaction_index"
    t.integer "log_index"
    t.boolean "removed"
    t.string "event_name"
    t.json "args"
    t.datetime "log_at", precision: nil
    t.integer "counterpart_blockchain_id"
    t.integer "direction", comment: "0: out, 1: in"
  end

  create_table "lanes", force: :cascade do |t|
    t.integer "src_blockchain_id"
    t.integer "dst_blockchain_id"
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
