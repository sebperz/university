# OSINT y DMARC: recursos

## Knowledge

- [RFC 9989: DMARC](https://www.rfc-editor.org/rfc/rfc9989.html)
  Especificación vigente desde mayo de 2026. Reemplaza al RFC 7489. Fuente primaria para etiquetas, alineación y descubrimiento de política. Usar para: cualquier duda de sintaxis o comportamiento.
- [RFC 9990: DMARC Aggregate Reporting](https://www.rfc-editor.org/rfc/rfc9990.html)
  Formato y reglas de los informes agregados. Usar para: interpretar XML de `rua`.
- [RFC 9991: DMARC Failure Reporting](https://www.rfc-editor.org/rfc/rfc9991.html)
  Informes por mensaje fallido. Usar para: `ruf`, `fo` y privacidad de los reportes.
- [RFC 7208: SPF](https://www.rfc-editor.org/rfc/rfc7208.html)
  Especificación de SPF. Usar para: entender qué autentica SPF y por qué el sobre no coincide con el From.
- [RFC 6376: DKIM](https://www.rfc-editor.org/rfc/rfc6376.html)
  Especificación de DKIM. Usar para: firma, `d=`, canonicalización y límites.
- [Google: Email sender guidelines](https://support.google.com/a/answer/81126)
  Requisitos para enviar a Gmail. Desde febrero de 2024, los remitentes masivos necesitan SPF, DKIM y DMARC. Usar para: justificar por qué DMARC importa en la práctica.
- [ICANN: Registration Data Access Protocol](https://www.icann.org/en/contracted-parties/registry-operators/resources/registration-data-access-protocol)
  Qué es RDAP y cómo reemplaza a whois. Usar para: consultas de registro y redacción de datos.
- [theHarvester, README](https://github.com/laramies/theHarvester)
  Fuentes, clases P0/P1/P2 y uso responsable. Usar para: planear recolección pasiva y entender qué tráfico genera.
- [Shodan](https://www.shodan.io/) · [API](https://developer.shodan.io/api)
  Índice de servicios expuestos. Usar para: banners, puertos y filtros.
- [Censys, documentación](https://docs.censys.com/)
  Búsqueda de hosts y certificados. Usar para: contrastar Shodan y enumerar certificados.
- [dmarcian: DMARC Inspector](https://dmarcian.com/dmarc-inspector/)
  Validador de registros. Usar para: comprobar sintaxis antes de publicar.
- [dmarcian: Getting started with DMARC](https://dmarcian.com/getting-started-with-dmarc/)
  Guía práctica de despliegue por etapas. Usar para: ordenar la escalera none → quarantine → reject.
- [Maltego](https://www.maltego.com/)
  Análisis de vínculos y transforms. Usar para: grafo de entidades, nunca como fuente única.
- [Netcraft Site Report](https://sitereport.netcraft.com/)
  Hosting, tecnología e historial. Usar para: contexto de infraestructura.
- [BuiltWith](https://builtwith.com/)
  Perfil tecnológico de sitios. Usar para: CMS, frameworks, CDN y analytics.
- [Hunter.io](https://hunter.io/)
  Búsqueda y verificación de correos. Usar para: patrón de correo, con cuidado legal.
- [FOCA en GitHub](https://github.com/ElevenPaths/FOCA)
  Extracción de metadatos de documentos. Windows y SQL Server. Sin mantenimiento reciente. Usar para: entender la técnica; practicar con `exiftool`.
- [BIND 9: man pages](https://bind9.readthedocs.io/en/latest/manpages.html)
  Referencia de `dig`. Usar para: sintaxis de consultas y tipos de registro.
- [crt.sh](https://crt.sh/)
  Certificate transparency. Usar para: descubrir subdominios sin tocar el objetivo.

## Wisdom (Communities)

- [r/OSINT](https://www.reddit.com/r/OSINT/)
  Comunidad activa sobre técnicas y herramientas. Usar para: contrastar métodos y descubrir alternativas. Leer las reglas antes de publicar.
- [Information Security Stack Exchange](https://security.stackexchange.com/)
  Preguntas técnicas con respuestas moderadas. Usar para: dudas concretas de DNS, correo y OSINT.
- [IETF DMARC WG](https://datatracker.ietf.org/wg/dmarc/about/)
  Lista y archivos del grupo que mantiene el protocolo. Usar para: preguntas de implementación y cambios de estándar.
- [dmarcian Forum](https://forum.dmarcian.com/)
  Foro de operadores de correo y DMARC. Usar para: problemas reales de despliegue y reportes.
- Local: clase y horas de oficina del profesor del laboratorio.
  Usar para: validar alcance, dominio asignado y criterios de evaluación.

## Gaps

- Falta una buena introducción a DNS en español, gratuita y actualizada. Mientras tanto, `man dig` y la documentación de ICANN cubren lo necesario.
- No hay comunidad local confirmada fuera de la universidad. Pendiente preguntar por un grupo de seguridad en la facultad.
- Falta material verificado sobre interpretación de informes agregados con datos reales. Se cubrirá cuando haya dominio asignado.
