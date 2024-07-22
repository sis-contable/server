const editUserService = async (editedUser) => {
    try {
        const response = await fetch(`http://localhost:3000/editUser/${editedUser.id_usuario}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(editedUser),
        });
        if (response.ok) {
            console.log('Usuario actualizado con éxito');
            return editedUser;
        } else {
            console.error('Error al actualizar usuario');
            return null;
        }
    } catch (error) {
        console.error('Error al actualizar usuario:', error);
        return null;
    }
};

export default editUserService;