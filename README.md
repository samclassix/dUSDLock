# dUSDLock

Implementation of dUSDLock for DMC. Goals are simplicity and no-looping.

-   [testing] Smart Contract
-   [development] React App

---

### Smart Contract Overview

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

Removed features

-   [x] fundsUnlockPeriod

---

### What is a LockupBatch?

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

### What is the strategy behind refRatio?

I guess you could say this idea comes from science, an implementation of entropy.
refRatio can only increase, never decrease. And gives a reference ratio to "when" you locked up your funds related to rewards deposits.

### What will influence the refRatio?

Each time you deposit rewards to the SC, the refRatio (aka entropy) will increase.

### Testing stage

dusd-token.sol can be used to emulate the dUSD token.
Developer testing only. No stress testing, yet.

Feel free to reach out if you have any questions or for bugs reporting.

# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.\
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).
