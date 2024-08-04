// Importa componentes de react-router-dom para la navegación
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'; 
import Header from './componentes/Header/Header'; // Importa el componente Header
import Home from './pages/Home/Home'; // Importa el componente Home (suponiendo que tienes este componente)
import ListUsers from './pages/Users/ListUsers'; // Importa el componente ListUsers
import Login from './pages/Login/Login';
import React, { useState } from 'react';

const App = () => {
  const [loginSuccessful, setLoginSuccessful] = useState(localStorage.getItem('token'));
  return (
    <div className="App">
      <Router> {/* Envuelve toda la aplicación en un Router para manejar las rutas */}
        {loginSuccessful && <Header setLoginSuccessful={setLoginSuccessful} />} {/* Incluye el componente Header en todas las páginas */}
        <Routes> {/* Define las rutas de la aplicación */}
        <Route path="/" element={loginSuccessful ? <Home /> : <Navigate to="/login" />} />
        <Route path="/login" element={!loginSuccessful ? <Login setLoginSuccessful={setLoginSuccessful} /> : <Navigate to="/" />} />
          <Route path='/home' element={<Home />} /> {/* Ruta para la página Home */}
          <Route path='/ListUsers' element={<ListUsers />} /> {/* Ruta para la página ListUsers */}
        </Routes>
      </Router>
    </div>
  );
}

export default App; // Exporta el componente App para que pueda ser usado en otros archivos