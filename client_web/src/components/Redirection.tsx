import { useAuth } from '../context/AuthContextProvider';
import { Navigate } from 'react-router-dom';
import Auth from './Auth';

export function Redirection(_: RedirectionProps) {
  const { loggedIn } = useAuth();

  return (<>{loggedIn == true ? (
    <Navigate to="/home" replace />
  ) : loggedIn == false ? (
    <Auth />
  ) : <></>}</>);
}

export interface RedirectionProps {

}

export default Redirection;