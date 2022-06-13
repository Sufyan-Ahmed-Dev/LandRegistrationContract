// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// Start land Project 786
contract LandRegisteration {
    

    constructor (){
        LandInspectorAddress=msg.sender;
}

modifier CheckLandInspecter(){   
     require(LandInspectorAddress ==msg.sender,"you are not landInspector");
    _;}
     enum VerificationStatus{
        NotVerified,
        Verify   
}
// make struct for land registery
struct landRegistry{
    VerificationStatus Verify;
    address Owner;
    uint LandID;
    string Area;
    string City;
    string State;
    uint LandPrice;
    string PropertyPID;
}
// Struct For Seller Detail 
struct SellerDetail{
    address sellerID;
    string Name;
    uint  Age;
    string City;
    uint CNIC;
    string Email;
}

// Struct for buyer detail  
struct BuyerDetail{
    
    address BuyerID;
    string Name;
    uint Age;
    string City;
    uint CNIC;
    string Email;
}

// Struct For LandINspector Detail 
struct LandInspector{
    address ID;
    string Name;
    uint Age;
    string Designation;

}
// public variables define here 
address public LandInspectorAddress;

// functions here 
// 1.seller 

function AddSeller(address sellerID, string memory Name , uint Age , string memory City, uint CNIC , string memory Email) public{
   require(VerifyBuyer[sellerID]==false && VerifyBuyer[msg.sender]==false , "you can't use Seller Account" );
   SellerMap[sellerID] = SellerDetail(msg.sender , Name ,Age ,City , CNIC , Email);

  
} 

// 2.buyer 
function AddBuyer(address BuyerID ,string memory Name , uint Age , string memory City , uint CNIC , string memory Email) public{
    require(VerifySeller[BuyerID] == false && VerifyBuyer[msg.sender] == false , "You can't use buyer Account" );
    BuyerMap[BuyerID] = BuyerDetail(msg.sender ,Name , Age , City , CNIC ,Email);
   

}
   
// convert in either 
 uint  ConvertInEither = 1000000000000000000;
// 3.add land 
function AddLand( uint LandID, string memory Area ,string memory City ,string memory State , uint LandPrice,string memory PropertyPID )public {
    LandPrice = LandPrice*ConvertInEither ;
    lands[LandID] =landRegistry(VerificationStatus.NotVerified,msg.sender,LandID, Area, City, State, LandPrice,PropertyPID);
    require (VerifySeller[msg.sender] == true , "You are not  verify ");
    CheckOwnerMap[LandID] = msg.sender;
}



  

// 4.land inspector 
function MakeLandInspector  ( uint ID, string memory Name , uint Age, string memory Designation ) public CheckLandInspecter {
    LandInspectorMap[ID]=LandInspector(msg.sender , Name , Age , Designation);

} 
// Update seller and buyer functions here 
// 1.make seller update function 
function UpdateSeller (address sellerID , string memory __Name , uint __Age , string memory __City , uint __CNIC , string memory __Email )public CheckLandInspecter {
    SellerDetail storage SellerUpdate = SellerMap[sellerID];
    SellerUpdate.Name = __Name; 
    SellerUpdate.Age  = __Age;
    SellerUpdate.City = __City;
    SellerUpdate.CNIC = __CNIC;
    SellerUpdate.Email= __Email ;
}

// 2.make buyer update function 
function UpdateBuyer (address BuyerID , string memory __Name , uint __Age , string memory __City , uint __CNIC , string memory __Email )public CheckLandInspecter{
    BuyerDetail storage BuyerUpdate = BuyerMap[BuyerID];
    BuyerUpdate.Name = __Name ;
    BuyerUpdate.Age  = __Age ;
    BuyerUpdate.City = __City;
    BuyerUpdate.CNIC = __CNIC;
    BuyerUpdate.Email= __Email ;
}


// mapping setup  here 
mapping(uint => landRegistry) public lands;
mapping(uint => LandInspector) public LandInspectorMap;
mapping(address => SellerDetail) public SellerMap;
mapping(address => BuyerDetail) public BuyerMap;
mapping (address =>bool)public VerifySeller;
mapping (address =>bool)public VerifyBuyer;
mapping (uint => bool) public VerifyLand;
mapping (uint=>address ) public CheckOwnerMap;

// seller and buyer verification 
function SellerVerrification (address Id) public CheckLandInspecter() {
    VerifySeller[Id]=true; 
    }

function SellerRejection(address Id)public CheckLandInspecter(){
    VerifySeller[Id]=false;
    }

function BuyerVerification (address Id) public CheckLandInspecter() {
    VerifyBuyer[Id]=true;
    }

function BuyerRejection(address Id)public CheckLandInspecter() {
    VerifyBuyer[Id]=false;
    }

function LandVerification (uint LandID) public CheckLandInspecter() {
    VerifyLand[LandID]=true; 
    }

function LandRejection (uint LandID) public CheckLandInspecter() {
    VerifyLand[LandID]=false; 
    }


// perchase land 
function purchaseLand( uint _LandID )  public payable {
    require (VerifyBuyer [msg.sender]==true,"Sorry.. you are not verified");
    require(VerifyLand[_LandID] == true , "Your land is not verified");
    require (lands [_LandID].LandPrice==msg.value,"Your value less then ya greater than land price");
    payable (lands[_LandID].Owner).transfer(msg.value);
    lands[_LandID].Owner=msg.sender;       
}

// owner shipment 
function tansferOwnership(uint LandID,address __address) public {
    CheckOwnerMap[LandID]=__address;
    require (CheckOwnerMap[LandID]==msg.sender,"you are not owner ");
    }
// pricing function all are here 

function GetLandprice(uint price) public view  returns (uint){
    return lands[price].LandPrice;
}

function GetLandCity(uint  __City) public  view returns (string memory) {
    return lands[__City].City;
}

function GetLandArea(uint __Area)public view returns (string memory) {
    return lands[__Area].Area;

}

}
