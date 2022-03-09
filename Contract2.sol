pragma solidity ^0.8.11;
pragma abicoder v2;

/**
 * The main contract
 * Holds the lists of users and papers and conects them
 **/

contract Main {

    struct User {
        string email;
        string firstName;
        string lastName;
        // Metamask could handle the wallet balance
        string passwordHash;
        // passwords will be hashed appon entry and compared to stored hashes

        string biography;
        string degree; 
        // to add reviews and get air drop the user needs to be confirmed
        // if they have a degree they get more tokens
        string profession; 

        uint balance;
        address userAddress;
        bool confirmed;

        Paper[] postedPapers;
        Review[] writtenReviews;
    }
    
    struct Paper {
        string authorHash;
        string title;
        string category;
        string paperAbstract;
        uint minuteRead;
        address authorAddress;
        // list of comments
        // create an empty list
        Review[] paperReviews;
    }   

    struct Review{
        string authorHash;
        uint paperReviwed;

        string content;
        uint reviewId;
    }

    // Read/write Users
    mapping(address => User) public users;
    mapping(uint => Paper) public papers;
    
    // Arrays
    User[] usersArray;
    Paper[] papersArray;

    User[] unapprovedUsers;
    User[] unapprovedDegree;

    constructor () public {
        // the suthors address will be hinden and you will only be able to see the hash
        // this is the 
        addUser("admin@gmail.com", "Mr", "Dog", "Lorem ipsum dolor sit amet.", "admin", 0xE0B6e5538CE13841B19A022cA671a1177a3B7d83); // Dora admin
        addPaper(0, "#000", "Test title for Computer Science", "Computer Science", "Lorem ipsum dolor sit amet, consectetur adipiscing elit", 10,0xE0B6e5538CE13841B19A022cA671a1177a3B7d83);
        addPaper(1, "#000", "Test title for Psyhologie", "Psyhologie", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed erat ligula. Maecenas ut gravida lacus. Suspendisse mollis magna at dui tempus euismod. Phasellus luctus condimentum turpis, blandit viverra ligula condimentum vel. Sed cursus sagittis sem nec condimentum. Aliquam erat volutpat. Aenean ac egestas nibh. Aenean vitae feugiat tellus, et congue urna.", 8,0xE0B6e5538CE13841B19A022cA671a1177a3B7d83);

        addReview("0xE0B6e5538CE13841B19A022cA671a1177a3B7d83", 0, "Test Text");
        // addUser("admin2@gmail.com", "Mr", "Dog", "Lorem ipsum dolor sit ametes.", "admin", 0x2DD47f044d60B4c2BCA9790635329dfb4C397A44); // Zoka admin

        // addPaper(2, "#000", "Test title for Ecology", "Ecology", "Lorem ipsum dolor sit amet, ", 8,0x2DD47f044d60B4c2BCA9790635329dfb4C397A44);
        // addPaper(3, "#000", "Test title for Biology", "Biology", "Lorem ipsum dolor sit amet, ", 8,0x2DD47f044d60B4c2BCA9790635329dfb4C397A44);

        // addUser("admin3@gmail.com", "Mr", "Dog", "Lorem ipsum dolor sit amet, .", "admin", 0x7b61FC9AbeB0ac95a66E04F8AE69f1DAA842A451); // Saelda admin

        // addPaper(4, "#000", "Test title for Chemistry", "Chemistry", "Lorem ipsum dolor sit amet,.", 8,0x7b61FC9AbeB0ac95a66E04F8AE69f1DAA842A451);
        // addPaper(5, "#000", "Test title for Philosphi", "Philosophy", "Lorem ipsum dolor sit amet,", 8,0x7b61FC9AbeB0ac95a66E04F8AE69f1DAA842A451);

        // addReview("0xE0B6e5538CE13841B19A022cA671a1177a3B7d83", 0, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ");
  
 }

    // returning all papers
    function getUsers()  public view returns(User[] memory){
        return usersArray;
    }

     function getPapers()  public view returns(Paper[] memory){
        return papersArray;
    }

    
    function getHello() public view returns(string memory){
        return "Hello from the other side"; 
    }

    function register (string memory _userEmial, string memory _fname, string memory _lname, string memory _biografy, string memory _passwordHash, address _address) public returns(User memory) {
         // check if the user exists 
         bytes memory tempEmptyStringTest = bytes(users[_address].email); 
        if(tempEmptyStringTest.length != 0){ // checks if the user with this adress exists
           revert('The user with this address already exists');
        } 

        //TODO check if the data is in the valid format
        addUser(_userEmial, _fname, _lname, _biografy, _passwordHash, _address);
        return users[_address];
    }

    function addUser (string memory _userEmial, string memory _fname, string memory _lname, string memory _biography, string memory _passwordHash, address _address) private {
       // , new Paper[](0) - this does not work
         // users[_address] = User( _userEmial, _fname, _lname, _passwordHash,_biografy, 100, _address, false);
       users[_address].email = _userEmial;
       users[_address].firstName = _fname;
       users[_address].lastName = _lname;
       users[_address].passwordHash = _passwordHash;
       users[_address].biography = _biography;
       users[_address].balance = 100;
       users[_address].userAddress = _address;
       users[_address].confirmed = false;

       usersArray.push(users[_address]);

    }

    function login(string memory _userEmial, string memory _passwordHash,  address _address) public view returns(User memory){
        
        bytes memory tempEmptyStringTest = bytes(users[_address].email); 
        if(tempEmptyStringTest.length == 0){ // checks if the user with this adress exists
           revert('The user with this address does not exist');
        }

        User memory user = users[_address]; // checks if the user with this email exists
        if(keccak256(abi.encodePacked((user.email))) !=  keccak256(abi.encodePacked((_userEmial)))) {
            revert('Incorenct username or password');
        }
        // checks if the user with this password exists
        if(keccak256(abi.encodePacked((user.passwordHash))) !=  keccak256(abi.encodePacked((_passwordHash)))) {
            revert('Incorenct username or password');
        }
        return user;
    }

    function addPaper (uint _paperID, string memory _authorHash, string memory _title, string memory _category, string memory _paperAbstract, uint _minuteRead, address  _authorAddress) public {

        bytes memory tempEmptyStringTest = bytes(users[_authorAddress].email); 
        if(tempEmptyStringTest.length == 0){ // checks if the user with this adress exists
           revert('The user with this address does not exist');
        }
      
      // do not create the new objects just assign values to it
        papers[_paperID].authorHash = _authorHash;
        papers[_paperID].title = _title;
        papers[_paperID].category = _category;
        papers[_paperID].paperAbstract = _paperAbstract;
        papers[_paperID].minuteRead = _minuteRead;

        papersArray.push(papers[_paperID]);
        // add paper to the author
      //  User memory user = users(_authorAddress);
        users[_authorAddress].postedPapers.push(papers[_paperID]);
    }

    function addReview(string memory _authorAddress, uint _paperID, string memory _reviewContent) public {
     
     // get the review data and add it to the paper 
        Review memory newReview = Review(_authorAddress, _paperID, _reviewContent, papers[_paperID].paperReviews.length + 1);
        papers[_paperID].paperReviews.push(newReview);

    }

    function getAuthoredPapers(address _authorAddress) public view returns(Paper [] memory){
        return users[_authorAddress].postedPapers;
    }

    function getPaperReviews(uint _paperID)  public view returns(Review [] memory) {
        return papers[_paperID].paperReviews;
    }



    // approve user KYC
    function approveUser(address _userAdress) public returns(bool) {
        users[_userAdress].confirmed = true;
        removeApprovedUser(_userAdress, unapprovedUsers);
        return users[_userAdress].confirmed;
    }   

    // approve user degree
    function addDegree(address _userAdress, string memory _degreeCatrgory ) public returns(string memory) {
        users[_userAdress].degree = _degreeCatrgory;
        removeApprovedUser(_userAdress, unapprovedDegree);
        return users[_userAdress].degree;
    }

    function removeApprovedUser(address _userAdress, User[] memory approvalList) private returns(bool){
        for (uint i = 0; i < approvalList.length - 1; i++) {
           if(approvalList[i].userAddress == _userAdress){
               // shift all elements to the left

               // Perserves order
            for (uint j = i; j < approvalList.length - 1; j++) {
                approvalList[j] = approvalList[j+1];
            }
            return true;
           }
        }
        return false;
    }

    // add new user to the list of unapproved
    function requestAuthentication(address _userAdress, string memory _linkToDocument ) public returns(bool) {
        users[_userAdress].confirmed;
        if( users[_userAdress].confirmed == true){
            unapprovedUsers.push(users[_userAdress]);
        } else {
            unapprovedDegree.push(users[_userAdress]);
        }
        // return true if everything is ok
        return true;
    } 
}