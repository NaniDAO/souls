// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@std/Test.sol";
import {Souls} from "src/Souls.sol";

import {ERC721} from "@base/tokens/ERC721/ERC721.sol";
import {ERC1155} from "@base/tokens/ERC1155/ERC1155.sol";

contract SoulsTest is Test {
    using stdStorage for StdStorage;

    Souls souls;
    ERC721 erc721;
    ERC1155 erc1155;

    function setUp() external {
        souls = new Souls();
        erc721 = ERC721(address(this)); // Mock ERC721 contract
        erc1155 = ERC1155(address(this)); // Mock ERC1155 contract
    }

    function testSetSoulERC721() external {
        uint256 tokenId = 1;
        string memory soulData = "Soul Data";

        // Assume the caller owns the ERC721 token
        erc721._mint(address(this), tokenId);

        // Set the soul of the token
        souls.set(address(erc721), tokenId, soulData, 721);

        // Expect the Soul event to be emitted
        vm.expectEmit(true, true, true, true);
        emit souls.Soul(address(erc721), tokenId, soulData);

        // Check the soul data
        string memory result = souls.metadata(address(erc721), tokenId);
        assertEq(result, soulData);
    }

    function testSetSoulERC1155() external {
        uint256 tokenId = 1;
        string memory soulData = "Soul Data";

        // Assume the caller owns the ERC1155 token
        erc1155.mint(address(this), tokenId, 1);

        // Set the soul of the token
        souls.set(address(erc1155), tokenId, soulData, 1155);

        // Expect the Soul event to be emitted
        vm.expectEmit(true, true, true, true);
        emit souls.Soul(address(erc1155), tokenId, soulData);

        // Check the soul data
        string memory result = souls.metadata(address(erc1155), tokenId);
        assertEq(result, soulData);
    }
}
