// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface MyERC20Token {
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns(bool success);
}

contract TokenITO {
    address owner;
    uint256 price;
    MyERC20Token myERC20Token;
    uint256 tokenSold;


    event Sold(address buyer, uint256 amount);

    constructor(uint256 _price, address _addressContractToken) {
        owner = msg.sender;
        price = _price;
        myERC20Token = MyERC20Token(_addressContractToken);
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }


    function buy(uint256 _numTokens) public payable {
        require(msg.value == mul(price, _numTokens));
        uint256 scaledAmount = mul(_numTokens, uint256(10) ** myERC20Token.decimals());
        require(myERC20Token.balanceOf(address(this)) >= scaledAmount); 
        tokenSold += _numTokens; 
        require(myERC20Token.transfer(msg.sender, scaledAmount)); 
        emit Sold(msg.sender, _numTokens);
    }


    function endSold() public {
        require(msg.sender == owner);
        require(myERC20Token.transfer(owner, myERC20Token.balanceOf(address(this)))); 
        payable(msg.sender).transfer(address(this).balance);
    }


}



    // function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    //     unchecked {
    //         if (a == 0) return (true, 0);
    //         uint256 c = a * b;
    //         if (c / a != b) return (false, 0);
    //         return (true, c);
    //     }
    // }