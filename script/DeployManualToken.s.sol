// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script {
    // No need for 'ether' since ManualToken adds 18 decimals itself
    uint256 public constant INITIAL_SUPPLY = 1_000_000;
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (ManualToken) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerKey);
        ManualToken manualToken = new ManualToken(
            INITIAL_SUPPLY,
            "Manual Token",
            "MTK"
        );
        vm.stopBroadcast();
        return manualToken;
    }
}
