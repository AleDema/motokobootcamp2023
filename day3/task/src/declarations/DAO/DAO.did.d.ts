import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'id' : ProposalId,
  'title' : string,
  'reject_votes' : bigint,
  'description' : string,
  'state' : ProposalState,
  'approve_votes' : bigint,
  'change' : string,
}
export type ProposalId = bigint;
export type ProposalState = { 'open' : null } |
  { 'approved' : null } |
  { 'rejected' : null };
export type Result = { 'ok' : Proposal } |
  { 'err' : string };
export type VotingOptions = { 'reject' : null } |
  { 'approve' : null };
export interface _SERVICE {
  'get_all_proposals' : ActorMethod<[], Array<Proposal>>,
  'get_proposal' : ActorMethod<[ProposalId], Result>,
  'submit_proposal' : ActorMethod<[string, string, string], undefined>,
  'vote' : ActorMethod<[ProposalId, VotingOptions], undefined>,
}
