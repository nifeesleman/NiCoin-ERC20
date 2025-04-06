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
    uint256 public constant INITIAL_SUPPLY = 100 ether;

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

    function testApproveZeroAddressShouldFail() public {
        vm.expectRevert("ERC20: approve to the zero address");
        vm.prank(bob);
        niCoin.approve(address(0), 100);
    }

    function testTransferWorks() public {
        vm.prank(bob);
        niCoin.transfer(alice, 5 ether);

        assertEq(niCoin.balanceOf(alice), 5 ether);
        assertEq(niCoin.balanceOf(bob), STARTING_BALANCE - 5 ether);
    }

    function testApproveAndAllowance() public {
        uint256 allowanceAmount = 20 ether;

        vm.prank(bob);
        niCoin.approve(alice, allowanceAmount);

        assertEq(niCoin.allowance(bob, alice), allowanceAmount);
    }

    function testIncreaseAllowance() public {
        vm.prank(bob);
        niCoin.approve(alice, 10 ether);

        vm.prank(bob);
        niCoin.increaseAllowance(alice, 5 ether);

        assertEq(niCoin.allowance(bob, alice), 15 ether);
    }

    function testDecreaseAllowance() public {
        vm.prank(bob);
        niCoin.approve(alice, 10 ether);

        vm.prank(bob);
        niCoin.decreaseAllowance(alice, 4 ether);

        assertEq(niCoin.allowance(bob, alice), 6 ether);
    }

    function testDecreaseAllowanceBelowZeroShouldFail() public {
        vm.prank(bob);
        niCoin.approve(alice, 3 ether);

        vm.expectRevert("ERC20: decreased allowance below zero");
        vm.prank(bob);
        niCoin.decreaseAllowance(alice, 4 ether);
    }

    function testTotalSupplyIsCorrect() public view {
        assertEq(niCoin.totalSupply(), INITIAL_SUPPLY);
    }

    function testEmitTransferEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, 1 ether);
        niCoin.transfer(alice, 1 ether);
    }

    function testEmitApprovalEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, 10 ether);
        niCoin.approve(alice, 10 ether);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
