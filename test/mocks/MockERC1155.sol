// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Minimalist and gas efficient standard ERC1155 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)
abstract contract ERC1155 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint id, uint amount);

    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint[] ids, uint[] amounts);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    event URI(string value, uint indexed id);

    /*//////////////////////////////////////////////////////////////
                             ERC1155 STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => mapping(uint => uint)) public balanceOf;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /*//////////////////////////////////////////////////////////////
                             METADATA LOGIC
    //////////////////////////////////////////////////////////////*/

    function uri(uint id) public view virtual returns (string memory);

    /*//////////////////////////////////////////////////////////////
                              ERC1155 LOGIC
    //////////////////////////////////////////////////////////////*/

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function safeTransferFrom(address from, address to, uint id, uint amount, bytes calldata data) public virtual {
        require(msg.sender == from || isApprovedForAll[from][msg.sender], 'NOT_AUTHORIZED');

        balanceOf[from][id] -= amount;
        balanceOf[to][id] += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);

        require(
            to.code.length == 0
                ? to != address(0)
                : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data)
                    == ERC1155TokenReceiver.onERC1155Received.selector,
            'UNSAFE_RECIPIENT'
        );
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) public virtual {
        require(ids.length == amounts.length, 'LENGTH_MISMATCH');

        require(msg.sender == from || isApprovedForAll[from][msg.sender], 'NOT_AUTHORIZED');

        // Storing these outside the loop saves ~15 gas per iteration.
        uint id;
        uint amount;

        for (uint i = 0; i < ids.length;) {
            id = ids[i];
            amount = amounts[i];

            balanceOf[from][id] -= amount;
            balanceOf[to][id] += amount;

            // An array can't have a total length
            // larger than the max uint256 value.
            unchecked {
                ++i;
            }
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);

        require(
            to.code.length == 0
                ? to != address(0)
                : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data)
                    == ERC1155TokenReceiver.onERC1155BatchReceived.selector,
            'UNSAFE_RECIPIENT'
        );
    }

    function balanceOfBatch(address[] calldata owners, uint[] calldata ids)
        public
        view
        virtual
        returns (uint[] memory balances)
    {
        require(owners.length == ids.length, 'LENGTH_MISMATCH');

        balances = new uint256[](owners.length);

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint i = 0; i < owners.length; ++i) {
                balances[i] = balanceOf[owners[i]][ids[i]];
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == 0x01ffc9a7 // ERC165 Interface ID for ERC165
            || interfaceId == 0xd9b67a26 // ERC165 Interface ID for ERC1155
            || interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint id, uint amount, bytes memory data) internal virtual {
        balanceOf[to][id] += amount;

        emit TransferSingle(msg.sender, address(0), to, id, amount);

        require(
            to.code.length == 0
                ? to != address(0)
                : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, amount, data)
                    == ERC1155TokenReceiver.onERC1155Received.selector,
            'UNSAFE_RECIPIENT'
        );
    }

    function _batchMint(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) internal virtual {
        uint idsLength = ids.length; // Saves MLOADs.

        require(idsLength == amounts.length, 'LENGTH_MISMATCH');

        for (uint i = 0; i < idsLength;) {
            balanceOf[to][ids[i]] += amounts[i];

            // An array can't have a total length
            // larger than the max uint256 value.
            unchecked {
                ++i;
            }
        }

        emit TransferBatch(msg.sender, address(0), to, ids, amounts);

        require(
            to.code.length == 0
                ? to != address(0)
                : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data)
                    == ERC1155TokenReceiver.onERC1155BatchReceived.selector,
            'UNSAFE_RECIPIENT'
        );
    }

    function _batchBurn(address from, uint[] memory ids, uint[] memory amounts) internal virtual {
        uint idsLength = ids.length; // Saves MLOADs.

        require(idsLength == amounts.length, 'LENGTH_MISMATCH');

        for (uint i = 0; i < idsLength;) {
            balanceOf[from][ids[i]] -= amounts[i];

            // An array can't have a total length
            // larger than the max uint256 value.
            unchecked {
                ++i;
            }
        }

        emit TransferBatch(msg.sender, from, address(0), ids, amounts);
    }

    function _burn(address from, uint id, uint amount) internal virtual {
        balanceOf[from][id] -= amount;

        emit TransferSingle(msg.sender, from, address(0), id, amount);
    }
}

/// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)
abstract contract ERC1155TokenReceiver {
    function onERC1155Received(address, address, uint, uint, bytes calldata) external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint[] calldata, uint[] calldata, bytes calldata)
        external
        virtual
        returns (bytes4)
    {
        return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
    }
}

contract MockERC1155 is ERC1155 {
    function uri(uint) public pure virtual override returns (string memory) {}

    function mint(address to, uint id, uint amount, bytes memory data) public virtual {
        _mint(to, id, amount, data);
    }

    function batchMint(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) public virtual {
        _batchMint(to, ids, amounts, data);
    }

    function burn(address from, uint id, uint amount) public virtual {
        _burn(from, id, amount);
    }

    function batchBurn(address from, uint[] memory ids, uint[] memory amounts) public virtual {
        _batchBurn(from, ids, amounts);
    }
}
