const hre = require("hardhat");

const CONTRACT_NAME = 'TokenURIDescriptor';

async function main() {
  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log(CONTRACT_NAME, " deployed to:", contract.address);

  let tx
  let txReceipt
  let gasUsed
  tx = await contract.tokenURIGasTest('0xC53128eAe55d64C2bD70F842247a0E8D27647241', 'SVGie', 'SVGie')
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - getEncodedSVG used ',gasUsed.toNumber(),' gas')

  // let colors = await contract.getColors('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  // console.log('getColors: ', colors)

  // let path = await contract.getPath('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')
  // console.log('getPath: ', path)

  let svg = await contract.tokenURI('0xC53128eAe55d64C2bD70F842247a0E8D27647241', 'SVGie', 'SVGie')
  console.log(svg)

}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
