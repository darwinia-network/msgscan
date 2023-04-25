# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

blockchains = Blockchain.create [
  {
    name: 'goerli',
    explorer: 'https://goerli.etherscan.io/',
    rpc: 'https://eth-goerli.api.onfinality.io/public',
    blocks_per_scan: 0
  },
  {
    name: 'pangolin',
    explorer: 'https://pangolin.subscan.io/',
    rpc: 'https://pangolin-rpc.darwinia.network',
    blocks_per_scan: 20_000
  }
]

channels = Channel.create [
  {
    from_blockchain: blockchains[0],
    to_blockchain: blockchains[1],
    outbound_lane: '0x9B5010d562dDF969fbb85bC72222919B699b5F54',
    inbound_lane: '0xB59a893f5115c1Ca737E36365302550074C32023'
  },
  {
    from_blockchain: blockchains[1],
    to_blockchain: blockchains[0],
    outbound_lane: '0xAbd165DE531d26c229F9E43747a8d683eAD54C6c',
    inbound_lane: '0x0F6e081B1054c59559Cf162e82503F3f560cA4AF'
  }
]
