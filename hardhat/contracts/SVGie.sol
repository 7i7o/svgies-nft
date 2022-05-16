// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

// import "./lib/ERC721/ERC721NonTransf.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { TokenURIDescriptor } from "./lib/TokenURIDescriptor.sol";

// contract SVGie is ERC721NonTransf {
contract SVGie is ERC721 {

    address private owner;
    uint256 private totalSupply;
    uint256 private price;
    bool private mintActive;

    error NotOwnerOf(uint256 tokenId);

    error OnlyOwner();

    // constructor(uint256 mintPrice) ERC721NonTransf("SVGie", "SVGie") {
    constructor(uint256 mintPrice) ERC721("SVGie", "SVGie") {
        owner = msg.sender;
        setPrice(mintPrice);
    }

    function safeMint() public payable {
        require(mintActive, "Mint is not active");
        require(msg.value >= price, "Value sent < Mint Price");
        totalSupply++;
        _safeMint(msg.sender, uint256(uint160(msg.sender)));
    }

    function burn(uint256 tokenId) public virtual {
    // function burn() public virtual {
        if (msg.sender != ownerOf(tokenId)) revert NotOwnerOf(tokenId);
        totalSupply--;
        _burn(tokenId);
        // _burn(uint256(uint160(msg.sender)));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        // override(ERC721NonTransf)
        override(ERC721)
        returns (string memory)
    {
        // if (!_exists(tokenId)) revert NonExistentToken(tokenId);
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

    function getPrice() public view returns (uint256) {
        return price;
    }

    function setPrice(uint256 mintPrice) public {
        if (msg.sender != owner) revert OnlyOwner();
        price = mintPrice;
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
        // if (msg.sender != owner) revert OnlyOwner();
        uint256 amount = address(this).balance;
        // Revert if no funds
        require(amount > 0,"Balance is 0");
        // Withdraw funds.
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Withdraw failed");
    }

}
