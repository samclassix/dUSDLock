// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract dUSD is ERC20 {

    constructor() ERC20("Decentralized USD", "DUSD") {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
    
}