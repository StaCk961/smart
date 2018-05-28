pragma solidity ^0.4.18;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
	struct Device {
        	int id;
        	address addr;
    	}

	mapping (address => uint) balances;
	mapping (uint => Device) devices;
	uint[] deviceIds;
	address owner; 

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Enable(uint deviceId, uint duration);


	function MetaCoin() public {
		balances[tx.origin] = 100000000;
		owner = msg.sender;
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}

	function registerDevice(address addr, uint deviceId) public {
		var device = devices[deviceId];
	       	device.addr = addr;        
        	deviceIds.push(deviceId) -1;
	}

	function enableDevice(uint deviceId, uint amount) public returns (bool) {
		var device = devices[deviceId];
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[device.addr] += amount;
		Enable(deviceId, amount*5);
		return true;
	}

	function getDevices() view public returns(uint[]) {
        	return deviceIds;
    	}

	function countDevices() view public returns (uint) {
        	return deviceIds.length;
    	}

	function getOwner() view public returns (address) {
        	return owner;
    	}
	
	function getSenderAddress() view public returns (address) {
        	return msg.sender;
    	}
}
