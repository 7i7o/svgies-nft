const { expect } = require("chai");
const { ethers } = require("hardhat");

const CONTRACT_NAME = 'Contract';

describe(CONTRACT_NAME, function () {

  let Contract;
  let contract;

  beforeEach(async function () {
    Contract = await ethers.getContractFactory(CONTRACT_NAME);
    contract = await Contract.deploy();
    await contract.deployed();
  });

  // it("Should convert uint8 to Hex String correctly", async function () {
  //   expect(await contract.uint8tohexchar(0)).to.equal(48);
  //   expect(await contract.uint8tohexchar(1)).to.equal(49);
  //   expect(await contract.uint8tohexchar(2)).to.equal(50);
  //   expect(await contract.uint8tohexchar(3)).to.equal(51);
  //   expect(await contract.uint8tohexchar(4)).to.equal(52);
  //   expect(await contract.uint8tohexchar(5)).to.equal(53);
  //   expect(await contract.uint8tohexchar(6)).to.equal(54);
  //   expect(await contract.uint8tohexchar(7)).to.equal(55);
  //   expect(await contract.uint8tohexchar(8)).to.equal(56);
  //   expect(await contract.uint8tohexchar(9)).to.equal(57);
  //   expect(await contract.uint8tohexchar(10)).to.equal(97);
  //   expect(await contract.uint8tohexchar(11)).to.equal(98);
  //   expect(await contract.uint8tohexchar(12)).to.equal(99);
  //   expect(await contract.uint8tohexchar(13)).to.equal(100);
  //   expect(await contract.uint8tohexchar(14)).to.equal(101);
  //   expect(await contract.uint8tohexchar(15)).to.equal(102);

  //   // const setGreetingTx = await contract.setGreeting("Hola, mundo!");

  //   // // wait until the transaction is mined
  //   // await setGreetingTx.wait();

  //   // expect(await contract.greet()).to.equal("Hola, mundo!");
  // });

  // it("Should fix opacity of a 4 byte color", async function () {
  //   expect(await contract.fixOpacity(0xffffff00)).to.equal('ffffffbf');
  //   expect(await contract.fixOpacity(0xffffff80)).to.equal('ffffffdf');
  //   expect(await contract.fixOpacity(0xffffffff)).to.equal('fffffffe');
  // });

  it("Should expect the correct path", async function () {
    // expect(await contract.getPath('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')).to.equal('M27 21C22 19 28 24 20 17S28 22 31 29S30 18 23 26S24 30 21 19S19 30 22 23S31 27 17 21S31 20 28 18S23 16 24 22S16 27 30 29Q44 31 27 21M21 21C26 19 20 24 28 17S20 22 17 29S18 18 25 26S24 30 27 19S29 30 26 23S17 27 31 21S17 20 20 18S25 16 24 22S32 27 18 29Q04 31 21 21z');
    // expect(await contract.getPathOld('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')).to.equal('M27 21C22 19 28 24 20 17S28 22 31 29S30 18 23 26S24 30 21 19S19 30 22 23S31 27 17 21S31 20 28 18S23 16 24 22S16 27 30 29Q44 31 27 21M21 21C26 19 20 24 28 17S20 22 17 29S18 18 25 26S24 30 27 19S29 30 26 23S17 27 31 21S17 20 20 18S25 16 24 22S32 27 18 29Q04 31 21 21z');
    // expect(await contract.getNewPath('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')).to.equal('M27 21C22 19 28 24 20 17S28 22 31 29S30 18 23 26S24 30 21 19S19 30 22 23S31 27 17 21S31 20 28 18S23 16 24 22S16 27 30 29Q44 31 27 21M21 21C26 19 20 24 28 17S20 22 17 29S18 18 25 26S24 30 27 19S29 30 26 23S17 27 31 21S17 20 20 18S25 16 24 22S32 27 18 29Q04 31 21 21z');
    expect(await contract.getNewPath2('0xB563C841C6FdE27A8e533E67fb15f4C270860BED')).to.equal('M27 21C22 19 28 24 20 17S28 22 31 29S30 18 23 26S24 30 21 19S19 30 22 23S31 27 17 21S31 20 28 18S23 16 24 22S16 27 30 29Q44 31 27 21M21 21C26 19 20 24 28 17S20 22 17 29S18 18 25 26S24 30 27 19S29 30 26 23S17 27 31 21S17 20 20 18S25 16 24 22S32 27 18 29Q04 31 21 21z');
  });

});
