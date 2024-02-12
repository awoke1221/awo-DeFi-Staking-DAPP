// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

pragma solidity ^0.8.9;

contract RewardToken is ERC20, Ownable, AccessControl, ERC20Burnable {
    using SafeERC20 for IERC20;

    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor() ERC20("awo", "awoT") Ownable(msg.sender) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external {
        require(hasRole(MANAGER_ROLE, msg.sender), "Not allowed");
        _totalSupply = _totalSupply + amount;
        _balances[to] = _balances[to] + amount;
        _mint(to, amount);
    }

    function safeAwoTransfer(address _to, uint256 _amount) external {
        require(hasRole(MANAGER_ROLE, msg.sender), "Not allowed");
        uint256 awoBallance = balanceOf(address(this));
        if (awoBallance > _amount) {
            transfer(_to, awoBallance);
        } else {
            transfer(_to, _amount);
        }
    }
}
