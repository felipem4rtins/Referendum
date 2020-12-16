pragma solidity ^0.4.2;

contract Referendum {
    // Model a Result
    struct Result {
        uint yes;
        uint no;
        uint totalVotes;
    }
    
    enum Stages {
        Voting,
        Revealing,
        Finished
    }
     
     
    
     // Store accounts that have voted
     mapping(address => bool) public voters;
     Result result;
     string subject;
     address owner;
     uint referendumEnd;
     uint maxVotes;
     uint duration;
     Stages private stage = Stages.Voting;
     uint private creationTime = now;
    
     constructor(string _subject,
        uint _referedumDurationInDays, uint _maxVotes) public {
        subject = _subject;
        maxVotes = _maxVotes;
        owner = msg.sender;
        result = Result(0, 0, 0);
        duration =  _referedumDurationInDays * 1 minutes;
    }
    
    
    modifier atStage(Stages _stage) {
        if(stage == Stages(0))
        {
            require(stage == _stage,"Currently voting");
        }
        if(stage == Stages(1))
        {
            require(stage == _stage,"Awaiting reveal");
        }
        if(stage == Stages(2))
        {
            require(stage == _stage,"Finished");
        }
        _;
    }

    function nextStage() internal {
        stage = Stages(uint(stage) + 1);
    }
    
    modifier timedTransitions() {
        if (stage == Stages.Voting &&
                    now >= creationTime + duration)
            nextStage();
        // The other stages transition by transaction
        _;
    }
    
    function StagePrint() public view returns(Referendum.Stages)
    {
        return Stages(uint(stage));
    }

    function Reveal() timedTransitions atStage(Stages.Revealing) public returns(string)
        {
            nextStage();
            if(result.totalVotes < (maxVotes*2)/3)
            {
                return "Not enough votes";
            }
            else
            {
                if(result.yes>result.no) return "yes";
                if(result.no>result.yes) return "no";
                else return "draw";
            }
        }
        
        
    
     function vote (uint _vote) timedTransitions atStage(Stages.Voting) private {
     // require that they haven't voted before
     require(!voters[msg.sender],"Already voted");
    
     // require a valid candidate
     require(_vote == 0 || _vote == 1);
    
     // record that voter has voted
     voters[msg.sender] = true;
    
     // update candidate vote Count
     if (_vote == 1) result.yes++;
     else result.no++;
     result.totalVotes++;
     if(result.totalVotes==maxVotes)
     {
         nextStage();
     }
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
     function GetYes() public view returns (uint){
         return result.yes;
     }
     function GetNo() public view returns (uint){
         return result.no;
     }
     function GetTotal() public view returns (uint){
         return result.totalVotes;
     }
}
