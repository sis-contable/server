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
            return editedUser;
        } else {
            return null;
        }
    } catch (error) {
        return null;
    }
};

export default editUserService;