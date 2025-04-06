//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NiCoin is ERC20 {
    constructor(uint256 initailSupply) ERC20("NiCoin", "NC") {
        _mint(msg.sender, initailSupply);
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        if (spender == address(0)) {
            revert("ERC20: approve to the zero address");
        }
        return super.approve(spender, amount);
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            allowance(_msgSender(), spender) + addedValue
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        uint256 currentAllowance = allowance(_msgSender(), spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        return true;
    }
}
