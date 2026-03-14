# Escrow on Chain

> Trustless payments for the decentralized workforce.

![Solidity](https://img.shields.io/badge/Solidity-^0.8.7-1a7a4a?style=flat&logo=solidity)
![Network](https://img.shields.io/badge/Network-Sepolia_Testnet-3c3c3d?style=flat&logo=ethereum)
![Toolchain](https://img.shields.io/badge/Toolchain-Foundry-orange?style=flat)
![Frontend](https://img.shields.io/badge/Frontend-ethers.js-purple?style=flat)

---

## Overview

ChainEscrow is a decentralized escrow service built on Ethereum that enables trustless payment between two parties - a **sender** and a **receiver** - without any central intermediary. Funds are locked in a smart contract and can only be released by the sender's approval, or refunded by the receiver's consent.

The project targets freelancers, contractors, gig workers, and anyone exchanging value with counterparties they don't fully trust yet.

---

## The Problem It Solves

Traditional freelance and contractor payments suffer from a fundamental trust gap:

- Clients are reluctant to pay before work is delivered.
- Freelancers fear delivering work without payment guarantees.
- Centralized platforms act as intermediaries but charge fees, can freeze funds, and introduce bias in disputes.

ChainEscrow eliminates the middleman. Once a sender locks funds into the contract, they are held on-chain and cannot be moved unilaterally. The rules are enforced by code, not a company.

---

## How It Works

1. **Sender** locks ETH into the contract, specifying the receiver's address.
2. Funds are held in escrow - status: `Pending`.
3. Once satisfied, the **sender** releases funds to the receiver.
4. Alternatively, the **receiver** can refund the sender at any time.
5. Status updates on-chain (`Released` or `Refunded`) and is visible to both parties.

---

## Smart Contract

### `Escrow.sol`

Deployed on **Sepolia Testnet**.

| Function | Description |
|---|---|
| `createEscrow(address receiver)` | Locks `msg.value` in a new escrow. Requires > 50,000 wei. |
| `releaseEscrow(address receiver, uint256 id)` | Sender releases funds to receiver. Validates both parties. |
| `refundEscrow(address sender, uint256 id)` | Receiver voluntarily returns funds to sender. |
| `showAll()` | Returns all escrows where caller is sender or receiver. |

### Status Codes

| Value | Meaning |
|---|---|
| `0` | Pending - funds are locked |
| `1` | Released - funds sent to receiver |
| `-1` | Refunded - funds returned to sender |

---

## Project Structure

```
escrow-on-chain/
├── src/
│   └── Escrow.sol           # Core escrow smart contract
├── script/
│   └── deploy.s.sol         # Foundry deployment script
└── frontend/
    └── index.html           # Web UI (vanilla JS + ethers.js)
```

---

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/) - smart contract toolchain
- [MetaMask](https://metamask.io/) - browser wallet
- Sepolia ETH - from a faucet (e.g., [sepoliafaucet.com](https://sepoliafaucet.com))

### Deploy the Contract

```bash
# Clone the repo
git clone https://github.com/sahil-deo/escrow-on-chain
cd escrow-on-chain

# Deploy to Sepolia
forge script script/deploy.s.sol \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

### Run the Frontend

Do not Open `index.html` directly in a browser, as metamask requires a HTTP/HTTPS address to work. 

Serve it locally via npx or python.

```bash
npx serve .
```

Update the `contractAddress` variable in `index.html` with your deployed contract address.

---

## Technologies Used

| Layer | Technology |
|---|---|
| Smart Contract | Solidity ^0.8.7 |
| Blockchain | Ethereum - Sepolia Testnet |
| Toolchain | Foundry (forge, cast, anvil) |
| Frontend | HTML / CSS / Vanilla JavaScript |
| Web3 Library | ethers.js v5 |
| Wallet | MetaMask |

---

## Future Improvements

- Decentralized arbitration via a configurable third-party arbitrator address
- Multi-token support (ERC-20 escrows, not just ETH)
- Time-locked escrows with automatic refund on deadline

---

## License

MIT License - see [LICENSE](./LICENSE) for details.

---

*Built for hackathon submission. Deployed on Ethereum Sepolia Testnet.*