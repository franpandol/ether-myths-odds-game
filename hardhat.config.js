require('@nomicfoundation/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require("@nomicfoundation/hardhat-verify");
const { alchemyApiKey, account, etherscanApiKey } = require('./secrets.json');
module.exports = {
  solidity: "0.8.20",
  etherscan: {
    apiKey: etherscanApiKey,
  },
  networks: {
     sepolia: {
       url: alchemyApiKey,
       accounts: [account,],
       gas: "auto",
     },
  },
};
