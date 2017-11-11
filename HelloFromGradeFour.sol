pragma solidity ^0.4.0;

// A darkmatteryyc.ca experiment - created using the Regis.nu tool by ConsenSys
// Messages from Grade 4 students to their future selves
// This is the base contract that your contract HelloFromGradeFour extends from.
contract BaseRegistry {

    // The owner of this registry.
    address public owner = msg.sender;

    uint public creationTime = now;

    // This struct keeps all data for a Record.
    struct Record {
        // Keeps the address of this record creator.
        address owner;
        // Keeps the time when this record was created.
        uint time;
        // Keeps the index of the keys array for fast lookup
        uint keysIndex;
        string message;
    }

    // This mapping keeps the records of this Registry.
    mapping(uint32 => Record) records;

    // Keeps the total numbers of records in this Registry.
    uint public numRecords;

    // Keeps a list of all keys to interate the records.
    uint32[] public keys;


    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    // This is the function that actually insert a record.
    function register(uint32 key, string message) onlyOwner {
        if (records[key].time == 0) {
            records[key].time = now;
            records[key].owner = msg.sender;
            records[key].keysIndex = keys.length;
            keys.length++;
            keys[keys.length - 1] = key;
            records[key].message = message;
            numRecords++;
        } else {
            throw;
        }
    }

    // Updates the values of the given record.
    function update(uint32 key, string message) {
        // Only the owner can update his record.
        if (records[key].owner == msg.sender) {
            records[key].message = message;
        }
    }

    // Unregister a given record
    function unregister(uint32 key) {
        if (records[key].owner == msg.sender) {
            uint keysIndex = records[key].keysIndex;
            delete records[key];
            numRecords--;
            keys[keysIndex] = keys[keys.length - 1];
            records[keys[keysIndex]].keysIndex = keysIndex;
            keys.length--;
        }
    }

    // Transfer ownership of a given record.
    function transfer(uint32 key, address newOwner) {
        if (records[key].owner == msg.sender) {
            records[key].owner = newOwner;
        } else {
            throw;
        }
    }

    // Tells whether a given key is registered.
    function isRegistered(uint32 key) returns(bool) {
        return records[key].time != 0;
    }

    function getRecordAtIndex(uint rindex) returns(uint32 key, address owner, uint time, string message) {
        Record record = records[keys[rindex]];
        key = keys[rindex];
        owner = record.owner;
        time = record.time;
        message = record.message;
    }

    function getRecord(uint32 key) returns(address owner, uint time, string message) {
        Record record = records[key];
        owner = record.owner;
        time = record.time;
        message = record.message;
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getOwner(uint32 key) returns(address) {
        return records[key].owner;
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getTime(uint32 key) returns(uint) {
        return records[key].time;
    }

    // Registry owner can use this function to withdraw any value owned by
    // the registry.
    function withdraw(address to, uint value) onlyOwner {
        if (!to.send(value)) throw;
    }

    function kill() onlyOwner {
        suicide(owner);
    }
}

contract HelloFromGradeFour is BaseRegistry {}
