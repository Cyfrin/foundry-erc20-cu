// contracts/OurToken.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor() ERC20("OurToken", "OT") {
        _mint(msg.sender, 100e18);
    }
}
