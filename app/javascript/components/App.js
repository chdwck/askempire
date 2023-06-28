import React from "react";

function App() {
  function handleSubmit(e) {
    e.preventDefault();
    console.log("submitted", e);
  }

  return (
    <>
      <header>
        <h1>Ask Empire of Vampire</h1>
      </header>
      <main>
        <form onSubmit={handleSubmit}>
          <textarea name="question"></textarea>
        </form>
      </main>
      <footer>
        Built with{" "}
        <a href="https://github.com/reactjs/react-rails">react-rails</a> by{" "}
        <a href="https://github.com/chdwck">@chdwck</a> • Based on{" "}
        <a href="https://askmybook.com">https://askmybook.com</a>
      </footer>
    </>
  );
}

export default App;
