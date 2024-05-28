// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interface/IERC20.sol";

contract ERC20Token {
    // state variables
    string tokenName;
    string symbol;
    uint256 decimals;
    address public owner;
    uint256 totalSupplys;

    mapping(address => uint) balances; // mapping the address of the owner to get the balances of the owner
    mapping(address => mapping(address => uint256)) allowed;

    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint tokens
    );

    event Transfer(address indexed from, address indexed to, uint tokens);

    constructor() {
        tokenName = "MyERC20Token";
        totalSupplys = 1000000000000000;
        symbol = "METEK";
        decimals = 18;
        owner = msg.sender;
        balances[msg.sender] += totalSupplys;
    }

    function transfer(address _to, uint _token) public returns (bool) {
        // chacking if the Address provided by the receiver is correct
        require(msg.sender != address(0), "This Address is not a vaild");

        // checking if the balances of the sender is equal or greater than the totalToken
        require(balances[msg.sender] >= _token, "You dont have alot of Token");

        // calculating the 10 % when ever we make a transfar
        uint256 _fee = (_token * 10) / 100;

        // Removing the token that wes withdorw form the sender accunts
        balances[owner] -= _fee;

        // adding the wiithdorw to the 10 %
        uint256 afterDeduction = _token - _fee;

        // removing the token from the User Accunt
        balances[msg.sender] = balances[msg.sender] - _token;

        // adding the token to the receiver accunt and updating the balances
        balances[_to] = balances[_to] + afterDeduction;

        // send a soccess message to the user when all that wes needed is aproved
        emit Transfer(msg.sender, _to, _token);

        // send a soccess messge to the userr when all that wes needed is aproved
        emit Transfer(msg.sender, owner, _fee);

        return true;
    }

    function approve(address spender, uint tokens) private returns (bool) {
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function allowance(
        address tokenOwner,
        address spender
    ) private view returns (uint) {
        return allowed[tokenOwner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint _tokens
    ) private returns (bool) {
        // chacking if the Address provided by the receiver is correct
        require(msg.sender != address(0), "this address is in Valid");

        // checking if the balances of the sender is equal or greater than the totalToken
        require(balances[from] >= _tokens, "You dont have alot of Token");

        require(
            allowed[from][msg.sender] >= _tokens,
            "You dont have alot of token"
        );

        balances[from] = balances[from] - _tokens;

        allowed[from][msg.sender] = allowed[from][msg.sender] - _tokens;

        balances[to] = balances[to] + _tokens;

        emit Transfer(from, to, _tokens);

        return true;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function totalSupply() public view returns (uint256) {
        return totalSupplys;
    }
}
