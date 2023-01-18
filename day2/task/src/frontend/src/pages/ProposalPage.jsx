import React from 'react';

import { useSnapshot } from 'valtio'
import state from "../context/global"

//CANISTER
import { DAO } from "@declarations/DAO"

const ProposalPage = () => {

    const [proposals, setProposals] = React.useState({});

    const fetchProposal = async () => {
        // setProposals(await DAO.get_proposal());
        // console.log(proposals)
    }

    const submitProposal = async () => {

    }

    React.useEffect(() => {
        fetchProposal();
    }, [])

    return (
        <div>
            <p>text</p>
            <button onClick={submitProposal}>
                Vote
            </button>
        </div>
    );
};

export default ProposalPage;