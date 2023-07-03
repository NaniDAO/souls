// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "@std/Test.sol";

import {MockERC721} from "@solmate/test/utils/mocks/MockERC721.sol";
import {MockERC1155} from "@solmate/test/utils/mocks/MockERC1155.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import "forge-std/console.sol";

interface Souls {
    function set721(address, uint256, string calldata) external;
    function set1155(address, uint256, string calldata) external;
    function get(address, uint256) external returns (string calldata);
}

contract SoulsTest is Test {
    using stdStorage for StdStorage;

    error NotOwner();

    Souls public souls;

    address erc721;
    address erc1155;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() external payable {
        // Deploy a new instance of src/test/contracts/Number.huff
        souls = Souls(HuffDeployer.deploy("test/contracts/Souls.huff"));
  
        erc721 = address(new MockERC721("Soul", "SOUL")); // Mock ERC721 contract
        erc1155 = address(new MockERC1155()); // Mock ERC1155 contract
    }

    // Test setting the soul for an ERC721 token
    function testSetSoulERC721(uint256 tokenId) external payable {
        MockERC721(erc721).safeMint(alice, tokenId, "");

        string memory soulData = 'hello world';

        // // Set the soul of the token
        // // vm.expectEmit(true, true, true, true);
        // // emit Soul(alice, address(erc721), tokenId, soulData);
        vm.prank(alice);
        souls.set721(address(erc721), tokenId, soulData);

        // // Check the soul data
        // string memory result = souls.get(address(erc721), tokenId);
        // console.log(alice, result);
        // assertEq(result, soulData);
    }
    
    // // Test setting the soul for an ERC721 token with an incorrect owner
    // function testSetSoulERC721IncorrectOwner(uint256 tokenId, string memory soulData) external payable {
    //     MockERC721(erc721).safeMint(bob, tokenId, "");

    //     // Attempt to set the soul of the token with incorrect owner
    //     vm.expectRevert(NotOwner.selector);
    //     vm.prank(alice);
    //     souls.set(address(erc721), tokenId, soulData);
    // }

    // // Test setting the soul for an ERC1155 token.
    // function testSetSoulERC1155(uint256 tokenId, string memory soulData) external payable {
    //     // Assume the caller owns the ERC1155 token
    //     MockERC1155(erc1155).mint(alice, tokenId, 1, "");

    //     // Set the soul of the token
    //     // vm.expectEmit(true, true, true, true);
    //     // emit Soul(alice, Souls(erc1155), tokenId, soulData);
    //     vm.prank(alice);
    //     souls.set(address(erc1155), tokenId, soulData);

    //     // Check the soul data
    //     string memory result = souls.get(address(erc1155), tokenId);
    //     assertEq(result, soulData);
    // }
    
    // // Test setting the soul for an ERC1155 token with an incorrect owner.
    // function testSetSoulERC1155IncorrectOwner(uint256 tokenId, string memory soulData) external payable {
    //     // Mint the ERC1155 token to bob
    //     MockERC1155(erc1155).mint(bob, tokenId, 1, "");

    //     // Attempt to set the soul of the token with incorrect owner
    //     // vm.expectRevert(NotOwner.selector);
    //     // emit Soul(alice, Souls(erc1155), tokenId, soulData);
    //     vm.prank(alice);
    //     souls.set(address(erc1155), tokenId, soulData);
    // }
    
    // // Test setting the soul with an invalid token standard

    // // Test setting the soul for a non-existent ERC721 token
    // function testSetSoulNonExistentERC721(uint256 tokenId, string memory soulData) external payable {
    //     address fake721 = makeAddr("fake721");

    //     // Attempt to set the soul of the non-existent token
    //     // vm.expectRevert();
    //     // emit Soul(alice, Souls(fake721), tokenId, soulData);
    //     vm.prank(alice);
    //     souls.set(address(fake721), tokenId, soulData);
    // }

    // // Test setting the soul for a non-existent ERC1155 token:
    // function testSetSoulNonExistentERC1155(uint256 tokenId, string memory soulData) external payable {
    //     // Deploy an ERC1155 token contract without minting any tokens
    //     address fake1155 = makeAddr("fake1155");

    //     // Attempt to set the soul of the non-existent token
    //     // vm.expectRevert();
    //     // emit Soul(alice, Souls(fake1155), tokenId, soulData);
    //     vm.prank(alice);
    //     souls.set(address(fake1155), tokenId, soulData);
    // }
}
