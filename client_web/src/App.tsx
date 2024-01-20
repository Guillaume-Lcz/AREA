import './App.css';
import axios from 'axios';
import { router } from './router/router'
import { AuthContextProvider } from './context/AuthContextProvider';
import { RouterProvider } from 'react-router-dom';

axios.defaults.withCredentials = true;

function App() {
  return (
    <div className="App">
    <header className="App-header">
      <AuthContextProvider>
        <RouterProvider router={router} />
      </AuthContextProvider>
    </header>
    </div>
  );
}

export default App;
