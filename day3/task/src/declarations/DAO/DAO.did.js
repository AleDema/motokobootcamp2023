export const idlFactory = ({ IDL }) => {
  const ProposalId = IDL.Nat;
  const ProposalState = IDL.Variant({
    'open' : IDL.Null,
    'approved' : IDL.Null,
    'rejected' : IDL.Null,
  });
  const Proposal = IDL.Record({
    'id' : ProposalId,
    'title' : IDL.Text,
    'reject_votes' : IDL.Nat,
    'description' : IDL.Text,
    'accept_votes' : IDL.Nat,
    'state' : ProposalState,
    'change' : IDL.Text,
  });
  const Result = IDL.Variant({ 'ok' : Proposal, 'err' : IDL.Text });
  return IDL.Service({
    'get_all_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'get_proposal' : IDL.Func([ProposalId], [Result], ['query']),
    'submit_proposal' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [], []),
    'vote' : IDL.Func([Proposal], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
