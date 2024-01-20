import React, {useState} from 'react'
import GoogleAuth from '../../hooks/GoogleAuth'
import { LocalAuthSignIn } from '../../hooks/LocalAuth';
import { useAuth } from '../../context/AuthContextProvider';
import { useNavigate } from 'react-router-dom';
import logoImage from '../../assets/logo.png';

export function Login({ setLoginMode }: LoginProps) {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [answer, setAnswer] = useState('');
    const navigate = useNavigate();
    const { checkLoginState } = useAuth();

    const handleGoogleLogin = async () => {
        const url = await GoogleAuth() as string;
        if (url) {
            window.location.assign(url);
        }
    };

    const handleLocalLogin = async () => {
        
        const response = await LocalAuthSignIn(email, password);
        if (response.status === 201) {
            await checkLoginState();
            navigate("/home")
        }else {
            setAnswer(response.message || "Error")
        }
    }

    return (
        <>
        <div style={{ textAlign: 'center', marginBottom: '20px' }}>
            <img
                src={logoImage} // Use the imported image variable
                alt="Profile"
                style={{
                    width: '100px',
                    height: '100px',
                    borderRadius: '50%',
                }}
            />
        </div>
        <h3>Login to Reactobot</h3>
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
        <p>{ answer }</p>
        <button className="btn" onClick={handleLocalLogin}>
          Login
        </button>
        <button className="btn" onClick={() => {setLoginMode(false)}}>
          Register
        </button>
        <button className="google-button" onClick={handleGoogleLogin}>Login with Google</button>
      </>
    );
}

export interface LoginProps {
    setLoginMode: React.Dispatch<React.SetStateAction<boolean>>;
}

export default Login;