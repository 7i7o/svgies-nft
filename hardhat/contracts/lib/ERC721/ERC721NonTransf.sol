// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)

pragma solidity 0.8.12;


import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./extensions/IERC721Metadata.sol";

/**
 * @dev Modified from OZ to be non-transferrable and use only valid addresses for tokenIds
 * Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721NonTransf is IERC165, IERC721, IERC721Metadata {

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from address (tokenId) to bool (minted or not)
    mapping(address => bool) private _minted;

    error NonExistentToken(uint256 tokenId);
    error ForbiddenForZeroAddress();
    error NonTransferrableToken();
    error NonApprovableToken();
    error AlreadyMinted(uint256 tokenId);
    error NonERC721ReceiverImplementer(address addr);

    // Constructor
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // Implements IERC165
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    // Implements IERC721Metadata
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    // Implements IERC721Metadata
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // Implements IERC721Metadata (to be overriden in child contracts)
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert NonExistentToken(tokenId);
        return "";
    }

    // Returns 1 if minted, 0 otherwise
    function balanceOf(address owner) public view virtual override returns (uint256) {
        if (owner == address(0)) revert ForbiddenForZeroAddress();
        return (_minted[owner]) ? 1 : 0;
    }

    // Returns address if minted, throws otherwise
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        if (!_exists(tokenId)) revert NonExistentToken(tokenId);
        return address(uint160(tokenId));
    }

    // Throws for all, because it is a non-transferrable token
    function safeTransferFrom(
        address ,
        address ,
        uint256 ,
        bytes memory 
    ) public virtual override {
        revert NonTransferrableToken();
    }

    // Throws for all, because it is a non-transferrable token
    function safeTransferFrom(
        address ,
        address ,
        uint256 
    ) public virtual override {
        revert NonTransferrableToken();
    }

   // Throws for all, because it is a non-transferrable token
    function transferFrom(
        address ,
        address ,
        uint256 
    ) public virtual override {
        revert NonTransferrableToken();
    }

    // Throws for all, because it is a non-transferrable token
    function approve(address , uint256 ) public virtual override {
        revert NonApprovableToken();
    }

    // Throws for all, because it is a non-transferrable token
    function setApprovalForAll(address , bool ) public virtual override {
        revert NonApprovableToken();
    }

    // Returns 0x0, because no one can get approved
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        if (!_exists(tokenId)) revert NonExistentToken(tokenId);
        return address(0x0);
    }

    // Returns false, because no one can get approved
    function isApprovedForAll(address , address ) public view virtual override returns (bool) {
        return false;
    }

    /**
     * @dev Returns whether `tokenId` exists.
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _minted[address(uint160(tokenId))];
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        if (to == address(0)) revert ForbiddenForZeroAddress();
        if (_exists(tokenId)) revert AlreadyMinted(tokenId);
        
        _minted[to] = true;

        emit Transfer(address(0), to, tokenId);

        if (!_checkOnERC721Received(address(0), to, tokenId, ""))
            revert NonERC721ReceiverImplementer(to);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        if (!_exists(tokenId)) revert NonExistentToken(tokenId);

        delete _minted[address(uint160(tokenId))];

        emit Transfer(address(uint160(tokenId)), address(0), tokenId);
    }


    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert NonERC721ReceiverImplementer(to);
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

}
