import React, { useState , useEffect} from 'react';
import { Modal, Button, Form , InputGroup , Alert} from 'react-bootstrap';
import editUserService from '../../services/editUserService';
import { FaEye, FaEyeSlash } from 'react-icons/fa';

const CreatUser = ({ user,  onClose, onSave}) => {
    const [creatUser, setCreatUser] = useState(user); // Estado para almacenar los datos del usuario editado
    const [showPassword, setShowPassword] = useState(false); // Estado para manejar la visibilidad de la contraseña
    const [showSuccess, setShowSuccess] = useState(false); // Estado para manejar el mensaje de cambios guardados

    // useEffect para actualizar el estado 'editedUser' cuando el 'user' prop cambie
    useEffect(() => {
        setCreatUser(user);
    }, [user]);

    // Función para manejar cambios en los campos del formulario
    const handleChange = (e) => {
        const userTypeMap = {
            1: 'Administrador',
            2: 'Espectador'
        };
        const { name, value } = e.target;
        // Si el campo es 'id_tipo_usuario', convertir el valor a número entero y pasarle el tipo de usuario
        if (name === 'id_tipo_usuario') {
            const newValue = parseInt(value, 10);
            setCreatUser({ ...creatUser, [name]: newValue, tipo_usuario: userTypeMap[newValue] });
        } else {
            setCreatUser({ ...creatUser, [name]: value });
        }
    };

     // Función para guardar los cambios y llamar a la función 'onSave' pasada como prop
     const handleSaveChanges = async () => {
        const updatedUser = await creatUserService(creatUser);
        if (updatedUser) {
            setShowSuccess(true); // Muestra la alerta
            setTimeout(() => {
                setShowSuccess(false); // Oculta la alerta después de 2 segundos
                onSave(creatUser); // Llama a onSave con el usuario actualizado
                onClose(); // Cierra el modal
            },700); 
        }
    };

    // Función para alternar la visibilidad de la contraseña
    const togglePasswordVisibility = () => {
        setShowPassword(!showPassword);
    };

    return (
        <Modal show={true} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>Crear Usuario</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                {/* Mostrar la alerta si showSuccess es true */}
                {showSuccess && (
                    <Alert variant="success" className="custom-alert">
                        Usuario creado con éxito.
                    </Alert>
                )}
                <Form>
                    {/* Campo de formulario para el nombre del usuario */}
                    <Form.Group>
                        <Form.Label>Nombre</Form.Label>
                        <Form.Control
                            type="text"
                            name="nombre"
                            value=""
                            onChange={handleChange}
                        />
                    </Form.Group>
                    {/* Campo de formulario para el usuario del usuario */}
                    <Form.Group>
                        <Form.Label>Usuario</Form.Label>
                        <Form.Control
                            type="text"
                            name="usuario"
                            value={editedUser.usuario}
                            onChange={handleChange}
                        />
                    </Form.Group>
                    {/* Campo de formulario para la password del usuario */}
                    <Form.Group>
                        <Form.Label>Clave</Form.Label>
                        <InputGroup>
                            <Form.Control
                                type={showPassword ? 'text' : 'password'}
                                name="password"
                                value={editedUser.password}
                                onChange={handleChange}
                                aria-describedby="password-addon"
                            />
                            
                            <Button
                                variant="outline-secondary"
                                onClick={togglePasswordVisibility}
                                id="password-addon"
                            >   
                                {/* Mostrar "Ocultar" si la contraseña está visible, de lo contrario, mostrar "Mostrar" */}
                                {showPassword ? <FaEyeSlash /> : <FaEye />}
                            </Button>
                            
                        </InputGroup>
                    </Form.Group>
                    {/* Campo de formulario para el tipo de usuario */}
                    <Form.Group>
                        <Form.Label>Tipo de Usuario</Form.Label>
                        <Form.Select
                            name="id_tipo_usuario"
                            value={editedUser.id_tipo_usuario}
                            onChange={handleChange}
                        >
                            <option value="1">Administrador</option>
                            <option value="2">Espectador</option>
                        </Form.Select>
                    </Form.Group>
                    {/* Campo de formulario para el email del usuario */}
                    <Form.Group>
                        <Form.Label>Email</Form.Label>
                        <Form.Control
                            type="text"
                            name="email"
                            value={editedUser.email}
                            onChange={handleChange}
                        />
                    </Form.Group>
                </Form>
            </Modal.Body>
            <Modal.Footer>
                {/* Botón para cerrar el modal sin guardar cambios */}
                <Button variant="secondary" onClick={onClose}>Cancelar</Button>
                {/* Botón para guardar cambios y cerrar el modal */}
                <Button variant="primary" onClick={handleSaveChanges}>Guardar</Button>
                {/* Mostrar la alerta si showSuccess es true */}
            </Modal.Footer>
        </Modal>
    );
};

export default CreatUser;