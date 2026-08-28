/* ============================================================
   Widget de quiz reutilizable del curso.
   Uso en cualquier lección:
     <div class="quiz"
          data-quiz='[{"q":"...","options":["...","..."],"correct":0,"why":"..."}]'>
     </div>
     <script src="../assets/quiz.js"></script>
   Feedback inmediato: al responder, marca correcto/incorrecto,
   muestra la explicación y lleva el marcador del quiz.
   ============================================================ */
(function () {
  "use strict";

  function render(root) {
    var data;
    try {
      data = JSON.parse(root.getAttribute("data-quiz"));
    } catch (e) {
      return;
    }

    var score = 0;
    var answered = 0;

    var title = document.createElement("p");
    title.className = "quiz-title";
    title.textContent = root.getAttribute("data-title") || "Ponte a prueba";
    root.appendChild(title);

    data.forEach(function (item, qi) {
      var block = document.createElement("div");
      block.className = "q";

      var text = document.createElement("p");
      text.className = "q-text";
      text.textContent = (qi + 1) + ". " + item.q;
      block.appendChild(text);

      var why = document.createElement("div");
      why.className = "why";
      why.textContent = item.why || "";

      item.options.forEach(function (opt, oi) {
        var btn = document.createElement("button");
        btn.type = "button";
        btn.className = "option";
        btn.textContent = opt;
        btn.addEventListener("click", function () {
          block.classList.add("answered");
          answered += 1;
          if (oi === item.correct) {
            btn.classList.add("correct");
            score += 1;
          } else {
            btn.classList.add("incorrect");
            block.querySelectorAll(".option")[item.correct].classList.add("correct");
          }
          block.appendChild(why);
          scoreEl.textContent = "Aciertos: " + score + " de " + data.length +
            (answered === data.length ? " — " + verdict(score, data.length) : "");
        });
        block.appendChild(btn);
      });

      root.appendChild(block);
    });

    var scoreEl = document.createElement("p");
    scoreEl.className = "score";
    scoreEl.textContent = "Aciertos: 0 de " + data.length;
    root.appendChild(scoreEl);
  }

  function verdict(score, total) {
    var pct = score / total;
    if (pct === 1) return "perfecto, tema dominado";
    if (pct >= 0.7) return "bien; repasa las que fallaste";
    if (pct >= 0.4) return "repasa la lección e inténtalo de nuevo";
    return "relee la lección desde el inicio";
  }

  function init() {
    var quizzes = document.querySelectorAll(".quiz");
    Array.prototype.forEach.call(quizzes, render);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
