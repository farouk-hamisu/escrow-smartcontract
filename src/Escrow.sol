//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 
contract Escrow {
  address public depositor;  
  address public arbiter; 
  address public beneficiary; 
  mapping(address=>uint256) balance; 
  struct PartiesInvolved {
    address arbiter; 
    address beneficiary; 
  }
  mapping(address => PartiesInvolved) public agreement; 
  mapping(address => address) arbiterToDepositor; 
  mapping(address => address) beneficiaryToDepositor; 
  error onlyArbiterCanApprovePayment(); 
  error transactionFailed(); 
  error onlyDepositorCanFundTheContract(); 
  event Deposit(address indexed _depositor, uint256 _amount); 
  event Agreement(address indexed _depositor, address indexed _beneficiary, address indexed _arbiter); 
  event Approve(address indexed _arbiter, uint256 _amount); 
  modifier onlyArbiter(){
    if(arbiterToDepositor[msg.sender]==address(0)){
      revert onlyArbiterCanApprovePayment(); 
    }
    _; 
  }
  modifier onlyDepositor() {
    if(isDefaultParties(agreement[msg.sender])){
      revert onlyDepositorCanFundTheContract(); 
    }
    _; 
  }
  function fund() external payable onlyDepositor {
    balance[msg.sender] = msg.value; 
    emit Deposit(msg.sender, msg.value); 
  }
  function makeAgreement(address _beneficiary, address _arbiter) external {
    agreement[msg.sender] = PartiesInvolved(_arbiter, _beneficiary); 
    arbiterToDepositor[_arbiter] = msg.sender; 
    beneficiaryToDepositor[_beneficiary] = msg.sender; 
    emit Agreement (msg.sender, _beneficiary, _arbiter); 
  }
  function approve() external onlyArbiter {
    address _depositor = arbiterToDepositor[msg.sender]; 
    uint256 amount = getFundedBalance(_depositor); 
    address _beneficiary = agreement[_depositor].beneficiary; 
    (bool success, )  = payable(_beneficiary).call{value: amount }(""); 
    if(!success){
      revert transactionFailed(); 
    }
    emit  Approve(msg.sender, balance[_depositor]); 
  } 
  //getters
  function getFundedBalance (address _depositor) public view returns (uint256){
    return balance[_depositor]; 
  }
  function isDefaultParties (PartiesInvolved memory parties) public pure returns (bool) {
    return parties.beneficiary == address(0) && parties.arbiter == address(0); 
  }
  

}
