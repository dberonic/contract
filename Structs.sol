pragma solidity ^0.8.11;
pragma abicoder v2;

/**
 * The main contract
 * Holds the lists of users and papers and conects them
 **/

contract Structs{

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

        // store ids from other
        // string postedPapersID; // holds a reference to the array in the paper contract
        // string writtenReviewsListID;
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
}