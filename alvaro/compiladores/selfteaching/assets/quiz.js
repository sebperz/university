/* quiz.js — reusable quiz widget for course lessons.
   Usage:
     <div class="quiz">
       <div class="question">
         <p class="q-text">Question?</p>
         <button class="option">Answer</button>
         <button class="option" data-correct>Right answer</button>
         <p class="feedback"></p>
       </div>
     </div>
   Clicking an option locks the answer in and colors it.
   A "Check answers" button scores the whole quiz.
   No dependencies. Load with defer. */

(function () {
  "use strict";

  function el(tag, cls, text) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (text) n.textContent = text;
    return n;
  }

  document.querySelectorAll(".quiz").forEach(function (quiz) {
    var questions = Array.prototype.slice.call(quiz.querySelectorAll(".question"));

    questions.forEach(function (q) {
      var options = Array.prototype.slice.call(q.querySelectorAll(".option"));
      var feedback = q.querySelector(".feedback");
      var answered = false;

      function lock() {
        options.forEach(function (o) { o.disabled = true; });
      }

      options.forEach(function (opt) {
        opt.addEventListener("click", function () {
          if (answered) return;
          answered = true;
          lock();
          if (opt.hasAttribute("data-correct")) {
            opt.classList.add("correct");
            if (feedback) {
              feedback.textContent = "\u2713 Correct";
              feedback.className = "feedback ok";
            }
          } else {
            opt.classList.add("incorrect");
            options.forEach(function (o) {
              if (o.hasAttribute("data-correct")) o.classList.add("correct");
            });
            if (feedback) {
              feedback.textContent = "\u2717 Not quite";
              feedback.className = "feedback bad";
            }
          }
        });
      });
    });

    var button = el("button", "check", "Check answers");
    button.type = "button";
    button.addEventListener("click", function () {
      var score = 0;
      questions.forEach(function (q) {
        var opts = Array.prototype.slice.call(q.querySelectorAll(".option"));
        var picked = opts.find(function (o) { return o.classList.contains("correct") || o.classList.contains("incorrect"); });
        var fb = q.querySelector(".feedback");
        if (picked && picked.hasAttribute("data-correct")) score += 1;
        if (!picked) {
          opts.forEach(function (o) { o.disabled = true; });
          opts.forEach(function (o) {
            if (o.hasAttribute("data-correct")) o.classList.add("correct");
          });
          if (fb) {
            fb.textContent = "Skipped \u2014 correct answer highlighted.";
            fb.className = "feedback";
          }
        }
      });
      button.disabled = true;
      var summary = quiz.querySelector(".score") || (function () {
        var s = el("p", "score");
        quiz.appendChild(s);
        return s;
      })();
      summary.textContent = score + " / " + questions.length + " correct";
      summary.className = "score feedback " + (score === questions.length ? "ok" : "");
    });
    quiz.appendChild(button);
  });
})();