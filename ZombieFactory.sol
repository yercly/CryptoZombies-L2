pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
 
 // In Lesson 1 we looked at structs and arrays. Mappings are another way of storing organized data in Solidity.
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

//Internal and External. In addition to public and private, Solidity has two more types of visibility for functions: internal and external.
//internal is the same as private, except that it's also accessible to contracts that inherit from this contract. (Hey, that sounds like what we want here!).
//external is similar to public, except that these functions can ONLY be called outside the contract — they can't be called by other functions inside that contract. 
//We'll talk about why you might want to use external vs public later.
    function _createZombie(string memory _name, uint _dna) internal {

//use require to make sure this function only gets executed one time per user, when they create their first zombie.
 //check to make sure ownerZombieCount[msg.sender] is equal to 0, and throw an error otherwise.
        require(ownerZombieCount[msg.sender] == 0);
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        
 //update our _createZombie method from lesson 1 to assign ownership of the zombie to whoever called the function.
 //msg.sender, which refers to the address of the person (or smart contract) who called the current function.
 //Note: In Solidity, function execution always needs to start with an external caller. A contract will just sit on the blockchain doing nothing until someone calls one of its functions. So there will always be a msg.sender.
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
