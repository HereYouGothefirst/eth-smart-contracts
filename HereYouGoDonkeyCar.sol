pragma solidity ^0.4.18;

We made prototype splitting ownership of small RC robotics car between 5 people.
contract HereYouGoDonkeyCar {
  
  address public carSigner;
  uint public carValue;
  bytes32 public licensePlate;
  address[] public owners;
  uint constant MAX_OWNERS = 5;

  mapping (address => uint) public ownersBalance;
  uint public balanceToDistribute;

  uint constant INITIAL_CAR_SHARES = 100;
  mapping (address => uint) public carShares;

  bool carIsReady = false;

  modifier onlyIfReady {
        require(carIsReady);
        _;
    }

	
  constructor(bytes32 _licensePlate, uint _carValue) public {
    require(_licensePlate.length >0 && _carValue > 0);
    carSigner = msg.sender;
    carValue = _carValue;
    licensePlate = _licensePlate;
    carShares[address(this)] = INITIAL_CAR_SHARES;
  }


  function setOwners(address[] _owners) public {
    require(msg.sender == carSigner);
    require(_owners.length > 0 && _owners.length <= MAX_OWNERS);

    require(owners.length == 0);
    owners = _owners;

    uint sharesToDistribute = carShares[address(this)]/owners.length;

    for (uint8 i; i<owners.length;i++){
      carShares[owners[i]] = sharesToDistribute;
      carShares[address(this)] -= sharesToDistribute;
    }

    carIsReady = true;
  }
}