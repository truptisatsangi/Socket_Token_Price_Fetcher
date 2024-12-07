// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract CrossChainOptimizer {
//     address public admin;
//     uint256 public fee; // e.g., 0.5% = 50 basis points
//     address public router; // DEX Router

//     event TokensSwapped(address user, uint256 amountIn, uint256 amountOut, address tokenIn, address tokenOut);

//     modifier onlyAdmin() {
//         require(msg.sender == admin, "Not admin");
//         _;
//     }

//     constructor(address _router, uint256 _fee) {
//         admin = msg.sender;
//         router = _router;
//         fee = _fee;
//     }

//     function setFee(uint256 _fee) external onlyAdmin {
//         require(_fee <= 10000, "Fee too high");
//         fee = _fee;
//     }

//     function swapTokens(
//         address tokenIn,
//         address tokenOut,
//         uint256 amountIn,
//         address to
//     ) external {
//         uint256 feeAmount = (amountIn * fee) / 10000;
//         uint256 amountAfterFee = amountIn - feeAmount;

//         IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
//         IERC20(tokenIn).approve(router, amountAfterFee);

//         address;
//         path[0] = tokenIn;
//         path[1] = tokenOut;

//         IUniswapV2Router02(router).swapExactTokensForTokens(
//             amountAfterFee,
//             0, // accept any amount
//             path,
//             to,
//             block.timestamp
//         );

//         emit TokensSwapped(msg.sender, amountIn, amountAfterFee, tokenIn, tokenOut);
//     }
// }
