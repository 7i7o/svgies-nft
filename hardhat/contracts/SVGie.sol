// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "./lib/ERC721/ERC721NonTransf.sol";
import { TokenURIDescriptor } from "./lib/TokenURIDescriptor.sol";

contract SVGie is ERC721NonTransf {

    error NotOwnerOf(uint256 tokenId);

    constructor() ERC721NonTransf("SVGie", "SVGie") {}

    function safeMint() public {
        _safeMint(msg.sender, uint256(uint160(msg.sender)));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721NonTransf)
        returns (string memory)
    {
        if (!_exists(tokenId)) revert NonExistentToken(tokenId);
        return
            TokenURIDescriptor.tokenURI(
                address(uint160(tokenId)),
                super.name(),
                super.symbol()
            );
    }

    function burn(uint256 tokenId) public virtual {
        if (msg.sender != address(uint160(tokenId))) revert NotOwnerOf(tokenId);
        _burn(tokenId);
    }
}
