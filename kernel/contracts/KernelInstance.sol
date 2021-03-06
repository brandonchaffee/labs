pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract KernelInstance is Ownable {
  string public name;
  string public version;
  address public developer;
  KernelInstance public parent;
  
  // Provides freezing behavior to prevent implementations defined in parent to be overwritten
  bool public frozen;
  
  // Mapping from a contract name to its implementation address
  mapping(string => address) private implementations;

  event ImplementationAdded(string contractName, address implementation);

  modifier notFrozen() {
    require(!frozen);
    _;
  }

  function KernelInstance(string _name, string _version, KernelInstance _parent) public {
    if(_parent != address(0)) { require(_parent.frozen()); }
    name = _name;
    version = _version;
    parent = _parent;
    developer = msg.sender;
  }

  function getHash() public view returns(bytes32) {
    return keccak256(name, version);
  }

  function addImplementation(string contractName, address implementation) onlyOwner notFrozen public {
    require(implementation != address(0));
    require(implementations[contractName] == address(0));
    implementations[contractName] = implementation;
    ImplementationAdded(contractName, implementation);
  }

  function getImplementation(string contractName) public view returns(address) {
    address implementation = implementations[contractName];
    if(implementation != address(0)) return implementation;
    else if(parent != address(0)) return parent.getImplementation(contractName); 
    else return 0;
  }

  function freeze() onlyOwner notFrozen public {
    frozen = true;
  }
}
