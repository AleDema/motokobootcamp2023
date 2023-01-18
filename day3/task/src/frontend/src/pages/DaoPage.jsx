import React from 'react';
import { useNavigate, Link } from "react-router-dom";

import { useSnapshot } from 'valtio'
import state from "../context/global"

//CANISTER
import { DAO } from "@declarations/DAO"

const DaoPage = () => {

    const [proposals, setProposals] = React.useState({});

    const fetchProposals = async () => {
        setProposals(await DAO.get_all_proposals());
        console.log(proposals)
    }

    const submitProposal = async () => {

    }

    React.useEffect(() => {
        fetchProposals();
    }, [])

    return (
        <div>
            <input></input>
            <input></input>
            <input></input>
            <button onClick={submitProposal}>
                Create Proposal
            </button>
        </div>
    );
};

export default DaoPage;