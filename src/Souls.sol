// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @title Souls
/// @author NaN1

contract Souls {
    event Soul(address indexed setter, Souls indexed tkn, uint indexed id, string data);

    error NotOwner();

    mapping(Souls tkn => mapping(uint id => string)) public meta;

    function set(Souls tkn, uint id, string calldata data, bool nft) external payable {
        if (nft) { if (msg.sender != tkn.ownerOf(id)) revert NotOwner(); 
        } else { if (tkn.balanceOf(msg.sender, id) == 0) revert NotOwner(); }
        emit Soul(msg.sender, tkn, id, meta[tkn][id] = data);
    }

    /// @dev External mapping helpers.
    mapping(uint256 => address) public ownerOf;
    mapping(address => mapping(uint256 => uint256)) public balanceOf;
}