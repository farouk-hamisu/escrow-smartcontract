// SPDX-License-Identifer: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployEscrow} from "../../script/DeployEscrow.s.sol";
import {Escrow} from "../../src/Escrow.sol";

contract EscrowIntegration is Test {
    DeployEscrow deployEscrow;
    address public depositor;
    address public beneficiary;
    address public arbiter;
    uint256 agreementIndex = 0;
    Escrow escrow;

    function setUp() external {
        escrow = new Escrow();
        depositor = makeAddr("depositor");
        beneficiary = makeAddr("beneficiary");
        arbiter = makeAddr("arbiter");
    }
    function testDepositorCanDepositBeneficiaryCanReceiveFundsAndArbiterCanApprove() external {
    vm.deal(depositor, 100 ether);
    vm.startPrank(depositor);
    escrow.makeAgreement(beneficiary, arbiter, 80 ether);
    escrow.fund{value: 80 ether}(agreementIndex, depositor);
    vm.stopPrank();
    vm.startPrank(arbiter);
    escrow.approve(agreementIndex, depositor);
    assertEq(beneficiary.balance, 80 ether);
    vm.stopPrank();
  }
   }

