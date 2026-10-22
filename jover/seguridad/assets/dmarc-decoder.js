const TAGS = {
  v: "Versión del registro. Debe ser DMARC1 y ocupar el primer lugar; si no, los receptores ignoran todo el registro.",
  p: "Política para el dominio. none no pide nada, quarantine manda a spam o marca como sospechoso, reject rechaza.",
  sp: "Política para subdominios existentes. Si falta, heredan la de p.",
  np: "Política para subdominios que no existen. Si falta, se usa sp o p. Es nueva en el RFC 9989.",
  adkim: "Alineación DKIM. r es relajada, compara el dominio organizacional. s es estricta, exige el mismo nombre.",
  aspf: "Alineación SPF. r es relajada, s es estricta.",
  rua: "Direcciones que reciben informes agregados, normalmente un correo diario en XML comprimido.",
  ruf: "Direcciones que reciben informes por mensaje fallido. Revelan datos del mensaje; úsalo con cuidado.",
  fo: "Cuándo generar informes de fallo. 0 solo si fallan todos los mecanismos, 1 si falla cualquiera, d y s por tecnología.",
  pct: "Porcentaje de mensajes a los que aplicar la política. El RFC 9989 eliminó esta etiqueta; si aparece, es legado.",
  t: "Modo de prueba. t=y pide no aplicar la política todavía, un escalón por debajo de la declarada.",
  psd: "Marca de dominio de sufijo público. Casi ningún dominio normal lo necesita."
};

const POLICY = {
  none: "No se pide acción sobre el correo que falla. Sirve para observar.",
  quarantine: "El correo que falla se trata como sospechoso: spam o marca visible.",
  reject: "El correo que falla se rechaza. Es la política más estricta."
};

function escapeHtml(value) {
  return value.replace(/[&<>"']/g, (char) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;"
  })[char]);
}

function parseRecord(raw) {
  const clean = raw.replace(/[\r\n]+/g, " ").replace(/"/g, " ").trim();
  const parts = clean.split(";").map((part) => part.trim()).filter(Boolean);
  return parts.map((part) => {
    const index = part.indexOf("=");
    if (index === -1) return { key: part.toLowerCase(), value: "" };
    return {
      key: part.slice(0, index).trim().toLowerCase(),
      value: part.slice(index + 1).trim()
    };
  });
}

document.querySelectorAll("[data-decoder]").forEach((box) => {
  const input = box.querySelector("textarea");
  const button = box.querySelector("button");
  const out = box.querySelector(".decoder__out");

  const render = () => {
    const tags = parseRecord(input.value);
    if (!tags.length) {
      out.innerHTML = "<p>Pega un registro primero.</p>";
      return;
    }

    const first = tags[0];
    const map = Object.fromEntries(tags.map((tag) => [tag.key, tag.value]));
    let verdictClass = "bad";
    let verdictText = "Registro inválido";

    if (first.key === "v" && first.value === "DMARC1") {
      const policy = (map.p || "").toLowerCase();
      const hasRua = Boolean(map.rua);
      const legacyPct = map.pct !== undefined && map.pct !== "100";

      if (!map.p) {
        verdictClass = "mid";
        verdictText = "Sin p, se trata como p=none";
      } else if (policy === "reject") {
        verdictClass = "ok";
        verdictText = "Protección fuerte: reject";
      } else if (policy === "quarantine") {
        verdictClass = "mid";
        verdictText = "Protección parcial: quarantine";
      } else if (policy === "none") {
        verdictClass = hasRua ? "mid" : "bad";
        verdictText = hasRua ? "Monitoreo: none con informes" : "none sin rua: no protege ni observa";
      } else {
        verdictClass = "bad";
        verdictText = "Valor de p no reconocido";
      }

      if (legacyPct) {
        verdictText += " · pct legado";
      }
    } else if (first.key === "v" && first.value !== "DMARC1") {
      verdictText = "Versión distinta de DMARC1";
    } else {
      verdictText = "Falta v=DMARC1 al inicio";
    }

    const rows = tags.map(({ key, value }) => {
      const meaning = TAGS[key] || "Etiqueta desconocida. El RFC pide ignorarla, no romper el registro.";
      const shown = value || "(vacío)";
      return "<tr><td><span class=\"tag\">" + escapeHtml(key) + "</span></td><td><code>" +
        escapeHtml(shown) + "</code><br>" + escapeHtml(meaning) + "</td></tr>";
    }).join("");

    let extra = "";
    if (map.p && POLICY[map.p.toLowerCase()]) {
      extra = "<p><strong>Qué pasa con un correo falsificado:</strong> " + escapeHtml(POLICY[map.p.toLowerCase()]) + "</p>";
    }
    if (map.rua) {
      extra += "<p><strong>Quién recibe los informes:</strong> " + escapeHtml(map.rua) + ". Revisa que ese buzón sea tuyo o de un servicio en el que confíes.</p>";
    }
    if (map.pct && map.pct !== "100") {
      extra += "<p><strong>Aviso:</strong> pct=" + escapeHtml(map.pct) + " es sintaxis antigua. El RFC 9989 la eliminó; algunos receptores todavía la respetan.</p>";
    }

    out.innerHTML =
      "<span class=\"verdict " + verdictClass + "\">" + escapeHtml(verdictText) + "</span>" +
      "<p class=\"quiz__intro\">Se publica en <code>_dmarc.tudominio</code> como registro TXT. Para leerlo desde una terminal: <code>dig +short TXT _dmarc.tudominio</code></p>" +
      "<table><tbody>" + rows + "</tbody></table>" +
      extra;
  };

  button.addEventListener("click", render);
  input.addEventListener("keydown", (event) => {
    if ((event.metaKey || event.ctrlKey) && event.key === "Enter") render();
  });
});
