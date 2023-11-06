// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Betting is Ownable {

    enum Team { None, A, B }
    
    address[] public bettors;
    
    struct Bet {
        Team team;
        uint256 amount;
    }
    
    constructor() Ownable(msg.sender) {}
    uint256 public totalBetsA = 0;
    uint256 public totalBetsB = 0;
    mapping(address => Bet) public bets;
    Team public winningTeam = Team.None;

    modifier bettingOpen() {
        require(winningTeam == Team.None, "Betting is over.");
        _;
    }

    function placeBet(Team _team) external payable bettingOpen {
        require(bets[msg.sender].amount == 0, "You have already placed a bet.");
        require(_team == Team.A || _team == Team.B, "Invalid team selected.");

        bets[msg.sender] = Bet({
            team: _team,
            amount: msg.value
        });

        // Add the bettor to the bettors array
        bettors.push(msg.sender);
        if (_team == Team.A) {
            totalBetsA = totalBetsA + msg.value;
        } else {
            totalBetsB = totalBetsB + msg.value;
        }
    }

    // This function can be replaced by an Oracle callback in the future.
    function setWinner(Team _winningTeam) external onlyOwner {
        require(winningTeam == Team.None, "Winner already set.");
        winningTeam = _winningTeam;

        if (winningTeam == Team.A) {
            payout(Team.A, totalBetsA, totalBetsB);
        } else {
            payout(Team.B, totalBetsB, totalBetsA);
        }
    }
    function payout(Team _winningTeam, uint winningPool, uint losingPool) private {
        uint houseCut = (winningPool * 5) / 100;
        uint payoutPool = winningPool + losingPool - houseCut;
        uint individualPayout = payoutPool / winningPool;

        for (uint i = 0; i < bettors.length; i++) {
            address bettor = bettors[i];
            if (bets[bettor].amount != 0 && bets[bettor].team == _winningTeam) {
                payable(bettor).transfer(bets[bettor].amount * individualPayout);
                bets[bettor].amount = 0; // Reset the bet amount after payout
            }
        }

        // Reset bettors for the next round
        delete bettors;
    }

}
