// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./TokenPriceFetcher.sol";
import "../base/AppDeployerBase.sol";

contract TokenPriceFetcherDeployer is AppDeployerBase {
    bytes32 public tokenPriceFetcher = _createContractId("TokenPriceFetcher");

    constructor(
        address addressResolver_,
        FeesData memory feesData_
    ) AppDeployerBase(addressResolver_) {
        creationCodeWithArgs[tokenPriceFetcher] = type(TokenPriceFetcher)
            .creationCode;
        _setFeesData(feesData_);
    }

    function deployContracts(uint32 chainSlug) external async {
        _deploy(tokenPriceFetcher, chainSlug);
    }

    function initialize(uint32 chainSlug) public override async {}

    function setFees(FeesData memory feesData_) public {
        feesData = feesData_;
    }
}
