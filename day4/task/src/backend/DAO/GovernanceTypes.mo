module GovernanceTypes {
    public type ProposalId = Nat;
    public type Proposal = {
        id : ProposalId;
        title : Text;
        description : Text;
        change : Text;
        state : ProposalState;
        approve_votes : Nat;
        reject_votes : Nat
    };

    // pType : ProposalType

    public type ProposalType = {
        #change_text; //just text
        #update_min_vp; //just nat
        #update_threshold; //just nat
        #create_lottery // amount, price per, share %, winning %
    };

    public type ProposalState = {
        #approved;
        #rejected;
        #open
    };

    public type VotingOptions = {
        #approve;
        #reject
    };

    public type Vote = {
        voter : Principal;
        voting_power : Nat;
        vote : VotingOptions
    }
}
