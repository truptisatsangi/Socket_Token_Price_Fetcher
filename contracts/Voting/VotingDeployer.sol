// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Voting.sol";
import "../base/AppDeployerBase.sol";

contract CounterDeployer is AppDeployerBase {
    bytes32 public voting = _createContractId("Voting");

    constructor(
        address addressResolver_,
        FeesData memory feesData_
    ) AppDeployerBase(addressResolver_) {
        creationCodeWithArgs[voting] = type(Voting).creationCode;
        _setFeesData(feesData_);
    }

    function deployContracts(uint32 chainSlug) external async {
        _deploy(voting, chainSlug);
    }

    function initialize(uint32 chainSlug) public override async {}

    function setFees(FeesData memory feesData_) public {
        feesData = feesData_;
    }
}
