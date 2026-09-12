/* Quiz interactivo reutilizable del curso.
   Uso:
   <div class="quiz" data-quiz data-title="Autoevaluación">
     <script type="application/json">
       [ { "q": "…", "options": ["A","B","C"], "correct": 1, "explain": "…" } ]
     </script>
   </div>
   Rendirse nunca: cada pregunta se puede reintentar hasta acertar; el widget
   cuenta aciertos y muestra el total al final. */
(function () {
  "use strict";

  function render(container) {
    var dataEl = container.querySelector("script[type='application/json']");
    if (!dataEl) return;
    var questions;
    try { questions = JSON.parse(dataEl.textContent); } catch (e) { return; }
    var title = container.getAttribute("data-title") || "Comprueba tu comprensión";
    var score = 0, attempted = 0, answered = 0;

    var head = document.createElement("div");
    head.className = "quiz-title";
    head.textContent = title;
    container.appendChild(head);

    questions.forEach(function (item, qi) {
      var qEl = document.createElement("p");
      qEl.className = "quiz-q";
      qEl.textContent = (qi + 1) + ". " + item.q;
      container.appendChild(qEl);

      var fb = document.createElement("p");
      fb.className = "quiz-fb";
      var solved = false;
      var group = document.createElement("div");

      item.options.forEach(function (opt, oi) {
        var btn = document.createElement("button");
        btn.type = "button";
        btn.className = "quiz-opt";
        btn.textContent = opt;
        btn.addEventListener("click", function () {
          if (solved) return;
          attempted++;
          var buttons = group.querySelectorAll(".quiz-opt");
          if (oi === item.correct) {
            solved = true;
            score++; answered++;
            btn.classList.add("correct");
            buttons.forEach(function (b) { b.disabled = true; });
            fb.className = "quiz-fb ok";
            fb.textContent = "✓ Correcto. " + (item.explain || "");
            if (answered === questions.length) showScore();
          } else {
            btn.classList.add("wrong");
            btn.disabled = true;
            fb.className = "quiz-fb ko";
            fb.textContent = "✗ No es esa. Piensa de nuevo: " + (item.hint || "relee la definición en la lección.");
          }
        });
        group.appendChild(btn);
      });

      container.appendChild(group);
      container.appendChild(group);
      container.appendChild(fb);
    });

    function showScore() {
      var s = container.querySelector(".quiz-score");
      s.style.display = "block";
      s.textContent = "Resultado: " + score + " / " + questions.length +
        " (intentos totales: " + attempted + ")" +
        (attempted > questions.length ? " — la dificultad extra fortalece la memoria." : "");
    }

    var scoreEl = document.createElement("p");
    scoreEl.className = "quiz-score";
    container.appendChild(scoreEl);
  }

  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-quiz]").forEach(render);
  });
})();
