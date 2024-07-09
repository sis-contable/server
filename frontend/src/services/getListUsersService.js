// Definimos una función asincrónica que toma los datos del formulario como argumento
const getListUsersService = async () => {
    try {
      // Enviamos una solicitud GET al servidor para obtener la lista de usuarios
      const responsUsers = await fetch('http://localhost:3000/listUsers', {
        method: 'GET', // Método HTTP
        headers: {
          'Content-Type': 'application/json', // Especificamos el tipo de contenido como JSON
        },
      });
      // Convertimos la respuesta del servidor a un objeto js
      const result = await responsUsers.json();
      //Corroboramos que funciona
      console.log('Resultado obtenido:', result);
      // Devolvemos el resultado para que pueda ser manejado en la lista
      return result;
    } catch (error) {
      // Si ocurre un error, lo imprimimos en la consola y lanzamos una excepción
      console.error('Error al recorrer la lista', error);
      throw error;
    }
  };
  
  // Exportamos la función para que pueda ser utilizada en otros archivos
  export default getListUsersService;