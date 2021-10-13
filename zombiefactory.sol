pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    //add an event for contract to communicate something happened to your app front end 
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //creating zombie struct with 2 properties
    struct Zombie {
        string name;
        uint dna;
    }

    //creating public zombies array composed of Zombie structs
    Zombie[] public zombies;

    //create mapping to store zombie ownership 
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    //create new Zombie and add it to the zombies array 
    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //update zombieToOwner mapping to store msg.sender under the id
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    //create helper function that generates a random 16 digit DNA number from a string 
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        //require statement to ensure a user can only execute once
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
