const hre = require("hardhat");
const ethers = require('ethers');

const CONTRACT_NAME = 'SVGie';

async function main() {
  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log(CONTRACT_NAME, " deployed to:", contract.address);

  let tx
  let txReceipt
  let gasUsed

  tx = await contract.safeMint()
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - safeMint used ',gasUsed.toNumber(),' gas')
  console.log(txReceipt.logs)

  let tokenId = ethers.BigNumber.from('0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266')
  let svg = await contract.tokenURI(tokenId)
  console.log(svg)

}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
