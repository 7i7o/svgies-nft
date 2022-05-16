require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
require("hardhat-gas-reporter");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
  //   rinkeby: {
  //     url: process.env.ALCHEMY_KEY_RINKEBY_STAGING,
  //     accounts: [process.env.RINKEBY_PRIVATE_KEY],
  //   },
    mumbai: {
      url: process.env.ALCHEMY_KEY_MUMBAI_STAGING,
      accounts: [ process.env.MUMBAI_PRIVATE_KEY ],
    }
  },
  // etherscan: {
  //   // Your API key for Etherscan
  //   // Obtain one at https://etherscan.io/
  //   apiKey: process.env.ETHERSCAN_API_KEY
  // }
  gasReporter: {
    enabled: true
  }
};
