import React from 'react';

import { useSnapshot } from 'valtio'
import state from "../context/global"
import { useParams } from "react-router-dom";

//CANISTER
import { DAO } from "@declarations/DAO"

const VotingOptions = {
    approve: null,
    reject: null,
}

const ProposalPage = () => {

    const [proposal, setProposal] = React.useState({});
    let { id } = useParams();

    const fetchProposal = async (id) => {
        let value = await DAO.get_proposal(id);
        if (value !== null && value !== undefined)
            setProposal(value.ok)
        console.log(id)
        console.log(proposal)
    }

    const accept = async () => {
        let n = BigInt(parseInt(id));
        DAO.vote(n, { approve: null })
    }
    const reject = async () => {
        let n = BigInt(parseInt(id));
        DAO.vote(n, { reject: null })
    }

    React.useEffect(() => {
        console.log(parseInt(id))
        fetchProposal(parseInt(id))
    }, [])

    return (
        <div>
            <p>{proposal.title}</p>
            <p>{proposal.description}</p>
            <p>{proposal.change}</p>
            <p>{JSON.stringify(proposal.state)}</p>
            <p>{parseInt(proposal.approve_votes)}</p>
            <p>{parseInt(proposal.reject_votes)}</p>
            <button onClick={accept}>
                Accept
            </button>
            <button onClick={reject}>
                Reject
            </button>
        </div>
    );
};

export default ProposalPage;