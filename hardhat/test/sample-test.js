const { expect } = require("chai");
const { ethers } = require("hardhat");

const CONTRACT_NAME = 'SVGie';
const MINT_PRICE = '5';

describe(CONTRACT_NAME, function () {

  let Contract;
  let contract;
  let tx;
  let txReceipt;
  let gasUsed;
  let balance;

  beforeEach(async function () {
    Contract = await ethers.getContractFactory(CONTRACT_NAME);
    contract = await Contract.deploy(ethers.utils.parseEther(MINT_PRICE));
    await contract.deployed();

    balance = await contract.provider.getBalance(contract.address)
    console.log("Contract Balance: ", balance)

    // Set Mint Active
    tx = await contract.toggleMintActive()
    txReceipt = await tx.wait()
    gasUsed = txReceipt.gasUsed;
    console.log(' - toggleMintActive used ', gasUsed.toNumber(), ' gas')
  });

  it("Should mint an NFT", async function () {
    expect(await contract.getTotalSupply()).to.equal(0);

    tx = await contract.safeMint({ value: ethers.utils.parseEther(MINT_PRICE) })
    txReceipt = await tx.wait()
    gasUsed = txReceipt.gasUsed;
    console.log(' - safeMint used ', gasUsed.toNumber(), ' gas')
    // console.log(txReceipt.logs)

    expect(await contract.getTotalSupply()).to.equal(1);
  });

  it("Should mint and burn an NFT", async function () {
    expect(await contract.getTotalSupply()).to.equal(0);

    tx = await contract.safeMint({ value: ethers.utils.parseEther(MINT_PRICE) })
    txReceipt = await tx.wait()
    gasUsed = txReceipt.gasUsed;
    console.log(' - safeMint used ', gasUsed.toNumber(), ' gas')
    // console.log(txReceipt.logs)

    expect(await contract.getTotalSupply()).to.equal(1);

    // tx = await contract.burn()
    tx = await contract.burn(ethers.BigNumber.from('0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266'))
    txReceipt = await tx.wait()
    gasUsed = txReceipt.gasUsed;
    console.log(' - burn used ', gasUsed.toNumber(), ' gas')
    // console.log(txReceipt.logs)

    expect(await contract.getTotalSupply()).to.equal(0);
  });

});
