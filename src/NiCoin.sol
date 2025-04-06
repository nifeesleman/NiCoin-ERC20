//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NiCoin is ERC20 {
    constructor(uint256 initailSupply) ERC20("NiCoin", "NC") {
        _mint(msg.sender, initailSupply);
    }
}
