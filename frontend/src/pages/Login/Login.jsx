// Importamos useState desde React para manejar el estado local en el componente
import React, { useState } from 'react';
// Importamos componentes de React Bootstrap para estructurar y estilizar el formulario
import { Container, Row, Col, Form, Button } from 'react-bootstrap';
// Importamos los estilos de Bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';
<<<<<<< HEAD

// Importamos la función de login desde el archivo loginService.js
import loginService from '../../services/loginService';
import App from '../../App.jsx';
=======
// Importamos componentes adicionales para renderizar en caso de login exitoso
import ListUsers from '../Users/ListUsers';
// Importamos la función de login desde el archivo loginService.js
import loginService from '../../services/loginService';
>>>>>>> origin/osvaldo

// Definimos un componente funcional llamado Login utilizando una arrow function
const Login = () => {
  // Declaramos estados locales para manejar los inputs del formulario y el estado de la sesión
  const [usuario, setUsuario] = useState('');
  const [clave, setClave] = useState('');
  const [loginSuccessful, setLoginSuccessful] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  // Función que se ejecuta cuando se envía el formulario
  const handleLogin = async (e) => {
    e.preventDefault(); // Prevenimos el comportamiento por defecto del formulario
    const data = { usuario, clave }; // Creamos un objeto con los datos del formulario

    try {
      // Llamamos a la función loginService para enviar los datos al servidor y obtener una respuesta
      const result = await loginService(data);

      // Si el servidor devuelve un token, lo almacenamos en localStorage y actualizamos el estado
      if (result.token) {
        localStorage.setItem('token', result.token);
        setLoginSuccessful(true);
      } else {
        // Si no se recibe un token, mostramos un mensaje de error
        setErrorMessage('Usuario o clave incorrecta');
      }
    } catch (error) {
      // Si ocurre un error durante el login, mostramos un mensaje de error
      setErrorMessage('Error durante el login');
    }
  };

  // Retornamos el JSX para renderizar el componente
  return (
    <>
      {loginSuccessful ? (
<<<<<<< HEAD
        // Si el login es exitoso, mostramos el componente APP
        <App/>
=======
        // Si el login es exitoso, mostramos el componente Home o ListUsers
        <ListUsers/>
>>>>>>> origin/osvaldo
      ) : (
        // Si el login no es exitoso, mostramos el formulario de login
        <Container className="mt-5">
          <Row className="justify-content-center">
            <Col xs={12} md={8} lg={5}>
              <div className="p-4 rounded shadow">
                <h2 className="text-center mb-4">Iniciar Sesión</h2>
                {/* Si hay un mensaje de error, lo mostramos */}
                {errorMessage && <p className="text-danger text-center">{errorMessage}</p>}
                <Form onSubmit={handleLogin}>
                  <Form.Group controlId="formBasicEmail" className="mb-3">
                    <Form.Label>Usuario</Form.Label>
                    <Form.Control
                      onChange={(event) => setUsuario(event.target.value)}
                      type="text"
                      placeholder="Usuario"
                    />
                  </Form.Group>

                  <Form.Group controlId="formBasicPassword" className="mb-3">
                    <Form.Label>Clave</Form.Label>
                    <Form.Control
                      onChange={(event) => setClave(event.target.value)}
                      type="password"
                      placeholder="Clave"
                    />
                  </Form.Group>
                  <Button variant="primary" type="submit" className="mb-3 mx-auto d-block">
                    Iniciar Sesión
                  </Button>
                </Form>
              </div>
            </Col>
          </Row>
        </Container>
      )}
    </>
  );
};

// Exportamos el componente Login para que pueda ser utilizado en otros archivos
export default Login;