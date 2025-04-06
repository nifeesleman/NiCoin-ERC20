//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

contract ManualToken {
    function name() public pure returns (string memory) {
        return "ManualTokem";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }
}
