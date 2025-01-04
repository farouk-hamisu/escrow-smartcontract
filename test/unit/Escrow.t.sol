//SPDX-license-Identifier: MIT 
pragma solidity ^0.8.20; 
import {Test, console} from "forge-std/Test.sol"; 
import {Escrow} from "../../src/Escrow.sol"; 

contract EscrowTest is Test {
  Escrow escrow; 
  address public arbiter = makeAddr("user2"); 
  address public beneficiary = makeAddr("user3"); 
  function setUp() external {
    escrow = new Escrow(); 
    escrow.makeAgreement(beneficiary, arbiter); 
  }
  function testFund() external {
    vm.deal(address(this), 100 ether); 
    escrow.fund{value: 20 ether}(); 
    assertEq(escrow.getFundedBalance(address(this)), 20 ether); 
  }
  function testPrankFund() external {
    vm.deal(arbiter, 2 ether); 
    vm.prank(arbiter); 
    vm.expectRevert(); 
    escrow.fund{value:2 ether}(); 
  }
  function testApproveFunction() external {
    vm.deal(address(this), 5 ether); 
    escrow.fund{value: 3 ether}(); 
    vm.prank(arbiter); 
    escrow.approve(); 
    uint256 currentUserBalance = escrow.getFundedBalance(address(this)); 
    assertEq(currentUserBalance, 3 ether); 
  }
  function testPrankApproveFunction() external {
    address badPlayer = makeAddr("bad player"); 
    vm.deal(address(this), 6 ether); 
    escrow.fund{value: 6 ether}(); 
    vm.startPrank(badPlayer); 
    vm.expectRevert(); 
    escrow.approve(); 
    vm.stopPrank(); 
  }
  function testArbiter() external view {
    (address currentArbiter, ) = escrow.agreement(address(this)); 
    assertEq(arbiter, currentArbiter); 
  }
  function testBeneficiary() external view {
    (, address currentBeneficiary) = escrow.agreement(address(this)); 
    assertEq(beneficiary, currentBeneficiary); 
  }
}
