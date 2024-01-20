import { Navigate, RouterProvider, createBrowserRouter } from 'react-router-dom';
import Auth from '../components/Auth';

import Redirection from '../components/Redirection';
import Home from '../components/Home';
import AreaCreate from '../components/area/AreaCreate';
import Profile from '../components/Profile';

const routerConfig = [
    {
        path: '/',
        element: (<Redirection />),
    },
    {
        path: '/home',
        element: (<Home />),
    },
    {
        path: '/area',
        element: (<AreaCreate />),
    },
    {
        path: '/profile',
        element: (<Profile/>)
    }
];

export const router = createBrowserRouter(routerConfig);

export default { router };
