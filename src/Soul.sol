// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

contract Soul {
    event Set(address indexed usr, Tkn indexed tkn, uint indexed id, string data);

    error NotOwner();

    mapping(Tkn tkn => mapping(uint id => string)) public meta;

    function set(Tkn tkn, uint id, string calldata data) external payable {
        try tkn.ownerOf(id) returns (address owner) {
            if (msg.sender != owner) revert NotOwner();
        } catch {
            if (tkn.balanceOf(msg.sender, id) == 0) revert NotOwner();
        }

        emit Set(msg.sender, tkn, id, meta[tkn][id] = data);
    }
}

abstract contract Tkn {
    function ownerOf(uint) public view returns (address) {}
    function balanceOf(address, uint) public view returns (uint) {}
}
