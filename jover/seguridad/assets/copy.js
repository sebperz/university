document.querySelectorAll("pre[data-copy]").forEach((pre) => {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "copy";
  button.textContent = "copiar";
  button.setAttribute("aria-label", "Copiar comando");

  button.addEventListener("click", async () => {
    const text = pre.dataset.copy;
    try {
      await navigator.clipboard.writeText(text);
    } catch {
      const area = document.createElement("textarea");
      area.value = text;
      area.style.position = "fixed";
      area.style.opacity = "0";
      document.body.appendChild(area);
      area.select();
      document.execCommand("copy");
      area.remove();
    }
    button.textContent = "copiado";
    button.classList.add("done");
    setTimeout(() => {
      button.textContent = "copiar";
      button.classList.remove("done");
    }, 1600);
  });

  pre.appendChild(button);
});
