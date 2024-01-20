import React, {useState} from 'react'
import GoogleAuth from '../../hooks/GoogleAuth'
import { LocalAuthSignUp } from '../../hooks/LocalAuth';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContextProvider';

export function Register({ setLoginMode }: RegisterProps) {
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [answer, setAnswer] = useState('');
    const navigate = useNavigate();
    const { checkLoginState } = useAuth();

    const handleGoogleRegister = async () => {
        const url = await GoogleAuth() as string;
        if (url) {
            window.location.assign(url);
        }
    };

    const handleLocalRegister = async () => {
        const response = await LocalAuthSignUp(name, email, password);
        
        if (response.status === 201) {
            await checkLoginState();
            navigate("/home")
        }else {
            setAnswer(response.message || "Error")
        }
    }

    return (
        <>
        <h3>Register to Reactobot</h3>
        <input
            name="name"
            placeholder="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
        />
        <input
            name="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
        />
        <input
            name="password"
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
        />
        <p>{answer}</p>
        <button className="btn" onClick={handleLocalRegister}>
            Register
        </button>
        <button className="btn" onClick={() => {setLoginMode(true)}}>
            Login
        </button>
        <button className="google-button" onClick={handleGoogleRegister}>Register with Google</button>
      </>
    );
}

export interface RegisterProps {
    setLoginMode: React.Dispatch<React.SetStateAction<boolean>>;
}

export default Register;