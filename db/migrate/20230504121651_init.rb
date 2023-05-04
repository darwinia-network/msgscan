class Init < ActiveRecord::Migration[7.0]
  def up
    create_table "blockchains", force: :cascade do |t|
      t.string "name"
      t.string "explorer"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "rpc"
      t.integer "blocks_per_scan", default: 20000
      t.string "explorer_block_url"
    end
  
    create_table "channels", force: :cascade do |t|
      t.integer "src_blockchain_id"
      t.integer "dst_blockchain_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "channelable_id"
      t.string "channelable_type"
    end
  
    create_table "cross_chain_message_events", force: :cascade do |t|
      t.integer "cross_chain_message_id"
      t.integer "event_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
    create_table "cross_chain_messages", force: :cascade do |t|
      t.integer "src_blockchain_id"
      t.integer "nonce"
      t.integer "status"
      t.datetime "sent_at", precision: nil
      t.integer "sent_at_event_id"
      t.datetime "executed_at", precision: nil
      t.integer "executed_at_event_id"
      t.text "execution_error"
      t.integer "execution_error_event_id"
      t.string "from_dapp"
      t.string "to_dapp"
      t.text "payload"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "dst_blockchain_id"
      t.integer "channel_id"
      t.datetime "confirmed_at", precision: nil
      t.integer "confirmed_at_event_id"
      t.string "src_transaction_hash"
      t.string "dst_transaction_hash"
      t.index ["src_blockchain_id", "dst_blockchain_id", "channel_id", "nonce"], name: "index_cross_chain_messages_on_src_and_dst_and_ch_and_nonce", unique: true
    end
  
    create_table "events", force: :cascade do |t|
      t.string "event_source_type"
      t.integer "event_source_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["event_source_type", "event_source_id"], name: "index_events_on_event_source_type_and_event_source_id", unique: true
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
      t.string "block_hash"
      t.integer "transaction_index"
      t.integer "log_index"
      t.boolean "removed"
      t.string "event_name"
      t.json "args"
      t.datetime "log_at", precision: nil
      t.index ["blockchain_id", "block_number", "transaction_index", "log_index"], name: "index_evm_lcmp_logs_on_4_columns", unique: true
    end
  
    create_table "last_tracked_blocks", force: :cascade do |t|
      t.integer "blockchain_id"
      t.integer "last_tracked_block", default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["blockchain_id"], name: "index_last_tracked_blocks_on_blockchain_id", unique: true
    end
  end
end
