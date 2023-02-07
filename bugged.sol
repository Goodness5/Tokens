// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17; // COMPILER VERSION SPECIFIED

//Token Contracts

contract W3BVIII{
    address public owner;
    string private name;

    string private symbol;

    uint256 private decimal;

    uint private totalSupply;
    mapping (address => uint256) private balanceOf;
    // owner => spender =>  amount
    mapping (address =>mapping(address => uint)) public allowance;

    event transfer_(address indexed from, address to, uint amount);
    event _mint(address indexed from, address to, uint amount);

    // SAVES THE OWNER ADDRESS, TOKEN NAME, DECIMAL AND SYMBOL TO THE BYTECODE  
    constructor(string memory _name, string memory _symbol){
        owner = msg.sender;

        name = _name;
        symbol = _symbol;
        decimal = 1e18;

    }
    //A GETTER FUNCTION FOR  THE TOKEN ATTRIBUTES { NAME, SYMBOL, TOTAL SUPPLY AND DECIMAL}
    function name_() public view returns(string memory){
        return name;
    }

    function symbol_() public view returns(string memory){
        return symbol;
    }

    function _decimal() public view returns(uint256){
        return decimal;
    }


    function _totalSupply() public view returns(uint256){
        return totalSupply;
    }

    // GETS THE BALANCE TOKEN OF EACH TOKEN HOLDER
    function _balanceOf(address who) public view returns(uint256){
        return balanceOf[who];
    }


    // ALLOWS TOKEN HOLDERS TO TRANSFER THEIR TOKENS TO OTHERS
    function transfer(address _to, uint amount)public {
        _transfer(msg.sender, _to, amount);
        emit transfer_(msg.sender, _to, amount);

    }

    // KEEP TRACK OF STATE CHANGES AFTER EVERY TRANSACTION
    function _transfer(address from, address to, uint amount) internal {
        require(balanceOf[from] >= amount, "insufficient fund");
        require(to != address(0), "transferr to address(0)");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }

    //  CHECK IF THIRD PARTY HAS BEEN APPROVED TO USE HOLDERS TOKENS
    function _allowance(address _owner, address spender) public view returns(uint amount){
    amount = allowance[_owner][spender];
    }

    // ALLOW THIRD PARTIES TO INITIATE TOKEN TRANSFER IF APPROVED
    function transferFrom(address from, address to, uint amount) public returns(bool success){
        uint value = _allowance(from, msg.sender);
        require( amount <= value, "insufficient allowance");
        allowance[from][to] -= amount;
        _transfer(from, msg.sender, amount);
        success =true;

        emit transfer_(from, to, amount);


     //  ALLOW TOKEN HOLDERS TO APPROVE THIRD PARTIES TO SPEND THEIR TOKENS
    }
    function Approve(address spender, uint amount) public  {
        allowance[msg.sender][spender] = amount;


    }

    // MINT/PRODUCTION NEW TOKENS ONLY BY OWNER 
    function mint(address to, uint amount) public {
        require(msg.sender == owner, "Access Denied");
        require(to != address(0), "transferr to address(0)");
        totalSupply += amount;
        balanceOf[to] += amount * _decimal();
        emit _mint(address(0), to, amount);


    }

    // DESTROY/BURN TOKENS BY ANY TOKEN HOLDER BURNING 90% AND SENDS 10% TO THE TOKEN OWNER
    function burn(uint256 _value) public returns (bool burnt) {
            require(balanceOf[msg.sender] >= _value, "insufficient balance");
            uint256 burning  = _value * decimal;
            uint256 sendtoowner = ((burning * 10)/100);
            uint256 amounttoburn = _value - sendtoowner;
            totalSupply -= amounttoburn;
            _transfer(msg.sender, owner, sendtoowner);
            burntozero(address(0), amounttoburn);


            burnt = true;
        }


    // SEND BURNT TOKENS TO THE ZERO ADDRESS
    function burntozero(address to, uint amount) internal {

            to = address(0);
        balanceOf[to] += amount;
    }  

}