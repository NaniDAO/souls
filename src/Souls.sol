// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

enum TokenStandard {
    ERC721,
    ERC1155
}

abstract contract ERC721 {
    mapping(uint256 => address) internal _ownerOf;

    function ownerOf(uint256 id) public view virtual returns (address owner) {
        require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
    }
}

abstract contract ERC1155 {
    mapping(address => mapping(uint256 => uint256)) public balanceOf;
}

/**
 * @title Souls
 * @dev Contract for managing "souls" associated with NFTs
 */
contract Souls {
    /**
     * @dev Event emitted when a soul is set
     */
    event Soul(address indexed _setter, address indexed _address, uint256 indexed _tokenId, string _data);

    /**
     * @dev Custom error thrown when the caller is not the owner of the token
     */
    error NotOwner();

    /**
     * @dev Mapping to store metadata for each token
     */
    mapping(address => mapping(uint256 => string)) public metadata;

    /**
     * @dev Function to set the soul of a token
     * @param _address The address of the token contract
     * @param _tokenId The id of the token
     * @param _data The soul data to set
     * @param _standard The standard of the token (721 for ERC721, 1155 for ERC1155)
     */
    function set(address _address, uint256 _tokenId, string memory _data, TokenStandard _standard) external {
        if (_standard == TokenStandard.ERC721) {
            if (ERC721(_address).ownerOf(_tokenId) != msg.sender) revert NotOwner();
        } else if (_standard == TokenStandard.ERC1155) {
            if (ERC1155(_address).balanceOf(msg.sender, _tokenId) == 0) revert NotOwner();
        }

        metadata[_address][_tokenId] = _data;

        emit Soul(msg.sender, _address, _tokenId, _data);
    }
}
