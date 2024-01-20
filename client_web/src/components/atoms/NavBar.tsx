import React from 'react';
import { useAuth } from '../../context/AuthContextProvider';
import { useNavigate } from 'react-router-dom';
import { LocalAuthLogout } from '../../hooks/LocalAuth';
import '../../styles/NavBar.css';

export function NavBar(_: NavBarProps) {
  const { checkLoginState, loggedIn, user } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await LocalAuthLogout();
    await checkLoginState();
    navigate('/');
  };

  return (
    <nav className="navbar">
      <div className="logoContainer">
        <span className="logo">Reactobot</span>
      </div>
      {loggedIn && (
        <div className="userContainer">
          <span className="userName" onClick={() => { navigate('/profile');}}>{user?.name}</span>
        </div>
      )}
      {loggedIn && (
        <div className="logoutContainer">
          <button className="btn" onClick={handleLogout}>logout</button>
        </div>
      )}
    </nav>
  );
};

export interface NavBarProps {}

export default NavBar;
