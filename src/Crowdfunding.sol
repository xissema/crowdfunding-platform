// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "solmate/auth/Owned.sol";
import "solmate/tokens/ERC20.sol";

contract Crowdfunding is Owned {
    struct FundingInfo {
        address creator;
        string projectName;
        bool isFinished;
    }

    mapping (uint256 => FundingInfo) public fundings;

    uint256 currentFundingID;
    uint256 serviceFee;

    constructor(uint256 _serviceFee) Owned(msg.sender) {
        serviceFee = _serviceFee;
    }

    function newFunding(FundingInfo calldata funding) external payable {
        require(funding.creator != address(0), "Invalid creator address");

        fundings[currentFundingID] = funding;
        currentFundingID++;
    }

    function finishFunding(uint256 fundingID) external {}

    function donateETH(uint256 fundingID) external payable {}

    function donateToken(uint256 fundingID, ERC20 token, uint256 amount) external {
        
    }

}