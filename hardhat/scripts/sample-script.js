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

  tx = await contract.getPathGasTest('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getPath used ',gasUsed.toNumber(),' gas')

  tx = await contract.getColorsGasTest('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getColors used ',gasUsed.toNumber(),' gas')
  
  tx = await contract.getColors2GasTest('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getColors2 used ',gasUsed.toNumber(),' gas')
  
  let colors = await contract.getColors('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  let colors2 = await contract.getColors2('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')

  console.log('getColors:  ', colors)
  console.log('getColors2: ', colors2)
}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
