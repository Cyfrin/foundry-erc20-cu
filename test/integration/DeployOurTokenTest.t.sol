// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployOurToken} from "../../script/DeployOurToken.s.sol";
import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract DeployOurTokenTest is StdCheats, Test {
    function testDeployOurToken() public {
        DeployOurToken deployer = new DeployOurToken();
        assert(address(deployer.run()) != address(0));
    }
}
