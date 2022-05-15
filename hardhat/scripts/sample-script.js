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

  // tx = await contract.testPathBytes('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - getPathBytes used ',gasUsed.toNumber(),' gas')

  tx = await contract.testPathStr01('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPathStr01 used ',gasUsed.toNumber(),' gas')

  tx = await contract.testPathStr02('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPathStr02 used ',gasUsed.toNumber(),' gas')

  tx = await contract.testPathStr03('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPathStr03 used ',gasUsed.toNumber(),' gas')

  tx = await contract.testPathStr04('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPathStr04 used ',gasUsed.toNumber(),' gas')

}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
