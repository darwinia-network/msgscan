module MessagesHelper
  def src_tx_link(message)
    return '-' unless message.src_tx_hash&.length&.positive?

    link_to message.src_tx_hash.truncate(16), message.src_chain.explorer_tx_url(message.src_tx_hash)
  end

  def dst_tx_link(message)
    return '-' unless message.dst_tx_hash&.length&.positive?

    link_to message.dst_tx_hash.truncate(16), message.dst_chain.explorer_tx_url(message.dst_tx_hash)
  end

  def block_number_link(message)
    return '-' unless message.block_number

    return message.block_number unless message.src_chain.explorer_block_url

    link_to message.block_number, message.src_chain.get_explorer_block_url(message.block_number)
  end
end
