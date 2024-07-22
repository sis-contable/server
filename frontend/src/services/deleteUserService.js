const deleteUserService = async (userId) => {
    try {

        console.log('ID del usuario:', userId); 
        const response = await fetch(`http://localhost:3000/deleteUser/${userId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            }
        });
        if (response.ok) {
            console.log('Usuario eliminado con éxito');
            return userId;
        } else {
            console.error('Error al eliminar usuario');
            return null;
        }
    } catch (error) {
        console.error('Error al eliminar usuario:', error);
        return null;
    }
};

export default deleteUserService;