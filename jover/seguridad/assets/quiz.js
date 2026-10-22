document.querySelectorAll("[data-quiz]").forEach((quiz) => {
  const questions = [...quiz.querySelectorAll(".quiz__q")];
  const scoreEl = quiz.querySelector(".quiz__score");
  let answered = 0;
  let correct = 0;

  const updateScore = () => {
    if (!scoreEl) return;
    scoreEl.textContent = answered === 0
      ? "0 de " + questions.length + " respondidas"
      : correct + " de " + answered + " correctas";
  };

  questions.forEach((q) => {
    const answer = q.dataset.answer;
    const choices = [...q.querySelectorAll(".choice")];
    const why = q.querySelector(".quiz__why");
    let done = false;

    choices.forEach((button) => {
      button.addEventListener("click", () => {
        if (done) return;
        done = true;
        answered += 1;
        const picked = button.dataset.choice;
        const isRight = picked === answer;

        if (isRight) correct += 1;

        choices.forEach((other) => {
          other.disabled = true;
          if (other.dataset.choice === answer) other.classList.add("correct");
        });
        if (!isRight) button.classList.add("wrong");

        if (why) why.hidden = false;
        updateScore();
      });
    });
  });

  const reset = quiz.querySelector(".quiz__reset");
  if (reset) {
    reset.addEventListener("click", () => {
      answered = 0;
      correct = 0;
      questions.forEach((q) => {
        q.querySelectorAll(".choice").forEach((b) => {
          b.disabled = false;
          b.classList.remove("correct", "wrong");
        });
        const why = q.querySelector(".quiz__why");
        if (why) why.hidden = true;
      });
      updateScore();
    });
  }

  updateScore();
});
