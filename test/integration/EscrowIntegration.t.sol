//SPDX-License-Identifer: MIT
pragma solidity 0.8.20; 
import {Test, console} from "forge-std/Test.sol"; 
import {DeployEscrow} from "../../script/DeployEscrow.s.sol"; 
import {Escrow} from "../../src/Escrow.sol"; 
contract EscrowIntegration is Test {
  DeployEscrow deployEscrow; 
  address public depositor; 
  address public beneficiary; 
  address public arbiter; 
  Escrow escrow; 
  function setUp() external {
    escrow = new Escrow(); 
    depositor  = makeAddr("depositor"); 
    beneficiary = makeAddr("beneficiary"); 
  }
  function testDepositorCanDepositBeneficiaryCanRecieveFundsAndArbiterCanApprove() external {
    vm.deal(depositor, 100 ether); 
    vm.startPrank(depositor); 
    escrow.makeAgreement(beneficiary,arbiter); 
    escrow.fund{value: 80 ether}(); 
    uint256 amount = escrow.getFundedBalance(depositor); 
    assertEq(amount, 80 ether); 
    vm.expectRevert(); 
    escrow.approve(); 
    assertEq(beneficiary.balance, 0); 
    vm.stopPrank(); 
    vm.startPrank(arbiter); 
    escrow.approve(); 
    assertEq(beneficiary.balance, 80 ether); 
    vm.stopPrank(); 
  }
}
