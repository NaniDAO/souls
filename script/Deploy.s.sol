// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {Souls} from "src/Souls.sol";

/// @notice A very simple deployment script
contract Deploy is Script {
    /// @notice The main script entrypoint
    /// @return souls The deployed contract
    function run() external returns (Souls souls) {
        vm.startBroadcast();
        souls = new Souls();
        vm.stopBroadcast();
    }
}
