const { expect } = require("chai");
const { ethers } = require("hardhat");

import CONTRACT_NAME from '../constants'

describe(CONTRACT_NAME, function () {

  it("Should convert uint8 to Hex String correctly", async function () {
    const Contract = await ethers.getContractFactory(CONTRACT_NAME);
    const contract = await Contract.deploy();
    await contract.deployed();

    expect(await contract.uint8tohexchar(0)).to.equal('0');
    expect(await contract.uint8tohexchar(1)).to.equal('1');
    expect(await contract.uint8tohexchar(2)).to.equal('2');
    expect(await contract.uint8tohexchar(3)).to.equal('3');
    expect(await contract.uint8tohexchar(4)).to.equal('4');
    expect(await contract.uint8tohexchar(5)).to.equal('5');
    expect(await contract.uint8tohexchar(6)).to.equal('6');
    expect(await contract.uint8tohexchar(7)).to.equal('7');
    expect(await contract.uint8tohexchar(8)).to.equal('8');
    expect(await contract.uint8tohexchar(9)).to.equal('9');
    expect(await contract.uint8tohexchar(10)).to.equal('a');
    expect(await contract.uint8tohexchar(11)).to.equal('b');
    expect(await contract.uint8tohexchar(12)).to.equal('c');
    expect(await contract.uint8tohexchar(13)).to.equal('d');
    expect(await contract.uint8tohexchar(14)).to.equal('e');
    expect(await contract.uint8tohexchar(15)).to.equal('f');

    // const setGreetingTx = await contract.setGreeting("Hola, mundo!");

    // // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await contract.greet()).to.equal("Hola, mundo!");
  });
});
