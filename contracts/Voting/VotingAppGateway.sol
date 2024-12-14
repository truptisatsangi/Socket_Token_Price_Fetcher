// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "../base/AppGatewayBase.sol";
import "./Voting.sol";
import "../interfaces/IForwarder.sol";

contract CounterAppGateway is AppGatewayBase {
    mapping(uint256 => mapping(uint32 => uint256)) public aggregatedVotes;

    constructor(
        address _addressResolver,
        address deployerContract_,
        FeesData memory feesData_
    ) AppGatewayBase(_addressResolver) {
        addressResolver.setContractsToGateways(deployerContract_);
        _setFeesData(feesData_);
    }

    function fetchVotes(address forwarder, uint256 proposalId) public async {
        _readCallOn();

        Voting(forwarder).votes(proposalId);
        IPromise(forwarder).then(
            this.fetchVotesCallback.selector,
            abi.encode(forwarder, proposalId)
        );

        _readCallOff();
    }

    function fetchVotesCallback(
        bytes calldata data,
        bytes calldata returnData
    ) external onlyPromises {
        (address forwarder, uint256 proposalId) = abi.decode(
            data,
            (address, uint256)
        );
        uint32 chainId = IForwarder(forwarder).getChainSlug();
        uint256 votes = abi.decode(returnData, (uint256));
        aggregatedVotes[proposalId][chainId] += votes;
    }

    function castVote(
        address[] memory instances,
        uint256 proposalId,
        bool votes
    ) public async {
        for (uint256 i; i < instances.length; i++) {
            Voting(instances[i]).vote(votes, proposalId);
        }
    }
}
