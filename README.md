# dUSDLock

Implementation of dUSDLock for DMC. Goals are simplicity and no-looping.

---

Smart Contract Functions

-   [x] createBatch(uint256 lockupAmount) external
-   [x] depositRewards(uint256 rewardAmount) external
-   [x] claimBatch(uint256 batchIdx, uint256 claimAmount) external
-   [x] claimRewards(uint256 batchIdx) external

Smart Contract Helper Functions

-   [x] getAllAddressBatches
-   [x] availableRewards(uint256 batchIdx) public view returns (uint256)

Events

-   [x] CreateBatch(address \_from, uint256 \_amount, uint256 \_refRatio, uint256 \_locktime);
-   [x] DepositReward(address \_from, uint256 \_amount, uint256 \_refRatio);
-   [x] ClaimBatch(address \_to, uint256 \_amount);
-   [x] ClaimReward(address \_to, uint256 \_amount);

---

# What is a LockupBatch?

LockupBatches are like accounting bookkeepings, with amounts which can only increase, never decrease.
The idea behind this implementation is to create batches accordingly to this struct:

```
struct LockupBatch {
    address depositFundsAddress;
    uint256 depositFundsAmount;
    uint256 depositFundsRefRatio;
    uint256 depositFundsLocktime;
    uint256 withdrawalRewardsAmount;
    uint256 withdrawalFundsAmount;
}
```

# What is the strategy behind refRatio?

I guess you could say this idea comes from science, an implementation of entropy.
refRatio can only increase, never decrease. And gives a reference ratio to "when" you locked up your funds related to rewards deposits.

# What will influence the refRatio?

Each time you deposit rewards to the SC, the refRatio (aka entropy) will increase.

# Testing stage

dusd-token.sol can be used to emulate the dUSD token.
Developer testing only. No stress testing, yet.

Feel free to reach out if you have any questions or for bugs reporting.
