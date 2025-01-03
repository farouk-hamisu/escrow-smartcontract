# Escrow Smart Contract  

A secure and trustless three-party escrow system on Ethereum. It ensures funds are safely held and only released when agreed upon by the involved parties: **buyer**, **seller**, and **arbiter**.

## Features  
- Funds are locked in the contract during the transaction.  
- Release of funds requires approval from the **buyer** and **arbiter**.  
- Transparent and secure process for both parties.  
- Ideal for freelance payments, secure transactions, and marketplaces.  

## How It Works  
1. **Buyer** deposits funds into the escrow smart contract.  
2. **Arbiter** oversees the transaction to ensure fairness.  
3. **Buyer** and **arbiter** must approve the release of funds to the **seller**.  
4. Funds are released to the **seller**

## Tech Stack  
- **Solidity**: Smart contract language.  

## Smart Contract Details  
- **Payable Functions**:  
  - `fund`: Buyer deposits Ether into the contract.  
  - `approveRelease`: Arbiter approves the release of funds.  
  - `releaseFunds`: Transfers Ether to the seller when approved.  
- **Roles**:  
  - **Buyer**: Deposits funds.  
  - **Seller**: Receives funds upon approval.  
  - **Arbiter**: Mediates and approves the transaction.  

## Installation  

1. Clone the repository and setup with foundryup:  
   ```bash
   git clone https://github.com/your-username/escrow-smart-contract.git  
   cd escrow-smart-contract  

