// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

contract Soul {
    event Set(address indexed usr, Tkn indexed tkn, uint indexed id, string data);

    mapping(Tkn tkn => mapping(uint id => string)) public meta;

    function set(Tkn tkn, uint id, string calldata data) external payable {
        try tkn.ownerOf(id) returns (address owner) {
            if (msg.sender != owner) revert('Not 721 Owner');
        } catch {
            if (tkn.balanceOf(msg.sender, id) == 0) revert('Not 1155 Owner');
        }

        emit Set(msg.sender, tkn, id, meta[tkn][id] = data);
    }
}

abstract contract Tkn {
    function ownerOf(uint) external view returns (address) {}
    function balanceOf(address, uint) external view returns (uint) {}
}
