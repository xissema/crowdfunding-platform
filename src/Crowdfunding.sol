// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "openzeppelin/access/Ownable.sol";
import "openzeppelin/utils/math/Math.sol";

contract Crowdfunding is Ownable {
    struct FundingInfo {
        address creator;
        // Project information
        string projectName;
        string projectImage;
        string projectDescription;
        // Funding information
        uint256 totalDonated;
        uint256 targetAmount;
        // Flags
        bool isFinished;
    }

    mapping (uint256 => FundingInfo) public fundings;
    mapping (uint256 => mapping(address => uint256)) public donations;

    uint256 currentFundingID;
    uint256 serviceFee;

    event Donation(address indexed sender, uint256 amount);


    constructor(uint256 _serviceFee) Ownable(msg.sender) {
        serviceFee = _serviceFee;
    }

    function newFunding(FundingInfo calldata funding) external payable {
        require(funding.creator != address(0), "Invalid creator address");
        require(msg.value == serviceFee, "Service fee must be paid");

        fundings[currentFundingID] = funding;
        currentFundingID++;
    }

    function finishFunding(uint256 fundingID) external {
        FundingInfo storage funding = fundings[fundingID];
        require(!funding.isFinished, "Funding is already finished");
        require(funding.creator == msg.sender, "Only the creator can finish the funding");
 
        funding.isFinished = true;

        payable(msg.sender).transfer(funding.totalDonated);
    }

    function donate(uint256 fundingID) external payable {
        FundingInfo storage funding = fundings[fundingID];
        require(!funding.isFinished, "Funding is already finished");
        require(msg.value > 0, "Donation amount must be greater than zero");

        funding.totalDonated += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    function setServiceFee(uint256 _seviceFee) external onlyOwner {
        serviceFee = _seviceFee;
    }

}