/* ============================================================
   Motor de quiz — Curso de Compiladores
   Dos modos, sobre el mismo marcado:

   MODO PRÁCTICA (una pregunta a la vez):
     <div class="quiz" data-quiz></div>
     <script type="application/json" class="quiz-data">[...]</script>

   MODO EXAMEN (todo se entrega junto, con temporizador):
     <div class="quiz examen" data-quiz data-exam data-minutos="30"></div>
     <script type="application/json" class="quiz-data">[...]</script>

   Tipos de pregunta: "vf", "unica", "multiple", "relacionar".
   ============================================================ */
(function () {
  "use strict";

  function esc(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function crear(tag, clase, html) {
    var el = document.createElement(tag);
    if (clase) el.className = clase;
    if (html != null) el.innerHTML = html;
    return el;
  }

  /* ---------- Render de una pregunta ---------- */
  function renderPregunta(q, idx, modo) {
    var bloque = crear("div", "quiz-pregunta");
    bloque.dataset.indice = idx;

    var cab = crear("div", "quiz-enunciado");
    cab.innerHTML = "<span class='quiz-num'>" + (idx + 1) + "</span> " + esc(q.pregunta);
    bloque.appendChild(cab);

    var cuerpo = crear("div", "quiz-cuerpo");

    if (q.tipo === "vf") {
      ["Verdadero", "Falso"].forEach(function (txt, i) {
        var val = i === 0;
        var lab = crear("label", "quiz-opcion");
        lab.innerHTML =
          "<input type='radio' name='q" + idx + "' value='" + val + "'> <span>" + txt + "</span>";
        cuerpo.appendChild(lab);
      });
    } else if (q.tipo === "unica") {
      q.opciones.forEach(function (txt, i) {
        var lab = crear("label", "quiz-opcion");
        lab.innerHTML =
          "<input type='radio' name='q" + idx + "' value='" + i + "'> <span>" + esc(txt) + "</span>";
        cuerpo.appendChild(lab);
      });
    } else if (q.tipo === "multiple") {
      q.opciones.forEach(function (txt, i) {
        var lab = crear("label", "quiz-opcion");
        lab.innerHTML =
          "<input type='checkbox' name='q" + idx + "' value='" + i + "'> <span>" + esc(txt) + "</span>";
        cuerpo.appendChild(lab);
      });
      cuerpo.appendChild(crear("p", "quiz-nota", "Marca todas las que correspondan."));
    } else if (q.tipo === "relacionar") {
      q.izquierda.forEach(function (txt, i) {
        var fila = crear("div", "quiz-relacion");
        var sel = "<select name='q" + idx + "' data-izq='" + i + "'>";
        sel += "<option value=''>— elegir —</option>";
        q.derecha.forEach(function (d, j) {
          sel += "<option value='" + j + "'>" + esc(d) + "</option>";
        });
        sel += "</select>";
        fila.innerHTML = "<span class='quiz-relacion-izq'>" + esc(txt) + "</span>" + sel;
        cuerpo.appendChild(fila);
      });
    }

    bloque.appendChild(cuerpo);

    if (modo !== "examen") {
      var acciones = crear("div", "quiz-acciones");
      var btn = crear("button", "quiz-btn", "Comprobar");
      btn.type = "button";
      acciones.appendChild(btn);
      bloque.appendChild(acciones);
    }

    var feedback = crear("div", "quiz-feedback");
    feedback.hidden = true;
    bloque.appendChild(feedback);

    if (modo !== "examen") {
      bloque.querySelector(".quiz-btn").addEventListener("click", function () {
        comprobar(q, idx, bloque, feedback);
      });
    }

    return bloque;
  }

  /* ---------- Recolección de respuestas ---------- */
  function recolectar(q, idx, bloque) {
    var respuestas = [];
    if (q.tipo === "relacionar") {
      bloque.querySelectorAll("select[data-izq]").forEach(function (s) {
        respuestas.push(s.value === "" ? null : Number(s.value));
      });
    } else if (q.tipo === "multiple") {
      bloque.querySelectorAll("input:checked").forEach(function (c) {
        respuestas.push(Number(c.value));
      });
    } else {
      var sel = bloque.querySelector("input:checked");
      respuestas.push(sel ? sel.value : null);
    }
    return respuestas;
  }

  function vacia(q, respuestas) {
    if (q.tipo === "relacionar") {
      return respuestas.every(function (r) { return r === null; });
    }
    return respuestas.length === 0 || respuestas.every(function (r) { return r === null; });
  }

  /* ---------- Evaluación ---------- */
  function esCorrecta(q, respuestas) {
    if (q.tipo === "vf") return respuestas[0] === String(q.resp);
    if (q.tipo === "unica") return Number(respuestas[0]) === q.resp;
    if (q.tipo === "multiple") {
      return respuestas.slice().sort().join(",") === q.resp.slice().sort().join(",");
    }
    if (q.tipo === "relacionar") {
      return respuestas.every(function (r, i) { return r === q.resp[String(i)]; });
    }
    return false;
  }

  function textoCorrecto(q) {
    if (q.tipo === "vf") return q.resp ? "Verdadero" : "Falso";
    if (q.tipo === "unica") return q.opciones[q.resp];
    if (q.tipo === "multiple") {
      return q.resp.slice().sort().map(function (i) { return q.opciones[i]; }).join(" · ");
    }
    if (q.tipo === "relacionar") {
      return q.izquierda
        .map(function (izq, i) { return izq + " → " + q.derecha[q.resp[String(i)]]; })
        .join(" · ");
    }
    return "";
  }

  function marcarFeedback(feedback, tipo, texto) {
    feedback.hidden = false;
    feedback.className = "quiz-feedback " + tipo;
    feedback.innerHTML = esc(texto);
  }

  /* ---------- Marcador de práctica ---------- */
  function actualizarMarcador(quiz, correcto) {
    var total = quiz.querySelectorAll(".quiz-pregunta").length;
    var el = quiz.querySelector(".quiz-marcador");
    if (!el) {
      el = crear("div", "quiz-marcador");
      quiz.appendChild(el);
    }
    quiz._aciertos = (quiz._aciertos || 0) + (correcto ? 1 : 0);
    quiz._respondidas = (quiz._respondidas || 0) + 1;
    el.textContent =
      "Acertadas: " + quiz._aciertos + " / " + total + " (respondidas: " + quiz._respondidas + ")";
  }

  /* ---------- Modo práctica ---------- */
  function comprobar(q, idx, bloque, feedback) {
    var respuestas = recolectar(q, idx, bloque);
    if (vacia(q, respuestas)) {
      marcarFeedback(feedback, "aviso", "Elige una respuesta antes de comprobar.");
      return;
    }
    var correcto = esCorrecta(q, respuestas);
    bloque.classList.add(correcto ? "bien" : "mal");
    bloque.querySelectorAll("input, select").forEach(function (el) { el.disabled = true; });
    var btn = bloque.querySelector(".quiz-btn");
    if (btn) btn.disabled = true;
    marcarFeedback(
      feedback,
      correcto ? "ok" : "no",
      (correcto ? "Correcto. " : "Incorrecto. ") + (q.explica || "")
    );
    if (bloque.dataset.contado !== "1") {
      bloque.dataset.contado = "1";
      actualizarMarcador(bloque.closest(".quiz"), correcto);
    }
  }

  /* ---------- Modo examen ---------- */
  function formatTiempo(seg) {
    var m = Math.floor(seg / 60);
    var s = seg % 60;
    return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
  }

  function entregarExamen(quiz, preguntas, temporizador) {
    if (quiz._entregado) return;
    quiz._entregado = true;
    if (temporizador) clearInterval(quiz._interval);
    if (temporizador) temporizador.classList.add("agotado");

    var aciertos = 0;
    var bloques = quiz.querySelectorAll(".quiz-pregunta");
    preguntas.forEach(function (q, i) {
      var bloque = bloques[i];
      if (!bloque) return;
      var respuestas = recolectar(q, i, bloque);
      var correcto = !vacia(q, respuestas) && esCorrecta(q, respuestas);
      if (correcto) aciertos++;
      bloque.classList.add(correcto ? "bien" : "mal");
      bloque.querySelectorAll("input, select").forEach(function (el) { el.disabled = true; });
      var feedback = bloque.querySelector(".quiz-feedback");
      var texto = correcto
        ? "Correcto. " + (q.explica || "")
        : "Incorrecto. Respuesta correcta: " + textoCorrecto(q) + ". " + (q.explica || "");
      marcarFeedback(feedback, correcto ? "ok" : "no", texto);
    });

    var total = preguntas.length;
    var nota = Math.round((aciertos / total) * 100);
    var veredicto;
    if (nota >= 85) veredicto = "Excelente. Estás listo.";
    else if (nota >= 70) veredicto = "Vas bien. Repasa las que fallaste y repite.";
    else if (nota >= 50) veredicto = "Zona de riesgo. Vuelve a las lecciones y al banco.";
    else veredicto = "Necesitas repasar el temario antes de otro simulacro.";

    var resultado = crear("div", "quiz-resultado");
    resultado.innerHTML =
      "<div class='quiz-nota'>" + nota + "<span>/100</span></div>" +
      "<div class='quiz-veredicto'>" + aciertos + " de " + total + " correctas · " + esc(veredicto) + "</div>";
    quiz.appendChild(resultado);

    var btn = quiz.querySelector(".quiz-entregar");
    if (btn) { btn.disabled = true; btn.textContent = "Examen entregado"; }
    resultado.scrollIntoView({ behavior: "smooth", block: "center" });
  }

  function montarExamen(quiz, preguntas) {
    var minutos = parseInt(quiz.dataset.minutos || "30", 10);
    quiz._entregado = false;

    var barra = crear("div", "quiz-barra");
    barra.innerHTML =
      "<span class='quiz-instruccion'>Responde todo y entrega al final. No hay pista por pregunta.</span>" +
      "<span class='quiz-reloj'>" + formatTiempo(minutos * 60) + "</span>";
    quiz.appendChild(barra);
    var reloj = barra.querySelector(".quiz-reloj");
    var restante = minutos * 60;

    preguntas.forEach(function (q, i) {
      quiz.appendChild(renderPregunta(q, i, "examen"));
    });

    var pie = crear("div", "quiz-pie-examen");
    var btn = crear("button", "quiz-btn quiz-entregar", "Entregar examen");
    btn.type = "button";
    btn.addEventListener("click", function () {
      entregarExamen(quiz, preguntas, reloj);
    });
    pie.appendChild(btn);
    quiz.appendChild(pie);

    quiz._interval = setInterval(function () {
      restante--;
      reloj.textContent = formatTiempo(Math.max(restante, 0));
      if (restante <= 60) reloj.classList.add("urgente");
      if (restante <= 0) entregarExamen(quiz, preguntas, reloj);
    }, 1000);
  }

  /* ---------- Montaje ---------- */
  function montar(quiz) {
    var data = quiz.nextElementSibling;
    while (data && !(data.tagName === "SCRIPT" && data.classList.contains("quiz-data"))) {
      data = data.nextElementSibling;
    }
    if (!data) return;
    var preguntas;
    try {
      preguntas = JSON.parse(data.textContent);
    } catch (e) {
      quiz.innerHTML = "<p class='quiz-error'>Error al cargar las preguntas.</p>";
      return;
    }
    if (quiz.hasAttribute("data-exam")) {
      montarExamen(quiz, preguntas);
    } else {
      preguntas.forEach(function (q, i) {
        quiz.appendChild(renderPregunta(q, i, "practica"));
      });
    }
  }

  function iniciar() {
    document.querySelectorAll("[data-quiz]").forEach(montar);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", iniciar);
  } else {
    iniciar();
  }
})();
