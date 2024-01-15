// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./awo.sol";

contract Staking is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint256 amount;
        uint256 pengingReward;
    }

    struct PoolInfo {
        IERC20 lpToken;
        uint256 allocationPoint;
        uint256 lastRewardBlock;
        uint256 rewardTokenPerShare;
    }

    RewardToken public rwt;
    address public dev;
    uint256 public awoPerBlock;

    mapping(uint256 => mapping(address => UserInfo)) public userinfo;

    PoolInfo[] public poolInfo;
    uint256 public totalAllocation = 0;
    uint256 public startBlock;
    uint256 public BONES_MULTIPLAYER;

    constructor(
        RewardToken _rwt,
        uint256 _awoPerBlock,
        uint256 _startBlock,
        address _dev,
        uint256 _bonessMultiplayer
    ) Ownable(msg.sender) {
        rwt = _rwt;
        dev = _dev;
        awoPerBlock = _awoPerBlock;
        startBlock = _startBlock;
        BONES_MULTIPLAYER = _bonessMultiplayer;

        poolInfo.push(
            PoolInfo({
                lpToken: _rwt,
                allocationPoint: 10000,
                lastRewardBlock: _startBlock,
                rewardTokenPerShare: 0
            })
        );

        totalAllocation = 10000;
    }

    modifier validatePool(uint256 _pid) {
        require(_pid < poolInfo.length, "Invalid Pool Id");
        _;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    function getPoolInfo(
        uint pid
    )
        public
        view
        returns (
            IERC20 lpToken,
            uint256 allocationPoint,
            uint256 lastRewardBlock,
            uint256 rewardTokenPerShare
        )
    {
        return (
            poolInfo[pid].lpToken,
            poolInfo[pid].allocationPoint,
            poolInfo[pid].lastRewardBlock,
            poolInfo[pid].rewardTokenPerShare
        );
    }

    function getMultiplayer(
        uint256 _from,
        uint256 _to
    ) public view returns (uint256) {
        return (_to - _from) * BONES_MULTIPLAYER;
    }

    function upDateMultiplayer(uint256 multiplayerNimber) public {
        BONES_MULTIPLAYER = multiplayerNimber;
    }

    function checkPoolDuplication(IERC20 token) public view {
        uint256 length = poolInfo.length;
        for (uint _pid = 0; _pid < length; _pid++) {
            require(poolInfo[_pid].lpToken != token, "token Alredy Exist");
        }
    }

    function updateStakingPool() internal {
        uint256 length = poolInfo.length;
        uint256 points = 0;

        for (uint256 pid = 0; pid < length; pid++) {
            points = points + (poolInfo[pid].allocationPoint);
        }
        if (points != 0) {
            points = points / 3;
            totalAllocation =
                totalAllocation -
                (poolInfo[0].allocationPoint) +
                points;
            poolInfo[0].allocationPoint = points;
        }
    }

    function add(uint256 _allocationPoint, IERC20 _lpToken) public onlyOwner {
        checkPoolDuplication(_lpToken);
        uint256 lastRewardBlock = block.number > startBlock
            ? block.number
            : startBlock;
        totalAllocation = totalAllocation + _allocationPoint;
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocationPoint: _allocationPoint,
                lastRewardBlock: lastRewardBlock,
                rewardTokenPerShare: 0
            })
        );
        updateStakingPool();
    }

    function updatePool(uint256 _pid) public validatePool(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number < pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }

        uint256 multiplayer = getMultiplayer(
            pool.lastRewardBlock,
            block.number
        );
        uint256 tokenReward = multiplayer *
            awoPerBlock *
            (pool.allocationPoint / totalAllocation);
        rwt.mint(dev, tokenReward / 10);
        rwt.mint(address(this), tokenReward);
        pool.rewardTokenPerShare =
            pool.rewardTokenPerShare +
            ((tokenReward * 1e12) / lpSupply);
        pool.lastRewardBlock = block.number;
    }
}
