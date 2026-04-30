document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('inscripcion-form');
  const successMsg = document.getElementById('success-message');

  const validators = {
    apellidos: v => {
      if (v.length === 0) return "Campo Obligatorio";
      if (v.length > 50) return "Longitud excedida (máximo 50 caracteres)";
      return null;
    },
    nombres: v => {
      if (v.length === 0) return "Campo Obligatorio";
      if (v.length > 50) return "Longitud excedida (máximo 50 caracteres)";
      return null;
    },
    correo: v => {
      if (v.length === 0) return "Campo Obligatorio";
      if (v.length > 50) return "Longitud excedida (máximo 50 caracteres)";
      return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) ? null : "Correo electrónico inválido";
    },
    telefono: v => {
      if (v.length === 0) return "Campo Obligatorio";
      if (v.length > 50) return "Longitud excedida (máximo 50 caracteres)";
      return null;
    },
    comentarios: v => {
      if (v.length > 200) return "Longitud excedida (máximo 200 caracteres)";
      return null;
    }
  };

  const comentariosEl = document.getElementById('comentarios');
  const counterEl = document.getElementById('comentarios-counter');

  const updateCounter = () => {
    const len = comentariosEl.value.length;
    counterEl.textContent = `${len}/200`;
    counterEl.style.color = len > 200 ? '#D32F2F' : '#9E9E9E';
  };

  comentariosEl.addEventListener('input', updateCounter);
  updateCounter();

  const showError = (field, msg) => {
    const el = document.getElementById(`error-${field}`);
    el.textContent = msg;
    el.classList.add('show');
  };

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    let valid = true;

    document.querySelectorAll('.error-message').forEach(el => {
      el.textContent = '';
      el.classList.remove('show');
    });
    successMsg.classList.remove('show');

    Object.keys(validators).forEach(field => {
      const input = document.getElementById(field);
      const error = validators[field](input.value.trim());
      if (error) { showError(field, error); valid = false; }
    });

    if (!valid) return;

    const data = {
      apellidos: document.getElementById('apellidos').value.trim(),
      nombres: document.getElementById('nombres').value.trim(),
      correo: document.getElementById('correo').value.trim(),
      telefono: document.getElementById('telefono').value.trim(),
      programa: document.getElementById('programa').value,
      jornada: document.getElementById('jornada').value,
      comentarios: document.getElementById('comentarios').value.trim(),
      timestamp: new Date().toISOString()
    };

    try {
      const res = await fetch('http://localhost:3000/inscripciones', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      if (res.ok) {
        successMsg.textContent = '¡Inscripción enviada con éxito!';
        successMsg.classList.add('show');
        form.reset();
        updateCounter();
      } else throw new Error();
    } catch {
      showError('correo', 'Error de conexión. Verifique que json-server esté ejecutándose.');
    }
  });
});
