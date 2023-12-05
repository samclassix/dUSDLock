// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

struct LockupBatch {
    address depositFundsAddress;
    uint256 depositFundsAmount;
    uint256 depositFundsRefRatio;
    uint256 depositFundsLocktime;
    uint256 withdrawalRewardsAmount;
    uint256 withdrawalFundsAmount;
}

contract DUSDLOCK {
    // const states
    IERC20 public immutable lockedCoin;
    uint256 public immutable fundsLockupPeriod;
    uint256 public immutable fundsDepositCap;

    // changable states
    mapping(address => uint256[]) addressBatches;
    LockupBatch[] public lockupBatch;
    uint256 public totalDepositFunds;
    uint256 public totalWithdrawalFunds;
    uint256 public totalDepositRewards;
    uint256 public totalWithdrawalRewards;
    uint256 public refRatio;

    // events
    event CreateBatch(address _from, uint256 _amount, uint256 _refRatio, uint256 _locktime);
    event DepositRewards(address _from, uint256 _amount, uint256 _refRatio);
    event ClaimBatch(address _to, uint256 _amount);
    event ClaimRewards(address _to, uint256 _amount);

    // constructor
    constructor(IERC20 _lockedCoin, uint256 _fundsLockupPeriod, uint256 _fundsDepositCap ) {
        lockedCoin = _lockedCoin;
        fundsLockupPeriod = _fundsLockupPeriod;
        fundsDepositCap = _fundsDepositCap;
    }

    // create batch
    function createBatch(uint256 lockupAmount) external {
        require(lockupAmount + totalDepositFunds - totalWithdrawalFunds <= fundsDepositCap, "Fund deposit cap is reached");
        require(lockedCoin.balanceOf(msg.sender) >= lockupAmount, "Insufficient funds");

        uint256 locktime = block.number + fundsLockupPeriod;

        lockedCoin.transferFrom(msg.sender, address(this), lockupAmount);  
        addressBatches[msg.sender].push(lockupBatch.length);
        lockupBatch.push(LockupBatch(msg.sender, lockupAmount, refRatio, locktime, 0, 0));
        totalDepositFunds += lockupAmount;

        emit CreateBatch(msg.sender, lockupAmount, refRatio, locktime);
    }

    // deposit rewards
    function depositRewards(uint256 rewardAmount) external {
        require(lockupBatch.length > 0, "No batches available");
        require(lockedCoin.balanceOf(msg.sender) >= rewardAmount, "Insufficient funds");

        lockedCoin.transferFrom(msg.sender, address(this), rewardAmount);
        refRatio += rewardAmount * 10**18 / (totalDepositFunds - totalWithdrawalFunds);
        totalDepositRewards += rewardAmount;

        emit DepositRewards(msg.sender, rewardAmount, refRatio);
    }

    // claim batch
    function claimBatch(uint256 batchIdx, uint256 claimAmount) external {
        require(lockupBatch[batchIdx].depositFundsAddress == msg.sender, "Not owner of batch");
        require(lockupBatch[batchIdx].depositFundsLocktime <= block.number, "Batch is locked up");
        require(availableRewards(batchIdx) == 0, "Please claim rewards first");
        require(lockupBatch[batchIdx].depositFundsAmount - lockupBatch[batchIdx].withdrawalFundsAmount >= claimAmount, "Claim amount to high");

        lockupBatch[batchIdx].withdrawalFundsAmount += claimAmount; // line at the right line position? preventing exploits
        totalWithdrawalFunds += claimAmount;

        lockedCoin.approve(address(this), claimAmount);
        lockedCoin.transferFrom(address(this), msg.sender, claimAmount);

        emit ClaimBatch(msg.sender, claimAmount);
    }

    // available rewards
    function availableRewards(uint256 batchIdx) public view returns (uint256) {
        uint256 refRatioDiff = refRatio - lockupBatch[batchIdx].depositFundsRefRatio;
        uint256 lockedFundsDiff = lockupBatch[batchIdx].depositFundsAmount - lockupBatch[batchIdx].withdrawalFundsAmount;
        return refRatioDiff * lockedFundsDiff / 10**18 - lockupBatch[batchIdx].withdrawalRewardsAmount;
    }

    // claim rewards
    function claimRewards(uint256 batchIdx) external {
        uint256 claimAmount = availableRewards(batchIdx);
        require(lockupBatch[batchIdx].depositFundsAddress == msg.sender, "Not owner of batch");
        require(availableRewards(batchIdx) > 0, "No rewards to claim");

        lockupBatch[batchIdx].withdrawalRewardsAmount += claimAmount; // line at the right line position? preventing exploits
        totalWithdrawalRewards += claimAmount;

        lockedCoin.approve(address(this), claimAmount);
        lockedCoin.transferFrom(address(this), msg.sender, claimAmount);

        emit ClaimRewards(msg.sender, claimAmount);
    }

    // get all addressBatches
    function getAllAddressBatches(address addr) external view returns (uint256[] memory) {
        return addressBatches[addr];
    }
}