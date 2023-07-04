// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import 'forge-std/Script.sol';
import 'src/Soul.sol';

/// @notice A very simple deployment script.
contract Deploy is Script {
    /// @notice The main script entrypoint.
    /// @return soul The deployed contract.
    function run() public returns (Soul soul) {
        vm.startBroadcast();
        soul = new Soul();
        vm.stopBroadcast();
    }
}
