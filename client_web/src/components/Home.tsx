import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContextProvider";
import NavBar from "./atoms/NavBar";
import MyTasks from "./area/MyTasks";
import '../styles/Home.css';
import AreaCreate from "./area/AreaCreate";

export function Home(_: HomeProps) {
    const { loggedIn } = useAuth();
    const navigate = useNavigate();
    const [area, setArea] = useState(true);

    if (!loggedIn) {
        navigate("/");
        return null;
    }

    return (
        <>
            <NavBar />
            <div className="body-container">
                <MyTasks />
                <button className="round-button" onClick={() => navigate("/area")}>
                    +
                </button>
            </div>
        </>
    );
}

export interface HomeProps { }

export default Home;
