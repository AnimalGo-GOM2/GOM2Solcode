require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-etherscan');
require("dotenv").config();

module.exports = {
  solidity: "0.8.13",
  networks: {
    development: {
      url: "http://127.0.0.1:8545"
    },
    ethereum: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY || '']
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_TOKEN
  }
};
