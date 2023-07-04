import React, { useState, useEffect } from "react";

function Answer({ question }) {
  if (question?.answer) {
    return (
      <p>
        <strong>Answer:</strong> {question.answer}
      </p>
    );
  }

  return <p></p>;
}

function App() {
  const [question, setQuestion] = useState(null);
  const [inputValue, setInputValue] = useState("");

  useEffect(() => {
    const appEl = document.querySelector('[data-react-class="App"]');
    if (appEl?.dataset?.reactProps) {
      const reactProps = JSON.parse(appEl.dataset.reactProps);
      if (reactProps.question) {
        setQuestion(reactProps.question);
        setInputValue(reactProps.question.question);
      }
    }
  }, []);

  function handleInputChange(e) {
    setInputValue(e.target.value);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    const questionText = e.target.question.value?.trim();
    if (!questionText) {
      return;
    }
    e.preventDefault();
    const url = "/api/v1/questions/create";
    const result = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
      },
      body: JSON.stringify({ question: questionText }),
    });
    if (!result.ok) {
      console.log("SOmething went wrong");
      return;
    }
    const data = await result.json();
    if (data.id !== question.id) {
      window.history.pushState({}, null, `/question/${data.id}`);
    }
    setQuestion(data);
  }

  return (
    <>
      <header>
        <h1>Ask Empire of Vampire</h1>
      </header>
      <main>
        <form onSubmit={handleSubmit}>
          <textarea
            value={inputValue}
            onChange={handleInputChange}
            name="question"
          ></textarea>
          <button type="submit">Ask Question</button>
        </form>
        <Answer question={question} />
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
