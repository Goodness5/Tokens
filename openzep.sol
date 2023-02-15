// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17; // COMPILER VERSION SPECIFIED

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract w3cvii is ERC20{
    address owner;
    // mapping(uint256 => uint256) tokenvalue;
    uint256 tokenvalue = 2 ether;


    constructor(string memory name, string memory symbol, address _owner) ERC20(name, symbol){
            owner = _owner;

    }

   function deductEther(uint256 amount) payable public {
    
        // amount = tokenvalue[msg.value];

        require(msg.sender.balance >= amount * tokenvalue, "Not enough funds");
        transfer(address(this), amount);
        _transfer(address(this), msg.sender, amount);
}

    function withdraw() external {
        require(owner == msg.sender);
       (bool success,) = payable(owner).call{value: (address(this).balance)}("");
       require(success, "transfer failed");

    }

    
    receive() external payable{}


    fallback() external payable{}

}