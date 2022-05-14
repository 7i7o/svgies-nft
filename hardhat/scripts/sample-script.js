const hre = require("hardhat");

import CONTRACT_NAME from '../constants'

async function main() {

  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Greeter.deploy();

  await contract.deployed();

  console.log(CONTRACT_NAME, " deployed to:", contract.address);
}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
