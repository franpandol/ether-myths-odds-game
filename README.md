# Betting Smart Contract

This Ethereum smart contract is designed for a simple betting application where participants can place bets on one of two teams, Team A or Team B. The contract is built with Solidity and leverages OpenZeppelin's `Ownable` contract for access control, ensuring only the contract owner can determine the winning team.

## Features

- **Place Bet**: Users can place bets on either Team A or Team B.
- **Set Winner**: The contract owner can set the winning team.
- **Automatic Payouts**: Upon deciding the winning team, bets are automatically paid out to the winners.

## How It Works

1. **Initialization**: The contract is deployed by the owner.
2. **Place Bets**: Bettors can place their bets on a team by sending ETH to the `placeBet` function.
3. **Close Betting**: The owner sets the winning team using the `setWinner` function.
4. **Payout**: The contract calculates the payouts and transfers the winnings to the bettors who bet on the winning team.

## Contract Rules

- A bettor can place a bet only once per round.
- Bets can only be placed when betting is open, i.e., before a winning team is set.
- Bets are placed in ETH.
- A 5% house cut is taken from the total bets on the winning team.

## Getting Started

To interact with this contract:

1. Deploy the contract to an Ethereum network.
2. Call `placeBet` with the selected team and a value of ETH you wish to bet.
3. After the betting period is over, the contract owner will call `setWinner` to distribute the payouts.

## Functions

### placeBet

```solidity
function placeBet(Team _team) external payable
