// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Kocak is Ownable {
    address public token;
    uint256 public target;

    event Withdraw(address indexed recipient, uint256 amount);

    constructor(address _owner, address _token, uint256 _target) {
        token = _token;
        target = _target;
        _transferOwnership(_owner);
    }

    function balance() public view returns (uint256 result) {
        bytes memory data = abi.encodeWithSignature(
            "balanceOf(address)",
            address(this)
        );
        (bool success, bytes memory output) = token.staticcall(data);
        require(success, "External call failed");
        result = abi.decode(output, (uint256));
    }

    function renounceOwnership() public pure override {
        revert("Sebaiknya jangan gegabah");
    }

    function transfer(
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        bytes memory data = abi.encodeWithSignature(
            "transfer(address,uint256)",
            recipient,
            amount
        );
        (bool success, ) = token.call(data);
        require(success, "External call failed");
        return success;
    }

    function withdraw() external returns (bool) {
        address recipient = owner();
        uint256 amount = balance();
        require(amount >= target, "Target not reached");
        transfer(recipient, amount);

        emit Withdraw(recipient, amount);
        return true;
    }
}
