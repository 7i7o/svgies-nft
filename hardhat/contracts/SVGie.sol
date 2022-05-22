// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@7i7o/tokengate/src/ERC721TGNT.sol";
import { TokenURIDescriptor } from "./lib/TokenURIDescriptor.sol";

contract SVGie is ERC721TGNT {

    address private owner;
    address private donationAddress;
    uint256 private totalSupply;
    uint256 private price;
    uint256 private nextPrice;
    uint256 private slowFactor;
    bool private mintActive;

    error NotOwnerOf(uint256 tokenId);

    error OnlyOwner();

    constructor(uint256 mintPrice) ERC721TGNT("SVGie", "SVGie") {
        owner = msg.sender;
        nextPrice = mintPrice;
    }

    function safeMint(address _to) public payable {
        require(mintActive, "Mint is not active");
        require(msg.value >= price, "Value sent < Mint Price");
        if (++totalSupply >= nextPrice * slowFactor) {
            uint256 oldPrice = price;
            price = nextPrice;
            nextPrice += oldPrice;
        }
        _safeMint(_to, uint256(uint160(_to)));
    }

    function teamMint(address _to) public {
        if (msg.sender != owner) revert OnlyOwner();
        totalSupply++;
        _safeMint(_to, uint256(uint160(_to)));
    }

    function burn(uint256 tokenId) public virtual {
        if (msg.sender != ownerOf(tokenId)) revert NotOwnerOf(tokenId);
        totalSupply--;
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721TGNT)
        returns (string memory)
    {
        require(_exists(tokenId), "SVGie: Non Existent TokenId");
        return
            TokenURIDescriptor.tokenURI(
                address(uint160(tokenId)),
                super.name(),
                super.symbol()
            );
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function setOwner(address newOwner) public {
        if (msg.sender != owner) revert OnlyOwner();
        owner = newOwner;
    }

    function getDonationAddress() public view returns (address) {
        return donationAddress;
    }

    function setDonationAddress(address newDonationAddress) public {
        if (msg.sender != owner) revert OnlyOwner();
        donationAddress = newDonationAddress;
    }

    function getPrice() public view returns (uint256) {
        return price;
    }

    function setPrice(uint256 mintPrice) public {
        if (msg.sender != owner) revert OnlyOwner();
        price = mintPrice;
    }

    function getNextPrice() public view returns (uint256) {
        return nextPrice;
    }

    function setNextPrice(uint256 mintPrice) public {
        if (msg.sender != owner) revert OnlyOwner();
        nextPrice = mintPrice;
    }

    function getSlowFactor() public view returns (uint256) {
        return slowFactor;
    }

    function setSlowFactor(uint256 factor) public {
        if (msg.sender != owner) revert OnlyOwner();
        slowFactor = factor;
    }

    function isMintActive() public view returns (bool) {
        return mintActive;
    }

    function toggleMintActive() public {
        if (msg.sender != owner) revert OnlyOwner();
        mintActive = !mintActive;
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function withdraw() public {
        uint256 amount = address(this).balance;
        bool success;
        // Revert if no funds
        require(amount > 0,"Balance is 0");
        // Withdraw funds.
        if (donationAddress == address(0x0)) {
            (success, ) = payable(owner).call{value: amount}("");
            require(success, "Withdraw failed");
            return;
        }
        
        amount /= 2;
        (success, ) = payable(donationAddress).call{value: amount}("");
        (success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

}
