// loginService.js

// Definimos una función asincrónica que toma los datos del formulario como argumento
const loginService = async (data) => {
    try {
      // Enviamos una solicitud POST al servidor con los datos del login
      const response = await fetch('http://localhost:3000/login', {
        method: 'POST', // Método HTTP
        headers: {
          'Content-Type': 'application/json', // Especificamos el tipo de contenido como JSON
        },
        body: JSON.stringify(data), // Convertimos los datos a una cadena JSON y los enviamos en el cuerpo de la solicitud
      });
  
      // Convertimos la respuesta del servidor a un objeto JavaScript
      const result = await response.json();
      // Devolvemos el resultado para que pueda ser manejado en el componente de login
      return result;
    } catch (error) {
      // Si ocurre un error, lo imprimimos en la consola y lanzamos una excepción
      console.error('Error during login:', error);
      throw error;
    }
  };
  
  // Exportamos la función para que pueda ser utilizada en otros archivos
  export default loginService;