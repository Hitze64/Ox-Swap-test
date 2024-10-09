// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SwapContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Deposit tokens to this contract
    function depositToken(address tokenAddress, uint256 amount) external {
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }

    // Withdraw tokens from this contract
    function withdrawToken(address tokenAddress, uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }

    // Perform the swap
    function executeSwap(
        address tokenIn,
        address tokenOut,
        address to,
        uint256 amountIn,
        uint256 amountOutMin
    ) external returns (bool success) {
        IERC20 inputToken = IERC20(tokenIn);
        IERC20 outputToken = IERC20(tokenOut);

        // Ensure the contract has enough of the input token
        require(inputToken.balanceOf(address(this)) >= amountIn, "Insufficient input token balance");
        
        // Approve the output token to be transferred
        require(inputToken.approve(to, amountIn), "Approval failed");

        // Simulate the swap logic here (this is where you'd integrate with an external API or DEX)
        // Normally, the actual swap call would go here.
        // For now, we'll assume success.
        
        // Verify that the output amount is sufficient
        uint256 outputBalance = outputToken.balanceOf(address(this));
        require(outputBalance >= amountOutMin, "Insufficient output token received");

        // Transfer the output tokens to the recipient
        require(outputToken.transfer(to, outputBalance), "Output token transfer failed");

        return true; // Swap success
    }

    // Function to check balance
    function checkBalance(address tokenAddress) external view returns (uint256) {
        IERC20 token = IERC20(tokenAddress);
        return token.balanceOf(address(this));
    }
}

