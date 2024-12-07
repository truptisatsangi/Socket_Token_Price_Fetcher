// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    uint256 public proposalId;
    address public admin;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => uint256) public votes; 
    bytes32[] public candidates;

    event VoteCast(address indexed voter, uint256 proposalId);
    event VotesSent(bytes32[] candidates, uint256[] voteCounts);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(bytes32[] memory _candidates) {
        admin = msg.sender;
        candidates = _candidates;
    }

    function vote(bool isSupport, uint256 proposalId_) external {
        require(!hasVoted[msg.sender], "Already voted");

        if (isSupport) {
            votes[proposalId_]++;
        }
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, proposalId_);
    }

    function aggregatedVotes() public view {
        
    }
}
