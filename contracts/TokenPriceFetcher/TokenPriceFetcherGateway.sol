// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "../base/AppGatewayBase.sol";
import "./TokenPriceFetcher.sol";
import "../interfaces/IForwarder.sol";

contract TokenPriceFetcherGateway is AppGatewayBase {
    // price[tokenid][chainid] = <price>
    mapping(uint256 => mapping(uint32 => uint256)) public price;

    uint8 SUPPORTED_CHAINS = 3;

    constructor(
        address _addressResolver,
        address deployerContract_,
        FeesData memory feesData_
    ) AppGatewayBase(_addressResolver) {
        addressResolver.setContractsToGateways(deployerContract_);
        _setFeesData(feesData_);
    }

    // Function to fetch token price from a remote chain (via Socket Protocol or other mechanism)
    // This would be called off-chain and data is passed back via the callback
    function fetchPrice(
        address[] calldata forwarder,
        address[] calldata token,
        uint256 tokenId
    ) public async {
        _readCallOn();

        // Get price from the forwarder contract (Uniswap pair on remote chain)
        for (uint256 i; i < forwarder.length; i++) {
            TokenPriceFetcher(forwarder[i]).getTokenPrice(token[i]);
            // Emit the promise and fetch the price on the remote chain
            IPromise(forwarder[i]).then(
                this.fetchPriceCallback.selector,
                abi.encode(forwarder[i], token[i], tokenId)
            );
        }
        _readCallOff();
    }

    // Callback function to handle the price fetched from another chain
    function fetchPriceCallback(
        bytes calldata data,
        bytes calldata returnData
    ) external onlyPromises {
        (address forwarder, address token, uint256 tokenId) = abi.decode(
            data,
            (address, address, uint256)
        );

        // Decode the price from the returnData
        uint256 priceFetched = abi.decode(returnData, (uint256));

        // Store the price in the price mapping (tokenId -> ChainId -> Price)
        price[tokenId][IForwarder(forwarder).getChainSlug()] = priceFetched;
    }

    // Function to aggregate token prices across multiple chains
    function getMinimumPrice(
        uint256 tokenId,
        uint8[] memory chainIds
    ) public async returns (uint256, uint256) {
        uint256 minPrice = type(uint256).max;
        uint256 minIndex;
        for (uint256 i; i < 3; i++) {
            if (price[tokenId][chainIds[i]] < minPrice) {
                minPrice = price[tokenId][chainIds[i]];
                minIndex = i;
            }
        }

        // Need to get the gas prices on all the chains and return minimum after this minPrice + current gasPrice on chain

        return (minPrice, minIndex);
    }
}
