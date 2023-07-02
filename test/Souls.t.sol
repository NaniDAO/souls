// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@std/Test.sol";
import {Souls, TokenStandard} from "src/Souls.sol";

import {MockERC721} from "@solmate/test/utils/mocks/MockERC721.sol";
import {MockERC1155} from "@solmate/test/utils/mocks/MockERC1155.sol";

contract SoulsTest is Test {
    using stdStorage for StdStorage;

    event Soul(address indexed _address, uint256 indexed _tokenId, string _data);

    error NotOwner();

    Souls souls;
    MockERC721 erc721;
    MockERC1155 erc1155;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() external {
        souls = new Souls();
        erc721 = new MockERC721("Soul", "SOUL"); // Mock ERC721 contract
        erc1155 = new MockERC1155(); // Mock ERC1155 contract
    }

    // Test setting the soul for an ERC721 token
    function testSetSoulERC721(uint256 tokenId, string memory soulData) external {
        erc721.safeMint(alice, tokenId, "");

        // Set the soul of the token
        vm.expectEmit(true, true, true, true);
        emit Soul(address(erc721), tokenId, soulData);
        vm.prank(alice);
        souls.set(address(erc721), tokenId, soulData, TokenStandard.ERC721);

        // Check the soul data
        string memory result = souls.metadata(address(erc721), tokenId);
        assertEq(result, soulData);
    }

    // Test setting the soul for an ERC721 token with an incorrect owner
    function testSetSoulERC721IncorrectOwner(uint256 tokenId, string memory soulData) external {
        erc721.safeMint(bob, tokenId, "");

        // Attempt to set the soul of the token with incorrect owner
        vm.expectRevert(NotOwner.selector);
        emit Soul(address(erc721), tokenId, soulData);
        vm.prank(alice);
        souls.set(address(erc721), tokenId, soulData, TokenStandard.ERC721);
    }

    // Test setting the soul for an ERC1155 token
    function testSetSoulERC1155(uint256 tokenId, string memory soulData) external {
        // Assume the caller owns the ERC1155 token
        erc1155.mint(alice, tokenId, 1, "");
        // Set the soul of the token

        vm.expectEmit(true, true, true, true);
        emit Soul(address(erc1155), tokenId, soulData);
        vm.prank(alice);
        souls.set(address(erc1155), tokenId, soulData, TokenStandard.ERC1155);

        // Check the soul data
        string memory result = souls.metadata(address(erc1155), tokenId);
        assertEq(result, soulData);
    }

    // Test setting the soul for an ERC1155 token with an incorrect owner
    function testSetSoulERC1155IncorrectOwner(uint256 tokenId, string memory soulData) external {
        // Mint the ERC1155 token to bob
        erc1155.mint(bob, tokenId, 1, "");

        // Attempt to set the soul of the token with incorrect owner
        vm.expectRevert(NotOwner.selector);
        emit Soul(address(erc1155), tokenId, soulData);
        vm.prank(alice);
        souls.set(address(erc1155), tokenId, soulData, TokenStandard.ERC1155);
    }

    // Test setting the soul with an invalid token standard

    // Test setting the soul for a non-existent ERC721 token
    function testSetSoulNonExistentERC721(uint256 tokenId, string memory soulData) external {
        address fake721 = makeAddr("fake721");

        // Attempt to set the soul of the non-existent token
        vm.expectRevert();
        emit Soul(fake721, tokenId, soulData);
        vm.prank(alice);
        souls.set(fake721, tokenId, soulData, TokenStandard.ERC721);
    }

    // Test setting the soul for a non-existent ERC1155 token:
    function testSetSoulNonExistentERC1155(uint256 tokenId, string memory soulData) external {
        // Deploy an ERC1155 token contract without minting any tokens
        address fake1155 = makeAddr("fake1155");

        // Attempt to set the soul of the non-existent token
        vm.expectRevert();
        emit Soul(fake1155, tokenId, soulData);
        vm.prank(alice);
        souls.set(fake1155, tokenId, soulData, TokenStandard.ERC1155);
    }
}
