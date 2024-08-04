import 'bootstrap/dist/css/bootstrap.min.css'; // Importa el CSS de Bootstrap
import 'bootstrap/dist/js/bootstrap.bundle.min'; // Importa el JS de Bootstrap, incluido el comportamiento de los componentes
import { Nav } from 'react-bootstrap'; // Importa el componente Nav de react-bootstrap
import { Link , useNavigate } from 'react-router-dom'; // Importa el componente Link de react-router-dom

const Header = ({setLoginSuccessful}) => {

  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token'); // Elimina el token del localStorage
    setLoginSuccessful(false); // Actualiza el estado de loginSuccessful a false
    navigate('/'); // Redirige al usuario a la página de inicio
  };

  return (
    <Nav className="navbar navbar-expand-lg navbar-dark bg-dark"> {/* Navbar con clases de Bootstrap para estilo y comportamiento */}
      <div className="container-fluid text-center"> 
        {/* Enlace al inicio con el logo */}
        <Link className="navbar-brand ml-2" to="/"> 
          <img src="..\src\assets\img\logo.png" alt="" width="100" height="40px" className="img-fluid" /> {/* Logo dentro del enlace */}
        </Link>
        
        {/* Botón para el menú desplegable en movile */}
        <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span className="navbar-toggler-icon"></span>
        </button>
        {/* Contenedor para los enlaces de la navbar, colapsa en movile */}
        <div className="collapse navbar-collapse justify-content-end" id="navbarNav">
          <div className="navbar-nav"> 
            {/* Enlaces de navegación */}
            <Link className="nav-link active" to="/home">Home</Link>
            <Link className="nav-link" to="/">Caja</Link>
            <Link className="nav-link" to="/ListUsers">Usuarios</Link>
            <Link className="nav-link disabled" href="#" tabIndex="-1" aria-disabled="true">Disabled</Link> 
          </div>
          
          <div className='d-flex     justify-content-center'> {/* Contenedor para el enlace de Logout */}
            <button onClick={handleLogout} className="nav-link">Cerrar sesion</button>
          </div>
        </div>
      </div>
    </Nav>
  );
}

export default Header;