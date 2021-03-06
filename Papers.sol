pragma solidity ^0.8.11;
pragma abicoder v2;


import "Structs.sol";
/**
 * The main contract
 * Holds the lists of users and papers and conects them
 **/

contract Papers is Structs{

    // holds the papers reviews and all related lists 
   struct Author {
       address authorHash;
       Paper[] authoredPapers;
   }

    mapping(uint => Paper) public papers; //TODO move to papers
    mapping(address => Like) public likes; //TODO move to papers

    Paper[] papersArray; // TODO move to papers
    
   
    mapping(address => Author) public authors; 


    constructor () public {
        // the suthors address will be hinden and you will only be able to see the hash
        // this is the 
        //addUser("admin@gmail.com", "Mr", "Dog", "Lorem ipsum dolor sit amet.", "admin", 0xE0B6e5538CE13841B19A022cA671a1177a3B7d83); // Dora admin
        // addPaper(0, "#000", "Test title for Computer Science", "Computer Science", "Lorem ipsum dolor sit amet, consectetur adipiscing elit", 10,0xE0B6e5538CE13841B19A022cA671a1177a3B7d83);
        // addPaper(1, "#000", "Test title for Psyhologie", "Psyhologie", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed erat ligula. Maecenas ut gravida lacus. Suspendisse mollis magna at dui tempus euismod. Phasellus luctus condimentum turpis, blandit viverra ligula condimentum vel. Sed cursus sagittis sem nec condimentum. Aliquam erat volutpat. Aenean ac egestas nibh. Aenean vitae feugiat tellus, et congue urna.", 8,0xE0B6e5538CE13841B19A022cA671a1177a3B7d83);
    
        // addReview("0xE0B6e5538CE13841B19A022cA671a1177a3B7d83", 0, "Test Text");
        // addReview("0xE0B6e5538CE13841B19A022cA671a1177a3B7d83", 1, "Test Text 1");
    }


    function addPaper (uint _paperID, string memory _authorHash, string memory _title, string memory _category, string memory _paperAbstract, uint _minuteRead, address  _authorAddress) public {

      // do not create the new objects just assign values to it
        papers[_paperID].id = papersArray.length;
        papers[_paperID].authorHash = _authorHash;
        papers[_paperID].title = _title;
        papers[_paperID].category = _category;
        papers[_paperID].paperAbstract = _paperAbstract;
        papers[_paperID].minuteRead = _minuteRead;

        papersArray.push(papers[_paperID]);
        // add paper to the author
      //  User memory user = users(_authorAddress);

        authors[_authorAddress].authoredPapers.push(papers[_paperID]);
      //TODO assign to the user
     //   users[_authorAddress].postedPapers.push(papers[_paperID]);
    }

    // MOVE
    function addReview(string memory _authorAddress, uint _paperID, string memory _reviewContent) public {
     
     // get the review data and add it to the paper 
        uint reviewId = papers[_paperID].paperReviews.length;
        Review memory newReview = Review(reviewId, _authorAddress, _paperID, 0, 0 ,_reviewContent, papers[_paperID].paperReviews.length + 1);
        papers[_paperID].paperReviews.push(newReview);

    }

    function sendReaction(uint paperId, uint reviewId, uint value, address userAddress) public{
        
        Like memory reaction = Like(userAddress,value);
        
        // check if the user allready liked it 
        if (likes[userAddress].value == 0) {// the like is not recorded
            if(value == 2) {
                papers[paperId].paperReviews[reviewId].dislikes = papers[paperId].paperReviews[reviewId].dislikes + 1;
            } else {
                papers[paperId].paperReviews[reviewId].likes = papers[paperId].paperReviews[reviewId].dislikes + 1;
            }
            likes[userAddress] = reaction;

        }

        if(likes[userAddress].value == 2 && value == 1){
            papers[paperId].paperReviews[reviewId].dislikes = papers[paperId].paperReviews[reviewId].dislikes - 1;
            papers[paperId].paperReviews[reviewId].likes = papers[paperId].paperReviews[reviewId].likes + 1;

        } else if (likes[userAddress].value == 1 && value == 2){
            papers[paperId].paperReviews[reviewId].likes = papers[paperId].paperReviews[reviewId].likes - 1;
            papers[paperId].paperReviews[reviewId].dislikes = papers[paperId].paperReviews[reviewId].dislikes + 1;
        }


    }


// TODO: Get all papers stored for this author from papers contract
    function getAuthoredPapers(address _authorAddress) public view returns(Paper [] memory){
        return authors[_authorAddress].authoredPapers;
    }

    function getPapers()  public view returns(Paper [] memory){
        return papersArray;
    }


    //TODO: Move to papers contract
    function getPaperReviews(uint _paperID)  public view returns(Review [] memory) {
        return papers[_paperID].paperReviews;
    }


}
