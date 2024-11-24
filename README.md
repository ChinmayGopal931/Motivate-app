
# Motiv8 🚀

A blockchain-based commitment device that helps you achieve your goals through financial motivation. Create promises, stake MATIC, and get things done - or lose your stake.

## Overview

Motivate is a decentralized application (dApp) that leverages the power of financial incentives to help users complete their tasks and achieve their goals. By staking MATIC tokens against your promises and having a friend verify completion, you create a powerful motivation system backed by smart contracts.

### How It Works

1. Create a promise with:
   - Task description
   - Deadline
   - Stake amount in MATIC
   - Friend's wallet address (verifier)

2. Complete your task before the deadline
   - Your friend verifies completion
   - Get your staked MATIC back

3. Miss your deadline
   - Contract owner claims your stake
   - Use the loss as motivation for next time!

## Features

- Create verifiable promises backed by MATIC tokens
- Friend-based verification system
- Automatic stake return upon completion
- Transparent smart contract execution
- Full integration with Polygon (MATIC) network
- 1% platform fee on promise creation

## Smart Contract

- **Network**: Polygon (MATIC)
- **Address**: `0x8E96E9B6bCB3DA7e7459f3115B4D4Ca364050429`
- **Solidity Version**: 0.8.4

## Technical Stack

- **Frontend**: ReactJS, Chakra UI
- **Blockchain Integration**: Web3.js
- **Development**: Truffle
- **Network**: Polygon (MATIC)

## Prerequisites

- Chrome or Firefox browser
- MetaMask wallet extension
- MATIC tokens for staking

## Local Development

1. Clone the repository:
```bash
git clone https://github.com/ChinmayGopal931/Motivate.git
cd Motivate
```

2. Install dependencies:
```bash
npm install
```

3. Start local development server:
```bash
npm start
```

## Smart Contract Deployment

1. Configure Truffle with your network details
2. Deploy contracts:
```bash
truffle migrate --network polygon
```

## Security

- Smart contract code is open source and verifiable
- Funds can only be claimed by the owner after deadline expiration
- Users can interact directly with the smart contract through blockchain explorers
- Contract has been deployed to Polygon mainnet for reliability

## FAQs

**Q: Is it safe?**  
A: The smart contract code is public and verifiable. Contract owner cannot access funds before deadlines.

**Q: What if the frontend goes down?**  
A: You can always interact with the smart contract directly through blockchain explorers.

**Q: Why Polygon (MATIC)?**  
A: Polygon offers low transaction fees and is backed by a $10B+ market cap with over 1.2M active wallets.

**Q: Can deadlines be modified?**  
A: No, deadlines are immutable once set - that's the point!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## Acknowledgments

- Built on Polygon Network
- Inspired by behavioral economics and commitment devices
- Special thanks to the Web3 community

---

*Disclaimer: This is a financial commitment tool. Please stake responsibly and only what you can afford to lose.*# Motivate-app
# Motivate-app
