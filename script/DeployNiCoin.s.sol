//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Script} from "forge-std/Script.sol";
import {NiCoin} from "../src/NiCoin.sol";

contract DeployNiCoin is Script {
    uint256 public constant INITAL_SUPPLY = 100 ether;

    function run() external {
        vm.startBroadcast();
        new NiCoin(INITAL_SUPPLY);
        vm.stopBroadcast();
    }
}
