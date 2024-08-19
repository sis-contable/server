import React, { useState } from 'react';
import { Modal, Button, Form , InputGroup , Alert} from 'react-bootstrap';
import createUserService from '../../services/createUserService'
import { FaEye, FaEyeSlash } from 'react-icons/fa';

const CreateUser = ({ show, onClose, onCreate }) => {
    const [newUser, setNewUser] = useState({
        nombre: '',
        usuario: '',
        password: '',
        id_tipo_usuario: 1, //Valor por defecto
        email: ''
    })
    const [showPassword, setShowPassword] = useState(false); // Estado para manejar la visibilidad de la contraseña
    const [showSuccess, setShowSuccess] = useState(false); // Estado para manejar el mensaje de cambios guardados
    
    // Función para manejar cambios en los campos del formulario
    const handleChange = (e) => {
        const {name, value} = e.target;
        setNewUser({ ...newUser, [name]: value });
    };

     // Función para guardar los cambios y llamar a la función 'onCreate' pasada como prop
     const handleCreateUser = async () => {
        const createdUser = await createUserService(newUser);
        if(createdUser){
            setShowSuccess(true); // Muestra la alerta
            setTimeout(() => {
                setShowSuccess(false); // Oculta la alerta después de 2 segundos
                onCreate(createdUser); // Llama a onCreate con el nuevo usuario creado
                onClose();//Cierra el modal
            },900);
            
        }
    };

    // Función para alternar la visibilidad de la contraseña
    const togglePasswordVisibility = () => {
        setShowPassword(!showPassword);
    };

    return (
        <Modal show={show} onHide={onClose}>
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
                            value={newUser.nombre}
                            onChange={handleChange}
                        />
                    </Form.Group>
                    {/* Campo de formulario para el usuario del usuario */}
                    <Form.Group>
                        <Form.Label>Usuario</Form.Label>
                        <Form.Control
                            type="text"
                            name="usuario"
                            value={newUser.usuario}
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
                                value={newUser.password}
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
                            value={newUser.id_tipo_usuario}
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
                            value={newUser.email}
                            onChange={handleChange}
                        />
                    </Form.Group>
                </Form>
            </Modal.Body>
            <Modal.Footer>
                {/* Botón para guardar cambios y cerrar el modal */}
                <Button variant="primary" onClick={handleCreateUser}>Guardar</Button>
                {/* Mostrar la alerta si showSuccess es true */}
                {/* Botón para cerrar el modal sin guardar cambios */}
                <Button variant="secondary" onClick={onClose}>Cancelar</Button>
            </Modal.Footer>
        </Modal>
    );
};

export default CreateUser;