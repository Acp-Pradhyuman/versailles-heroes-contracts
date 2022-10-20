require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');

 const bscProvider = new HDWalletProvider({
   privateKeys: ['2a3b1f3392eaa6517d2a74851c11330dccf47da6c48fc7b1db786afaf85e13be'],
   providerOrUrl: 'https://data-seed-prebsc-1-s1.binance.org:8545'
 });

 const mumbaiProvider = new HDWalletProvider({
    privateKeys: ['2a3b1f3392eaa6517d2a74851c11330dccf47da6c48fc7b1db786afaf85e13be'],
    providerOrUrl: 'https://matic-mumbai.chainstacklabs.com/'
  });


module.exports = {
    networks: {
        development: {
            host: '127.0.0.1:',
            port: '7545',
            network_id: '*'  // any network
        },
        bscTestnet: {
            provider : ()=> bscProvider,
            network_id:"97",
            gas: 5500000,        // Ropsten has a lower block limit than mainnet
            confirmations: 2,    // # of confs to wait between deployments. (default: 0)
            networkCheckTimeout: 1000000,
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },
        mumbai: {
            provider: () => mumbaiProvider,
            network_id: 80001,       // mumbai testnet chain id
            gas: 5500000,        // Ropsten has a lower block limit than mainnet
            confirmations: 2,    // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },

    },
    contracts_directory: './src/contracts/',
    contracts_build_directory: './src/truffle_abis',
    compilers: {
        solc: {
            version: '0.8.15',
            optimizer: {
                enabled: true,
                runs: 200
            },
        }
    },
    plugins: ['truffle-plugin-verify'],
    // api_keys: {
    //     // polygonscan: 'H5GVV9XN2K7XEXAGRN5P9ENYCHC3DS3Y2U'//it's only working on mainnet
    //     bscscan : '5ZSBBTXY5STP3H12HF9XIRE36SYANK5XUG'
    // }
    api_keys: {
        polygonscan: 'H5GVV9XN2K7XEXAGRN5P9ENYCHC3DS3Y2U'//it's only working on mainnet
      }

}

// 'nftMarketplace9' : 0x4929d3aa585957CD54ED5F58f94858c20488dD80 bsctestnet
// 'NFT2' : 0x49B8ce91714DBDEfF545FC2245C6be4F19839383 bsctestnet