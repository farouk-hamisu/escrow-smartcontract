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

## How to Use

### Prerequisites

- Install [Foundry](https://getfoundry.sh/) for smart contract development.
- Have a supported Ethereum wallet (e.g., MetaMask).
- Access to an Ethereum testnet like Sepolia.

### Setup

1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd <repository_name>

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/DeployEscrow.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```
### Help
```shell
$ forge --help
$ anvil --help
$ cast --help
```

