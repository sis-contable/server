import Login from "../../pages/Login/Login";
import ListUsers from "../../pages/Users/ListUsers";
import App from "../../App.jsx";

// Función para decodificar el JWT
function parseJwt(token) {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));

    return JSON.parse(jsonPayload);
}

// Verificación del token en localStorage
let tokenExiste = false;
const token = localStorage.getItem('token');

if (token) {
    const parsedToken = parseJwt(token);
    tokenExiste = (parsedToken.exp * 1000 > Date.now());
}

// Componente principal que muestra ListUsers o Login basado en la existencia del token
const Main = () => {
    return (
        <>
            {tokenExiste ? <App/> : <Login />} 
        </>
    );
}

export default Main;