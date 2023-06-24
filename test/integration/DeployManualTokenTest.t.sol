// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployManualToken} from "../../script/DeployManualToken.s.sol";
import {ManualToken} from "../../src/ManualToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract DeployManualTokenTest is StdCheats, Test {
    function testDeployManualToken() public {
        DeployManualToken deployer = new DeployManualToken();
        assert(address(deployer.run()) != address(0));
    }
}
