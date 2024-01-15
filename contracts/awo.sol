// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.9;

contract RewardToken is ERC20 {
    address private owner;

    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    constructor() ERC20("awo", "awoT") {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Not allowed");
        _totalSupply = _totalSupply + amount;
        _balances[to] = _balances[to] + amount;
        _mint(to, amount);
    }
}