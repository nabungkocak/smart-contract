// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Kocak.sol";

contract KocakFactory is Ownable {
    event NewContract(
        address indexed deployer,
        address newContract,
        address token,
        uint256 target
    );

    uint256 public fee;

    constructor(address _owner, uint256 _fee) {
        fee = _fee;
        _transferOwnership(_owner);
    }

    function renounceOwnership() public pure override {
        revert("Ngaco lo");
    }

    function changeFee(uint256 newFee) external onlyOwner {
        fee = newFee;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function create(
        address token,
        uint256 target
    ) external payable returns (bool) {
        require(msg.value == fee);
        address newContract = address(new Kocak(msg.sender, token, target));
        emit NewContract(msg.sender, newContract, token, target);
        return true;
    }
}
