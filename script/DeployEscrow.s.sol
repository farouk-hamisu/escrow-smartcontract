//SPDX-License-Identifier:MIT
import {Script} from "forge-std/Script.sol"; 
import {Escrow} from "../src/Escrow.sol"; 
pragma solidity ^0.8.20; 
contract DeployEscrow is Script {
  function run() external{
    vm.startBroadcast(); 
       new Escrow(); 
    vm.stopBroadcast(); 

  }
}
