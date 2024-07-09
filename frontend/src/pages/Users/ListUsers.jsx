import React, { useEffect, useState } from 'react';
import { Container } from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import getListUsersService from '../../services/getListUsersService';

// Componente funcional ListUsers
const ListUsers = () => {
    // Definimos un estado llamado 'users' para almacenar la lista de usuarios
    const [users, setUsers] = useState([]);

    // useEffect se ejecuta después del primer renderizado y cuando el componente se actualiza
    useEffect(() => {
        // Función asincrónica para obtener los datos de la API
        const fetchData = async () => {
            try {
                // Llamamos a la función del servicio para obtener la lista de usuarios
                const result = await getListUsersService();
                // Actualizamos el estado 'users' con los datos obtenidos
                setUsers(result[0]); // Establecer solo el primer elemento que contiene los usuarios
            } catch (error) {
                // Si ocurre un error, lo mostramos en la consola
                console.error('Error fetching users:', error);
            }
        };
        // Ejecutamos la función para obtener los datos
        fetchData();
    }, []); // El array vacío [] significa que este useEffect se ejecutará solo una vez, al montar el componente

    return (
        <Container className="mt-5">
            {/* Cabecera de la lista de usuarios */}
            <div className="d-flex justify-content-between align-items-center m-3">
                <h2>Lista de usuarios</h2>
                <button type="button" className="btn btn-primary">Crear Usuario</button>
            </div>
            {/* Contenedor de la lista de usuarios */}
            <div className="list-group">
                {/* Iteramos sobre el estado 'users' para mostrar cada usuario */}
                {users.map((user, index) => (
                    // Cada usuario se muestra en un div con estilo de Bootstrap
                    <div key={index} className="list-group-item list-group-item-action d-flex justify-content-between align-items-center" aria-current="true">
                        <div>
                            {/* Nombre y rol del usuario */}
                            <h5>{user.nombre}</h5> 
                            <small>{user.tipo_usuario}</small>
                        </div>
                        <div className="">
                            {/* Botones de acción para editar y eliminar usuarios, con la variable (user.id_usuario) obtenemos el id*/}
                            <button type="button" className="btn btn-secondary btn-sm me-1">Editar</button>
                            <button type="button" className="btn btn-light btn-sm">Eliminar</button>
                        </div>
                    </div>
                ))}
            </div>
        </Container>
    );
};

// Exportamos el componente para que pueda ser utilizado en otros archivos
export default ListUsers;