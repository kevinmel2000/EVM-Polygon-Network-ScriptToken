// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract myERC20 is ERC20,Ownable 
{
    uint256 totalSupply_;
    address payable public Owner;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 public counter;
    ERC20 _token;

    constructor(address _tokenAddress,uint256 initialSupply) ERC20("TeddyGold", "TGLD") 
    {
        //_mint(msg.sender, initialSupply);
        _token = ERC20(_tokenAddress);
        //uint256 total=5000;    
        _mint(msg.sender, initialSupply);
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
	    Owner = payable(msg.sender); 
    }


    function mintMinerReward() public {
        _mint(block.coinbase, 10);
    }


	//function deposit() public payable {}

    function deposit(uint _amount) public payable {
        // Set the minimum amount to 1 token (in this case I'm using LINK token)
        uint _minAmount = 1*(10**18);
        // Here we validate if sended USDT for example is higher than 50, and if so we increment the counter
        require(_amount >= _minAmount, "Amount less than minimum amount");
        // I call the function of IERC20 contract to transfer the token from the user (that he's interacting with the contract) to
        // the smart contract  
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        counter = counter + 1;
    }

    // This function allow you to see how many tokens have the smart contract 
    function getContractBalance() public onlyOwner view returns(uint){
        return IERC20(_token).balanceOf(address(this));
    }


    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract.
    function withdraw() public {
        // get the amount of Ether stored in this contract
        uint amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success, ) = Owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Function to transfer Ether from this contract to address from input
    function transferEther(address payable _to, uint _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
	

}