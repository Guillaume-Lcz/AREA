import { createContext, useState, useEffect, useCallback, ReactNode, useContext } from 'react';
import { CheckLogin } from '../hooks/CheckLogin';

export const AuthContext = createContext<AuthContextProps | undefined>(undefined);

export function AuthContextProvider({ children }: AuthContextProviderProps) {
    const [loggedIn, setLoggedIn] = useState<boolean | null>(null);
    const [user, setUser] = useState<any>(null);

    const checkLoginState = useCallback(async () => {
        const response = await CheckLogin()
        if (response) {
            setLoggedIn(true);
            setUser(response.data);
        } else {
            setLoggedIn(false);
        }
    }, []);

    useEffect(() => {
        checkLoginState();
    }, [checkLoginState]);

    return (
        <AuthContext.Provider value={{ loggedIn, checkLoginState, user }}>
            {children}
        </AuthContext.Provider>
    );
}
export interface AuthContextProviderProps {
    children: ReactNode
}

export interface AuthContextProps {
    loggedIn: boolean | null;
    checkLoginState: () => Promise<void>;
    user: any | null;
  }

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export default { useAuth, AuthContextProvider };