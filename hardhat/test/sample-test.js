const { expect } = require("chai");
const { ethers } = require("hardhat");

const CONTRACT_NAME = 'SVGie';
const MINT_PRICE = '1';

describe(CONTRACT_NAME, function () {

  let Contract;
  let contract;
  let tx;
  let txReceipt;
  let gasUsed;
  let balance;
  let price;
  let acc;
  let totalSupply;

  const mintNFT = async (user, address) => {
    price = await contract.getPrice()
    console.log(' - Price is: ', price.toString(), ' MATIC ser')
    let supply = await contract.getTotalSupply()
    console.log('Supply: ', supply)
    tx = await contract.connect(user).safeMint(address, { value: price, })
    txReceipt = await tx.wait()
    totalSupply++;
  }

  const burnNFT = async (user, address) => {
    tx = await contract.connect(user).burn(ethers.BigNumber.from(address))
    txReceipt = await tx.wait()
    totalSupply--;
  }

  before(async function () {
    Contract = await ethers.getContractFactory(CONTRACT_NAME);
    contract = await Contract.deploy(ethers.utils.parseEther(MINT_PRICE));
    await contract.deployed();

    balance = await contract.provider.getBalance(contract.address)
    console.log("Contract Balance: ", balance)

    acc = await ethers.getSigners();
    [owner, user1, user2, user3, user4, user5, user6, user7, user8, user9] = acc;
    console.log('Accounts: ')
    console.log('  ', owner.address)
    console.log('  ', user1.address)
    console.log('  ', user2.address)
    console.log('  ', user3.address)
    console.log('  ', user4.address)
    console.log('  ', user5.address)
    console.log('  ', user6.address)
    console.log('  ', user7.address)
    console.log('  ', user8.address)
    console.log('  ', user9.address)

    // Set Mint Active
    tx = await contract.toggleMintActive()
    txReceipt = await tx.wait()
    gasUsed = txReceipt.gasUsed;
    console.log(' - toggleMintActive used ', gasUsed.toNumber(), ' gas')

    totalSupply = 0;
  });

  // beforeEach(async function () {
  //   // Get Price
  //   price = await contract.getPrice()
  //   // console.log(' - Price is: ', price.toString(), ' MATIC')

  // });

  it("Should mint an NFT", async function () {
    expect(await contract.getTotalSupply()).to.equal(totalSupply);

    tx = await mintNFT(owner, owner.address)

    expect(await contract.getTotalSupply()).to.equal(totalSupply);
  });

  it("Should mint and burn an NFT", async function () {
    expect(await contract.getTotalSupply()).to.equal(totalSupply);

    let tmp = await mintNFT(user1, user1.address)

    expect(await contract.getTotalSupply()).to.equal(totalSupply);
    
    tmp = await burnNFT(user1, user1.address)

    expect(await contract.getTotalSupply()).to.equal(totalSupply);
  });

  it("Should mint 9 NFTs", async function () {
    expect(await contract.getTotalSupply()).to.equal(totalSupply);

    tx = await contract.setSlowFactor(2)
    txReceipt = await tx.wait()

    let factor = await contract.getSlowFactor()
    console.log('Slow Factor: ', factor)

    tx = await mintNFT(user1, user1.address)
    tx = await mintNFT(user2, user2.address)
    tx = await mintNFT(user3, user3.address)
    tx = await mintNFT(user4, user4.address)
    tx = await mintNFT(user5, user5.address)
    tx = await mintNFT(user6, user6.address)
    tx = await mintNFT(user7, user7.address)
    tx = await mintNFT(user8, user8.address)
    tx = await mintNFT(user9, user9.address)

    expect(await contract.getTotalSupply()).to.equal(totalSupply);
  });

});
