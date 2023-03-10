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
    'content' : IDL.Text,
    'reject_votes' : IDL.Nat,
    'accept_votes' : IDL.Nat,
    'state' : ProposalState,
    'change' : IDL.Text,
  });
  return IDL.Service({
    'get_all_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
