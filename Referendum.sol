pragma solidity ^0.4.2;

contract Referendum {
    // Model a Result
    struct Result {
        uint yes;
        uint no;
        uint totalVotes;
    }
    
     // Store accounts that have voted
     mapping(address => bool) public voters;
     Result result;
     string public subject;
     address owner;
     uint referendumEnd;
     uint minVotos;
    
     constructor(string _subject,
        uint _referedumDurationInDays, uint _minVotos) public {
        subject = _subject;
        minVotos = _minVotos;
        owner = msg.sender;
        result = Result(0, 0, 0);
        referendumEnd = now + _referedumDurationInDays * 5 minutes;
    }
    
    modifier onlyAfter(uint _time) {
        require(now >= _time);
        _;
    }
    
    modifier onlyWith(uint _votes) {
        require(_votes >= minVotos);
        _;
    }

    function Reveal()
        public
        onlyAfter(referendumEnd)
        onlyWith(result.totalVotes)
        view returns(string)
    {
            if(result.yes>result.no) return "yes";
            if(result.no>result.yes) return "no";
            else return "draw";
    }
    
     function vote (uint _vote) private {
     // require that they haven't voted before
     require(!voters[msg.sender]);
    
     // require a valid candidate
     require(_vote == 0 || _vote == 1);
    
     // record that voter has voted
     voters[msg.sender] = true;
    
     // update candidate vote Count
     if (_vote == 1) result.yes++;
     else result.no++;
     result.totalVotes++;
     }
     
     function voteYes() public{
         vote(1);
     }
     function voteNo() public{
         vote(0);
     }
     function GetSubject() public view returns (string){
         return subject;
     }
     function GetReferendumEnd() public view returns (uint){
         return referendumEnd;
     }
     function GetMinVotos() public view returns (uint){
         return minVotos;
     }
}
