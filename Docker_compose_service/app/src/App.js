import React from 'react';

function App() {
  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      <h1>Hello World!</h1>
      <p>This is a minimal React app in Docker.</p>
      <p style={{ fontWeight: 'bold', marginTop: '20px' }}>
        Env Var: {process.env.REACT_APP_TEST_VAR}
      </p>
    </div>
  );
}

export default App;