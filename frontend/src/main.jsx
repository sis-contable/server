import React from 'react';
import ReactDOM from 'react-dom/client';
//Importamos el Main
import Main from './componentes/Main/Main'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    {/*Aca llamamos al componente del Main*/}
    <Main />
  </React.StrictMode>,
)
