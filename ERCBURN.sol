// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract myERC20 is ERC20,Ownable 
{
    uint256 totalSupply_;
    address payable public Owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 public counter;
    ERC20 _token;

    constructor() ERC20("TeddyGold", "TGLD") 
    {
        //_mint(msg.sender, initialSupply);
        //_token = ERC20(_tokenAddress);
        uint256 total=500000000000000000000000;    
        _mint(msg.sender, total);
        totalSupply_ = total;
        balances[msg.sender] = total;
	    Owner = payable(msg.sender); 
    }


    function mintMinerReward() public {
        _mint(block.coinbase, 1);
    }


    function _mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    function _burn(uint256 tokenId) public{
        _burn(tokenId);
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