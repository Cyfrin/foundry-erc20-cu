// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployManualToken} from "../../script/DeployManualToken.s.sol";
import {ManualToken} from "../../src/ManualToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract ManualTokenTest is StdCheats, Test {
    uint256 public constant BOB_STARTING_AMOUNT = 100 ether;
    uint256 public constant TRANSFER_AMOUNT = 500;

    ManualToken public manualToken;
    DeployManualToken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployManualToken();
        manualToken = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        manualToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(
            manualToken.totalSupply(),
            deployer.INITIAL_SUPPLY() * 10 ** manualToken.decimals()
        );
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        manualToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        manualToken.transferFrom(bob, alice, transferAmount);
        assertEq(manualToken.balanceOf(alice), transferAmount);
        assertEq(
            manualToken.balanceOf(bob),
            BOB_STARTING_AMOUNT - transferAmount
        );
    }

    function testTransfer() public {
        uint256 previousBalances = manualToken.balanceOf(bob) +
            manualToken.balanceOf(alice);
        vm.prank(bob);
        bool success = manualToken.transfer(alice, TRANSFER_AMOUNT);
        assert(
            manualToken.balanceOf(bob) + manualToken.balanceOf(alice) ==
                previousBalances
        );
        assert(success);
    }

    function testBurn() public {
        uint256 previousBobBalance = manualToken.balanceOf(bob);
        uint256 previousTotalSupply = manualToken.totalSupply();

        vm.prank(bob);
        bool success = manualToken.burn(TRANSFER_AMOUNT);

        assert(
            manualToken.balanceOf(bob) == previousBobBalance - TRANSFER_AMOUNT
        );
        assert(
            manualToken.totalSupply() == previousTotalSupply - TRANSFER_AMOUNT
        );
        assert(success);
    }

    function testBurnFrom() public {
        uint256 initialAllowance = 1000;
        uint256 previousBobBalance = manualToken.balanceOf(bob);
        uint256 previousTotalSupply = manualToken.totalSupply();

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        manualToken.approve(alice, initialAllowance);

        vm.prank(alice);
        bool success = manualToken.burnFrom(bob, TRANSFER_AMOUNT);

        assert(
            manualToken.allowance(bob, alice) ==
                initialAllowance - TRANSFER_AMOUNT
        );
        assert(
            manualToken.balanceOf(bob) == previousBobBalance - TRANSFER_AMOUNT
        );
        assert(
            manualToken.totalSupply() == previousTotalSupply - TRANSFER_AMOUNT
        );
        assert(success);
    }
}
