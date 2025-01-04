//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console} from "forge-std/Test.sol";

contract Escrow {
    // State Variables
    mapping(address => uint256) balance; 
    struct PartiesInvolved {
        address arbiter;
        address beneficiary;
        uint256 agreedAmount; 
    }
    // Mapping to store multiple agreements for a single depositor
    mapping(address => PartiesInvolved[]) public agreement;
    // Error Definitions
    error onlyArbiterCanApprovePayment();
    error transactionFailed();
    error onlyDepositorCanFundTheContract();
    error onlyOwnerIsAllowed(); 
    // Events
    event Deposit(address indexed _depositor, uint256 _amount);
    event Agreement(address indexed _depositor, address indexed _beneficiary, address indexed _arbiter);
    event Refund(address indexed _depositor, uint256 _amount);
    event Approve(address indexed _arbiter, uint256 _amount);
    // Owner
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    // Modifiers
    modifier onlyOwner(){
      if(msg.sender != owner){
        revert onlyOwnerIsAllowed(); 
      }
      _; 
    }
    modifier onlyArbiter(address depositor) {
        bool isArbiter; 
        console.log("checking for arbiter"); 
        for (uint i = 0; i < agreement[depositor].length; i++) {
            if (agreement[depositor][i].arbiter == msg.sender) {
                isArbiter = true;
                break;
            }
        }
        if (!isArbiter) {
            revert onlyArbiterCanApprovePayment();
        }
        _;
    }
    modifier onlyDepositor() {
        if (agreement[msg.sender].length == 0) {
            revert onlyDepositorCanFundTheContract();
        }
        _;
    }
    // Functions
    // Depositor funds the contract
    function fund(uint256 agreementIndex, address _depositor) external payable onlyDepositor {
        require(msg.value > 0, "You must send some ether");
        uint256 agreedAmount = agreement[_depositor][agreementIndex].agreedAmount; 
        require(agreedAmount >= msg.value, "you can't fund less than the agreed amount"); 
        balance[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    // handles depositor makes multiple agreements with multiple arbiters and beneficiaries
    function makeAgreement(address _beneficiary, address _arbiter, uint256 _agreedAmount) external {
        agreement[msg.sender].push(PartiesInvolved(_arbiter, _beneficiary, _agreedAmount));
        emit Agreement(msg.sender, _beneficiary, _arbiter);
    }
    // Arbiter approves and sends funds to the beneficiary based on agreement index
    function approve(uint256 agreementIndex, address depositor) external onlyArbiter(depositor) {
        require(agreementIndex < agreement[depositor].length, "Invalid agreement index");

        address _beneficiary = agreement[depositor][agreementIndex].beneficiary;
        uint256 fundedAmount = getFundedBalance(depositor);
        uint256 agreedAmount = agreement[depositor][agreementIndex].agreedAmount; 
        (bool success, ) = payable(_beneficiary).call{value: agreedAmount}("");
        console.log(address(_beneficiary).balance); 
        if (!success) {
            revert transactionFailed();
        }
        balance[depositor] -= agreedAmount; 
        emit Approve(msg.sender, agreedAmount);
    }
    // Refund function
    function refund(uint256 agreementIndex, address depositor) external onlyArbiter(depositor) {
        uint256 fundedAmount = getFundedBalance(depositor);
        uint256 agreedAmount = agreement[depositor][agreementIndex].agreedAmount; 
        require(agreedAmount > 0, "amount cannot be zero"); 
        (bool success, ) = payable(depositor).call{value: agreedAmount}("");
        if (!success) {
            revert transactionFailed();
        }
        balance[depositor] -= agreedAmount; 
        emit Refund(depositor, agreedAmount);
    }
    function resolveDispute() external onlyOwner{
      (bool success, )  = payable(owner).call{value: (address(this)).balance}(""); 
      if(!success){
        revert transactionFailed(); 
      }
    }
    function getFundedBalance(address _depositor) public view returns (uint256) {
        return balance[_depositor];
    }

    function getAgreements(address depositor) external view returns (PartiesInvolved[] memory) {
    return agreement[depositor];
}

}

