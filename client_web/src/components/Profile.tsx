import React from "react";
import "../styles/Profile.css";
import { useAuth } from "../context/AuthContextProvider";
import { useNavigate } from "react-router-dom";

export function Profile(_: ProfileProps) {
    const { user } = useAuth();
    const navigate = useNavigate();
    return (
        <div className="profile-container">
            <h1>Profile</h1>
            <div className="profile-details">
                <p>{user?.name}</p>
                <p>{user?.email}</p>
            </div>
            <button className="back-button" onClick={() => {navigate(-1)}}>
                Back
            </button>
        </div>
    );
}

export interface ProfileProps {}

export default Profile;
