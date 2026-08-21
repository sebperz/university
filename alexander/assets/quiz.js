(function () {
  function makeQuiz(div, data) {
    var q = document.createElement('div');
    q.className = 'quiz';
    var h = document.createElement('h3');
    h.textContent = data.question;
    q.appendChild(h);

    var feedback = document.createElement('div');
    feedback.className = 'feedback';

    data.options.forEach(function (opt, i) {
      var b = document.createElement('button');
      b.className = 'option';
      b.textContent = opt.text;
      b.addEventListener('click', function () {
        var buttons = q.querySelectorAll('.option');
        buttons.forEach(function (x) { x.disabled = true; });
        if (i === data.correct) {
          b.classList.add('correct');
          feedback.className = 'feedback ok';
          feedback.textContent = data.correctMsg || '¡Correcto!';
        } else {
          b.classList.add('wrong');
          buttons[data.correct].classList.add('correct');
          feedback.className = 'feedback bad';
          feedback.textContent = data.wrongMsg || 'Incorrecto. Mira la respuesta marcada.';
        }
      });
      q.appendChild(b);
    });

    q.appendChild(feedback);
    div.parentNode.insertBefore(q, div.nextSibling);
    div.parentNode.removeChild(div);
  }

  window.renderQuiz = function (id, data) {
    var el = document.getElementById(id);
    if (el) makeQuiz(el, data);
  };
})();