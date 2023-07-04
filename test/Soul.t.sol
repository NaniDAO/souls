// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import 'forge-std/Test.sol';
import {Soul, Tkn} from 'src/Soul.sol';

import {MockERC721} from 'lib/solbase/test/utils/mocks/MockERC721.sol';
import {MockERC1155} from 'lib/solbase/test/utils/mocks/MockERC1155.sol';

contract SoulsTest is Test {
    using stdStorage for StdStorage;

    event Set(address indexed usr, Tkn indexed tkn, uint indexed id, string data);

    Soul soul;
    address erc721;
    address erc1155;

    address alice = makeAddr('alice');
    address bob = makeAddr('bob');

    function setUp() external payable {
        soul = new Soul();
        erc721 = address(new MockERC721("Soul", "SOUL")); // Mock ERC721 contract.
        erc1155 = address(new MockERC1155()); // Mock ERC1155 contract.
    }

    // Test setting the soul for an ERC721 token.
    function testSetSoulERC721(uint tokenId, string memory soulData) public payable {
        MockERC721(erc721).safeMint(alice, tokenId, '');

        // Set the soul of the token.
        //vm.expectEmit(true, true, true, true);
        emit Set(alice, Tkn(erc721), tokenId, soulData);
        vm.prank(alice);
        soul.set(Tkn(erc721), tokenId, soulData);

        // Check the soul data.
        string memory result = soul.meta(Tkn(erc721), tokenId);
        assertEq(result, soulData);
    }

    // Test setting the soul for an ERC721 token with an incorrect owner.
    function testSetSoulERC721IncorrectOwner(uint tokenId, string memory soulData) public payable {
        MockERC721(erc721).safeMint(bob, tokenId, '');

        // Attempt to set the soul of the token with incorrect owner.
        vm.expectRevert();
        vm.prank(alice);
        soul.set(Tkn(erc721), tokenId, soulData);
    }

    // Test setting the soul for an ERC1155 token.
    function testSetSoulERC1155(uint tokenId, string memory soulData) public payable {
        // Assume the caller owns the ERC1155 token.
        MockERC1155(erc1155).mint(alice, tokenId, 1, '');

        // Set the soul of the token.
        vm.expectEmit(true, true, true, true);
        emit Set(alice, Tkn(erc1155), tokenId, soulData);
        vm.prank(alice);
        soul.set(Tkn(erc1155), tokenId, soulData);

        // Check the soul data.
        string memory result = soul.meta(Tkn(erc1155), tokenId);
        assertEq(result, soulData);
    }

    // Test setting the soul for an ERC1155 token with an incorrect owner.
    function testSetSoulERC1155IncorrectOwner(uint tokenId, string memory soulData) public payable {
        // Mint the ERC1155 token to bob
        MockERC1155(erc1155).mint(bob, tokenId, 1, '');

        // Attempt to set the soul of the token with incorrect owner.
        vm.expectRevert();
        emit Set(alice, Tkn(erc1155), tokenId, soulData);
        vm.prank(alice);
        soul.set(Tkn(erc1155), tokenId, soulData);
    }

    // Test setting the soul with an invalid token standard:

    // Test setting the soul for a non-existent ERC721 token.
    function testSetSoulNonExistentERC721(uint tokenId, string memory soulData) public payable {
        address fake721 = makeAddr('fake721');

        // Attempt to set the soul of the non-existent token.
        vm.expectRevert();
        emit Set(alice, Tkn(fake721), tokenId, soulData);
        vm.prank(alice);
        soul.set(Tkn(fake721), tokenId, soulData);
    }

    // Test setting the soul for a non-existent ERC1155 token:
    function testSetSoulNonExistentERC1155(uint tokenId, string memory soulData) public payable {
        // Deploy an ERC1155 token contract without minting any tokens.
        address fake1155 = makeAddr('fake1155');

        // Attempt to set the soul of the non-existent token.
        vm.expectRevert();
        emit Set(alice, Tkn(fake1155), tokenId, soulData);
        vm.prank(alice);
        soul.set(Tkn(fake1155), tokenId, soulData);
    }
}
