import Login from "./auth/Login";
import Register from "./auth/Register";

import { AuthContextProvider } from "../context/AuthContextProvider";
import { useState } from "react";

export function Auth(_: AuthProps) {
    const [loginMode, setLoginMode] = useState(true);
    return loginMode ? <Login setLoginMode={setLoginMode}/> : <Register setLoginMode={setLoginMode}/>
}

export interface AuthProps {
}

export default Auth;