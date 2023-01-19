export const idlFactory = ({ IDL }) => {
  const ProposalId__1 = IDL.Nat;
  const ProposalState = IDL.Variant({
    'open' : IDL.Null,
    'approved' : IDL.Null,
    'rejected' : IDL.Null,
  });
  const Proposal = IDL.Record({
    'id' : ProposalId__1,
    'title' : IDL.Text,
    'reject_votes' : IDL.Nat,
    'description' : IDL.Text,
    'state' : ProposalState,
    'approve_votes' : IDL.Nat,
    'change' : IDL.Text,
  });
  const ProposalId = IDL.Nat;
  const Result = IDL.Variant({ 'ok' : Proposal, 'err' : IDL.Text });
  const VotingOptions = IDL.Variant({
    'reject' : IDL.Null,
    'approve' : IDL.Null,
  });
  return IDL.Service({
    'get_all_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'get_proposal' : IDL.Func([ProposalId], [Result], ['query']),
    'submit_proposal' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [], []),
    'vote' : IDL.Func([ProposalId, VotingOptions], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
