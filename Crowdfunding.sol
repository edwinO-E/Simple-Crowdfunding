// Licence
// SPDX-License-Identifier: LGPL-3.0-only

//Solidity version
pragma solidity 0.8.33;

contract Crowdfunding {

    //Variables
    address public admin;
    uint256 public goal;            //target ammount
    uint256 public deadline;        //limit time
    uint256 public totalRaised;     //total ETH raised
    bool public fundsWithdrawn;

    //Mapping
    mapping(address => uint256) public contribution;

    //Events
    event ContributionMade(address user_, uint256 amount_, uint256 totalRaised_);
    event FundsWithdrawn(address admin_, uint256 amount_);
    event RefundClaimed(address user_, uint256 amount_);

    //modifiers
    modifier onlyAdmin(){
        require(msg.sender == admin, "Not allowed");
        _;
    }

    //Constructor
    constructor(uint256 goal_, uint256 durationSeconds_){ // Campaing time ( only in seconds example : 7 days ( 7 * 24 * 60 * 60)
        admin = msg.sender;
        goal = goal_;
        deadline = block.timestamp + durationSeconds_;    
    }

    //Funtions
    //Externals
    //contribute ETH
    function contribute() external payable { 
        require(block.timestamp < deadline,"Campain ended");
        require(msg.value > 0, "zero contribution");
        require(!fundsWithdrawn,"already withdrawn");

        contribution[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit ContributionMade(msg.sender, msg.value, totalRaised);
    }

    //admin claim funds if goal is reached after deadline
    function withdrawFunds() external onlyAdmin {     
        //CEI pattern
        require(block.timestamp >= deadline, "waint until deadline");
        require(totalRaised >= goal, "goal not reached");
        require(!fundsWithdrawn, "already withdrawn");

        fundsWithdrawn = true;

        (bool success,) = admin.call{value: totalRaised}("");
        require(success,"transfer failed");

        emit FundsWithdrawn(admin, totalRaised);
    }

    //User ask for refund if goal not reached after deadline
    function claimRefund() external {
        //CEI pattern
        require(block.timestamp >= deadline, "wait until deadline");
        require(totalRaised < goal, "goal reached");
        require(!fundsWithdrawn, "already withdrawn");

        uint256 amount_ = contribution[msg.sender];
        require(amount_ > 0, "nothing to refund");

        contribution[msg.sender] = 0;

        (bool success,) = msg.sender.call{value: amount_}("");
        require(success, "refund failed");

        emit RefundClaimed(msg.sender, amount_);
    }

}