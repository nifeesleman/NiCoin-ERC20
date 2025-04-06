//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {NiCoin} from "../src/NiCoin.sol";
import {DeployNiCoin} from "../script/DeployNiCoin.s.sol";

contract NiCoinTest is Test {
    NiCoin public niCoin;
    DeployNiCoin public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployNiCoin();
        niCoin = deployer.run();

        vm.prank(msg.sender);
        niCoin.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, niCoin.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend 1000 tokens
        vm.prank(bob);
        niCoin.approve(alice, initialAllowance);

        vm.prank(alice);
        niCoin.transferFrom(bob, alice, initialAllowance);

        assertEq(niCoin.balanceOf(alice), initialAllowance);
        assertEq(niCoin.balanceOf(bob), STARTING_BALANCE - initialAllowance);
    }
}
