/* Quiz ligero para las lecciones.
   Uso:
   <div class="quiz" data-answer="b"
        data-correct="Correcto."
        data-incorrect="No exactamente."
        data-explanation="...">
     <fieldset> ... inputs name="q1" value="a" ... </fieldset>
     <button data-action="check">Comprobar</button>
     <button data-action="reset">Reintentar</button>
     <p class="quiz-feedback" aria-live="polite"></p>
   </div>
*/

document.querySelectorAll(".quiz").forEach(function (quiz) {
  var answer = (quiz.getAttribute("data-answer") || "").trim();
  var explanation = quiz.getAttribute("data-explanation") || "";
  var correctText = quiz.getAttribute("data-correct") || "Correcto.";
  var incorrectText = quiz.getAttribute("data-incorrect") || "No exactamente.";
  var inputs = Array.prototype.slice.call(quiz.querySelectorAll('input[type="radio"]'));
  var feedback = quiz.querySelector(".quiz-feedback");
  var checkButton = quiz.querySelector('[data-action="check"]');
  var resetButton = quiz.querySelector('[data-action="reset"]');

  function labelFor(input) {
    return input.closest("label");
  }

  function clearMarks() {
    inputs.forEach(function (input) {
      var label = labelFor(input);
      if (label) label.classList.remove("correct", "incorrect");
    });
  }

  function clearFeedback() {
    if (!feedback) return;
    feedback.textContent = "";
    feedback.classList.remove("ok", "error");
  }

  function selectedInput() {
    return inputs.filter(function (input) { return input.checked; })[0] || null;
  }

  function check() {
    var selected = selectedInput();
    clearMarks();
    clearFeedback();

    if (!selected) {
      if (feedback) {
        feedback.textContent = "Elige una opción antes de comprobar.";
        feedback.classList.add("error");
      }
      return;
    }

    var label = labelFor(selected);
    var isCorrect = selected.value === answer;

    if (label) label.classList.add(isCorrect ? "correct" : "incorrect");

    if (feedback) {
      feedback.textContent = (isCorrect ? correctText : incorrectText) +
        (explanation ? " " + explanation : "");
      feedback.classList.add(isCorrect ? "ok" : "error");
    }
  }

  function reset() {
    inputs.forEach(function (input) { input.checked = false; });
    clearMarks();
    clearFeedback();
  }

  inputs.forEach(function (input) {
    input.addEventListener("change", function () {
      clearMarks();
      clearFeedback();
    });
  });

  if (checkButton) checkButton.addEventListener("click", check);
  if (resetButton) resetButton.addEventListener("click", reset);
});
