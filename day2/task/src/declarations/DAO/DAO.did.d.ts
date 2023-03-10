import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'id' : ProposalId,
  'title' : string,
  'content' : string,
  'reject_votes' : bigint,
  'accept_votes' : bigint,
  'state' : ProposalState,
  'change' : string,
}
export type ProposalId = bigint;
export type ProposalState = { 'open' : null } |
  { 'approved' : null } |
  { 'rejected' : null };
export interface _SERVICE {
  'get_all_proposals' : ActorMethod<[], Array<Proposal>>,
}
