pragma solidity 0.5.9;

contract Aluguel {
    
    modifier justLocator() {
        require(msg.sender == locator, "Just Locator have permission");
        _;
    }
    
    struct Property {
        string city;
        uint numberRoom;
    }
    
    struct ReceiptPayment {
        uint256 date;
        uint256 valuePayment;
    }
    
    event newRentalValue (uint256 rentalValue);
    // event rentPaid (uint256 receipt);
    
    mapping(uint => ReceiptPayment) public archive;
    
    address payable public locator;
    address renter;
    uint public rentalValue;
    string addressHome;
    Property public property;
    ReceiptPayment[] public receiptPayment;
    
    constructor(address payable paramLocator, address paramRenter, uint256 paramRentalValue, string memory paramAddressHome) public {
        property = Property("Xique xique", 2);
        locator = paramLocator;
        renter = paramRenter;
        rentalValue = paramRentalValue;
        addressHome = paramAddressHome;
    }
   
    function getRenter() public justLocator view returns (address) {
        return renter;
    }
    
    function readjustRentalValue(uint256 indexRentalValue) public justLocator returns (uint256) {
        rentalValue = rentalValue + ((rentalValue * indexRentalValue) / 100);
        emit newRentalValue(rentalValue);
        return rentalValue;
    }
    
    function payment() public payable returns (bool) {
        require(msg.sender == renter, "Just renter can payment");
        require(msg.value == rentalValue, "The value it is different the rental value");
        ReceiptPayment memory receipt = ReceiptPayment(now, rentalValue);
        receiptPayment.push(receipt);
        locator.transfer(rentalValue);
        archive[receiptPayment.length] = receipt;
        return true;
    }
}
