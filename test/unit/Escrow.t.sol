// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../../src/Escrow.sol"; 

contract EscrowTest is Test {
    Escrow escrow;
    address public owner = makeAddr("owner");
    address public depositor = makeAddr("depositor");
    address public arbiter1 = makeAddr("arbiter1");
    address public arbiter2 = makeAddr("arbiter2");
    address public beneficiary1 = makeAddr("beneficiary1");
    address public beneficiary2 = makeAddr("beneficiary2");

    function setUp() external {
        vm.startPrank(owner);
        escrow = new Escrow();
        vm.stopPrank();
    }
    function testMakeAgreement() external {
    vm.startPrank(depositor);
    escrow.makeAgreement(beneficiary1, arbiter1,0);
    escrow.makeAgreement(beneficiary2, arbiter2, 0);
    vm.stopPrank();

    Escrow.PartiesInvolved[] memory agreements = escrow.getAgreements(depositor);

    assertEq(agreements.length, 2);
    assertEq(agreements[0].arbiter, arbiter1);
    assertEq(agreements[0].beneficiary, beneficiary1);
    assertEq(agreements[1].arbiter, arbiter2);
    assertEq(agreements[1].beneficiary, beneficiary2);
}
 
    function testFund() external {
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        escrow.makeAgreement(beneficiary1, arbiter1, 50 ether);
        escrow.fund{value: 50 ether}(0, depositor);
        vm.stopPrank();
        assertEq(escrow.getFundedBalance(depositor), 50 ether);
        assertEq(address(escrow).balance, 50 ether);
    }

    function testApprove() external {
        address _depositor = makeAddr("depositor"); 
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        address _beneficiary = makeAddr("beneficiary"); 
        address _arbiter = makeAddr("arbiter"); 
        escrow.makeAgreement(_beneficiary, _arbiter,50 ether);
        Escrow.PartiesInvolved[] memory agreement = escrow.getAgreements(_depositor); 
        escrow.fund{value: 50 ether}(0, depositor);
        vm.stopPrank();
        vm.startPrank(_arbiter);
        escrow.approve(0, depositor);
        vm.stopPrank(); 
        assertEq(address(_beneficiary).balance, 50 ether);
    }

    function testRefund() external {
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        escrow.makeAgreement(beneficiary1, arbiter1, 50 ether);
        escrow.fund{value: 50 ether}(0, depositor);
        vm.stopPrank();

        vm.prank(arbiter1);
        uint256 balanceBeforeRefund = address(depositor).balance; 
        escrow.refund(0, depositor);
        assertEq(address(depositor).balance - balanceBeforeRefund, 50 ether);
        assertEq(escrow.getFundedBalance(depositor), 0 ether);
    }

    function testResolveDispute() external {
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        escrow.makeAgreement(beneficiary1, arbiter1, 50 ether);
        escrow.fund{value: 50 ether}(0, depositor);
        vm.stopPrank();

        vm.startPrank(owner);
        escrow.resolveDispute();
        vm.stopPrank();

        assertEq(address(owner).balance, 50 ether);
        assertEq(address(escrow).balance, 0 ether);
    }

    function testOnlyOwnerCanResolveDispute() external {
        vm.prank(makeAddr("notOwner"));
        vm.expectRevert();
        escrow.resolveDispute();
    }

    function testApproveInvalidIndex() external {
        vm.startPrank(depositor);
        escrow.makeAgreement(beneficiary1, arbiter1, 0);
        vm.stopPrank();

        vm.prank(arbiter1);
        vm.expectRevert();
        escrow.approve(1, depositor); 
    }

    function testOnlyArbiterCanApprove() external {
        vm.startPrank(depositor);
        escrow.makeAgreement(beneficiary1, arbiter1, 0);
        vm.stopPrank();

        vm.prank(makeAddr("notArbiter"));
        vm.expectRevert(Escrow.onlyArbiterCanApprovePayment.selector);
        escrow.approve(0, depositor);
    }
}

