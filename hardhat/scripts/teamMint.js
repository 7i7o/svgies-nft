const hre = require("hardhat");
const ethers = hre.ethers;
const waffle = hre.waffle;

const CONTRACT_NAME = 'SVGie';
// const MINT_PRICE = '0.01' // in Eth/Matic
const MINT_PRICE = '15' // in Eth/Matic
// Mumbai 00: 0xacB69A6A9c5AA171Addd0a178507154345654bF9
// Polygon 00: 0x0c6C2a028aB0FCB9e60f82Ce14703eeF40D15A48
const CONTRACT_ADDRESS = '0x0c6C2a028aB0FCB9e60f82Ce14703eeF40D15A48';

// const WALLETHH = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266' // Hardhat Default
const WALLETMM = '0x0b29CF9b4D48BF75Bd1c2681cA07aB102F85c98C' // 7i7o-domains


async function main() {
  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const contract = await Contract.attach(CONTRACT_ADDRESS);
  // const contract = await Contract.deploy(ethers.utils.parseEther(MINT_PRICE));
  // await contract.deployed();
  console.log(CONTRACT_NAME, " deployed to:", contract.address);

  let tx
  let txReceipt
  let gasUsed
  let balance
  let tokenId
  let result
  let addr

  balance = await contract.provider.getBalance(contract.address)
  console.log("Contract Balance: ", balance.toNumber())

  // Set Mint to Active
  // tx = await contract.toggleMintActive()
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - toggleMintActive used ',gasUsed.toNumber(),' gas')

  // Mint 1 NFT
  // tx = await contract.safeMint({value: ethers.utils.parseEther(MINT_PRICE)})
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - safeMint used ',gasUsed.toNumber(),' gas')
  // console.log(txReceipt.logs)

  // balance = await contract.provider.getBalance(contract.address)
  // console.log("Contract Balance: ", balance)

  // Check SVG by tokenURI
  // tokenId = ethers.BigNumber.from(WALLETMM)
  // result = await contract.tokenURI(tokenId)
  // console.log(result)

  // Check if mint is active
  result = await contract.isMintActive()
  console.log('Mint Active: ', result)

  // Check owner
  // result = await contract.getOwner()
  // console.log('Owner account: ', result)

  // Toggle mintActive
  // tx = await contract.toggleMintActive()
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - toggleMintActive used ',gasUsed.toNumber(),' gas')
  
  // ReCheck if mint is active
  // result = await contract.isMintActive()
  // console.log('Mint Active: ', result)

  // Set Mint to Inactive
  // tx = await contract.toggleMintActive()
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - toggleMintActive used ',gasUsed.toNumber(),' gas')

  // Withdraw Balance
  // tx = await contract.withdraw()
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - withdraw used ',gasUsed.toNumber(),' gas')

  // balance = await contract.provider.getBalance(contract.address)
  // console.log("Contract Balance: ", balance)

  // Mint 1 NFT by Team
  // tx = await contract.teamMint(WALLETMM)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')
  // // console.log(txReceipt.logs)

  // console.log();
  // addr = addr1
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr2
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr3
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')
  
  // console.log();
  // addr = addr4
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr6
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr7
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr8
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr9
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // console.log();
  // addr = addr0
  // console.log('Calling mintTeam for: ', addr)
  // tx = await contract.teamMint(addr)
  // txReceipt = await tx.wait()
  // gasUsed = txReceipt.gasUsed;
  // console.log(' - teamMint used ',gasUsed.toNumber(),' gas')

  // Check SVG by tokenURI
  // tokenId = ethers.BigNumber.from(WALLETMM)
  // result = await contract.tokenURI(tokenId)
  // console.log(result)

}

// Don't touch
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
