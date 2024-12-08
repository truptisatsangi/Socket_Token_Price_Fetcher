// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IUniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

contract TokenPriceFetcher {
    address public admin;
    address public uniswapV2FactoryAddress;
    address public ethAddress;
    mapping(uint256 => uint256) public gasPrices; // Chain ID to Gas Price

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    // Set the UniswapV2Factory address (mainnet: 0x5C69bEe701ef814a2B6a3EDD4B6B2Ff7f2C76A2f)
    constructor(address _uniswapV2FactoryAddress, address _ethAddress) {
        admin = msg.sender;
        uniswapV2FactoryAddress = _uniswapV2FactoryAddress;
        ethAddress = _ethAddress;
    }

    // Fetch price of TokenA in terms of TokenB/ETH
    function getPrice(
        address tokenA,
        address tokenB
    ) internal view returns (uint256 price) {
        address pairAddress = IUniswapV2Factory(uniswapV2FactoryAddress)
            .getPair(tokenA, tokenB);
        require(pairAddress != address(0), "Pair doesn't exist");

        (uint112 reserve0, uint112 reserve1, ) = IUniswapV2Pair(pairAddress)
            .getReserves();

        // Assuming tokenA is reserve0 and tokenB is reserve1, you can adjust depending on the pair
        price = (reserve0 * 1e18) / reserve1; // Price of TokenA in terms of TokenB, with 18 decimals
    }

    function getTokenPrice(
        address token
    ) external view returns (uint256 price) {
        require(token != address(0), "Invalid token");
        price = getPrice(token, ethAddress);
    }

    // Function to update gas price for a specific chain
    function getCurrentGasPrice() public view returns (uint256) {
        return tx.gasprice; // Returns the gas price in wei
    }

    // Can be called once person wants to buy the tokens after knowing the price
    function buyToken() public payable {
        // gets an approval externally
        // but tokens to msg.sender from any chain
    }
}
