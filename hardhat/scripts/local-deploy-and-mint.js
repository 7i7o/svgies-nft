const hre = require("hardhat");
const ethers = hre.ethers;
const waffle = hre.waffle;

const CONTRACT_NAME = 'SVGie';
const MINT_PRICE = '0.05' // in Eth/Matic

async function main() {
  
  const [owner, addr1, addr2] = await ethers.getSigners();
  
  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Contract.deploy(ethers.utils.parseEther(MINT_PRICE));
  await contract.deployed();
  console.log(CONTRACT_NAME, " deployed to:", contract.address);

  let tx
  let txReceipt
  let gasUsed
  let balance

  balance = await contract.provider.getBalance(contract.address)
  console.log("Contract Balance: ", balance)
  balance = await contract.provider.getBalance(owner.address)
  console.log("Owner Balance: ", balance)
  balance = await contract.provider.getBalance(addr1.address)
  console.log("Donation Balance: ", balance)

  tx = await contract.toggleMintActive()
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - toggleMintActive used ',gasUsed.toNumber(),' gas')

  tx = await contract.setDonationAddress(addr1.address)
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - setDonationAddress used ',gasUsed.toNumber(),' gas')

  tx = await contract.safeMint({value: ethers.utils.parseEther(MINT_PRICE)})
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - safeMint used ',gasUsed.toNumber(),' gas')
  // console.log(txReceipt.logs)

  balance = await contract.provider.getBalance(contract.address)
  console.log("Contract Balance: ", balance)
  balance = await contract.provider.getBalance(owner.address)
  console.log("Owner Balance: ", balance)
  balance = await contract.provider.getBalance(addr1.address)
  console.log("Donation Balance: ", balance)


  let tokenId = ethers.BigNumber.from('0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266')
  let svg = await contract.tokenURI(tokenId)
  console.log(svg)

  tx = await contract.withdraw()
  txReceipt = await tx.wait()
  gasUsed = txReceipt.gasUsed;
  console.log(' - withdraw used ',gasUsed.toNumber(),' gas')

  balance = await contract.provider.getBalance(contract.address)
  console.log("Contract Balance: ", balance)
  balance = await contract.provider.getBalance(owner.address)
  console.log("Owner Balance: ", balance)
  balance = await contract.provider.getBalance(addr1.address)
  console.log("Donation Balance: ", balance)

}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
