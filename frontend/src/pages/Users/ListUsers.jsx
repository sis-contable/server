import React, { useEffect, useState } from 'react';
import { Container } from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import getListUsersService from '../../services/getListUsersService';
import EditUser from './editUser';
import DeleteUser from './deleteUser';

// Componente funcional ListUsers
const ListUsers = () => {
    // Definimos un estado llamado 'users' para almacenar la lista de usuarios
    const [users, setUsers] = useState([]); // Estado para almacenar la lista de usuarios
    const [showEditModal, setShowEditModal] = useState(false); // Estado para controlar la visibilidad del modal de edición
    const [showDeleteModal, setShowDeleteModal] = useState(false); // Estado para controlar la visibilidad del modal de edición
    const [selectedUser, setSelectedUser] = useState(null); // Estado para almacenar el usuario seleccionado para editar
    const [selectedUserID, setSelectedUserID] = useState(null); // Estado para almacenar el ID del usuario seleccionado para eliminar

    // Función asincrónica para obtener los datos de la API
    const fetchData = async () => {
        try {
            // Llamamos a la función del servicio para obtener la lista de usuarios
            const result = await getListUsersService();
            // Actualizamos el estado 'users' con los datos obtenidos
            setUsers(result[0]); // Establecer solo el primer elemento que contiene los usuarios
            console.log(result[0])
        } catch (error) {
            console.error('Error fetching users:', error);// Si ocurre un error, lo mostramos en la consola
        }
    };


    // useEffect se ejecuta después del primer renderizado y cuando el componente se actualiza
    useEffect(() => {
        fetchData();// Ejecutamos la función para obtener los datos
    }, []); 

    // Función para manejar el clic en el botón de editar
    const handleEditClick = (user) => {
        setSelectedUser(user);// Establece el usuario seleccionado en el estado
        setShowEditModal(true);// Muestra el modal de edición
    };

    // Función para manejar el clic en el botón de eliminar
    const handleDeleteClick = (userId) => {
        setSelectedUserID(userId); // Establece el ID del usuario
        setShowDeleteModal(true); // Muestra el modal de confirmación
    };

    // Función para manejar la actualización del usuario después de guardar cambios en el modal
    const handleSave = async (updatedUser) => {
        // Verifica si hay un usuario actualizado
        if (updatedUser) {
            // Actualiza el estado 'users' mapeando cada usuario
            // Si el ID del usuario coincide con el ID del usuario actualizado, reemplaza ese usuario con el usuario actualizado
            // Si no coincide, deja el usuario tal cual
            setUsers(users.map(user => user.id_usuario === updatedUser.id_usuario ? updatedUser : user));
        }
        setShowEditModal(false);// Oculta el modal de edición
        setSelectedUser(null); // Limpiar el usuario seleccionado
    };

    // Función para manejar la eliminacion del usuario 
    const handleDelete = () => {
        fetchData(); // Actualiza la lista de usuarios
        setShowDeleteModal(false); // Cierra el modal
        setSelectedUserID(null); // Limpia el ID del usuario seleccionado
    };

     // Función para cerrar el modal de edición
     const handleCloseEdit = () => {
        setShowEditModal(false); // Cierra el modal
        setSelectedUser(null); // Limpiar el usuario editado
    };

    // Función para cerrar el modal de eliminacion
    const handleCloseDelete = () => {
        setShowDeleteModal(false); // Cierra el modal
        setSelectedUserID(null); // Limpia el ID del usuario seleccionado
    };

    

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
                            <button type="button" className="btn btn-secondary btn-sm me-1" onClick={() => handleEditClick(user)}>Editar</button>
                            <button type="button" className="btn btn-light btn-sm" onClick={() => handleDeleteClick(user.id_usuario)}>Eliminar</button>
                        </div>
                    </div>
                ))}
            </div> 
            {selectedUser && (     // Si hay un usuario seleccionado, muestra el componente EditUser
                <EditUser
                    user={selectedUser} // Pasa el usuario seleccionado como prop
                    onSave={handleSave} // Pasa la función handleSave como prop para guardar cambios
                    onClose={handleCloseEdit} // Pasa la función handleCloseEdit como prop para cerrar el modal de edición
                />
            )}
            {selectedUserID !== null && (   // Si hay un ID de usuario seleccionado (no es null), muestra el componente DeleteUser
                <DeleteUser
                    userId={selectedUserID} // Pasa el ID del usuario seleccionado como prop
                    onDelete={handleDelete} // Pasa la función handleDelete como prop para manejar la eliminación
                    onClose={handleCloseDelete} // Pasa la función handleCloseDelete como prop para cerrar el modal de eliminación
                />
            )}
        </Container>
    );
};

// Exportamos el componente para que pueda ser utilizado en otros archivos
export default ListUsers;

