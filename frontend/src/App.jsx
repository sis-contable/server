// Importa componentes de react-router-dom para la navegación
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'; 
import Header from './componentes/Header/Header'; // Importa el componente Header
import Home from './pages/Home/Home'; // Importa el componente Home (suponiendo que tienes este componente)
import ListUsers from './pages/Users/ListUsers'; // Importa el componente ListUsers

const App = () => {
  return (
    <div className="App">
      <Router> {/* Envuelve toda la aplicación en un Router para manejar las rutas */}
        <Header /> {/* Incluye el componente Header en todas las páginas */}
        <Routes> {/* Define las rutas de la aplicación */}
          <Route path='/home' element={<Home />} /> {/* Ruta para la página Home */}
          <Route path='/ListUsers' element={<ListUsers />} /> {/* Ruta para la página ListUsers */}
        </Routes>
      </Router>
    </div>
  );
}

export default App; // Exporta el componente App para que pueda ser usado en otros archivos