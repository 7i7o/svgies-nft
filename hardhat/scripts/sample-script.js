const hre = require("hardhat");

const CONTRACT_NAME = 'Contract';

async function main() {
  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log(CONTRACT_NAME, " deployed to:", contract.address);

  let tx
  let txReceipt
  let gasUsed
  tx = await contract.testPathGas('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPath used ',gasUsed.toNumber(),' gas')
}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
