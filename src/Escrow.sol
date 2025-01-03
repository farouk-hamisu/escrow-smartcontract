//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 
contract Escrow {
  address public owner; 
  address public depositor;  
  address public arbiter; 
  address public beneficiary; 
  mapping(address=>uint256) balance; 
  error onlyArbiterCanApprovePayment(); 
  error transactionFailed(); 
  error onlyDepositorCanFundTheContract(); 
  event Deposit(address indexed _depositor, uint256 _amount); 
  event Agreement(address indexed _depositor, address indexed _beneficiary, address indexed _arbiter); 
  event Approve(address indexed _arbiter, uint256 _amount); 
  constructor(){
    owner = msg.sender; 
  }
  modifier onlyArbiter(){
    if(msg.sender != arbiter){
      revert onlyArbiterCanApprovePayment(); 
    }
    _; 
  }
  modifier onlyDepositor() {
    if(msg.sender != depositor){
      revert onlyDepositorCanFundTheContract(); 
    }
    _; 
  }
  function fund() external payable onlyDepositor {
    balance[msg.sender] = msg.value; 
    emit Deposit(msg.sender, msg.value); 
  }
  function makeAgreement(address _beneficiary, address _arbiter) external {
    depositor = msg.sender; 
    beneficiary = _beneficiary; 
    arbiter = _arbiter; 
    emit Agreement (msg.sender, _beneficiary, _arbiter); 
  }
  function approve() external onlyArbiter {
    uint256 amount = getFundedBalance(); 
    (bool success, )  = payable(beneficiary).call{value: amount }(""); 
    if(!success){
      revert transactionFailed(); 
    }
    emit  Approve(msg.sender, balance[depositor]); 
  }
  
  function getFundedBalance () public view returns (uint256){
    return balance[depositor]; 
  }
  function getDepositor() external view returns (address){
    return depositor; 
  }
  function getArbiter() external view returns (address){
    return arbiter; 
  }
  function getBeneficiary() external view returns (address){
    return beneficiary; 
  }

}
