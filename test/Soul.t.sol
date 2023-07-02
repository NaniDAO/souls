// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@std/Test.sol";
import {Souls,TokenStandard} from "src/Souls.sol";

import {MockERC721} from "@solmate/test/utils/mocks/MockERC721.sol";
import {MockERC1155} from "@solmate/test/utils/mocks/MockERC1155.sol";

contract SoulsTest is Test {
    using stdStorage for StdStorage;

    event Soul(address indexed _address, uint256 indexed _tokenId, string _data);

    Souls souls;
    MockERC721 erc721;
    MockERC1155 erc1155;
    
    address  alice = makeAddr("alice");

    function setUp() external {
        souls = new Souls();
        erc721 = new MockERC721("Soul", "SOUL"); // Mock ERC721 contract
        erc1155 = new MockERC1155(); // Mock ERC1155 contract
    }

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
}
