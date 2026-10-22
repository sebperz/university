# Glosario: OSINT y DMARC

Vocabulario canónico del curso. Todas las lecciones usan estos términos.

## Fundamentos

**Dominio**:
Nombre registrado que identifica un espacio en DNS, como `example.com`.
_Avoid_: página, host

**DNS**:
Base de datos distribuida y jerárquica que responde consultas sobre nombres y guarda direcciones, servidores de correo y políticas.
_Avoid_: directorio, guía telefónica

**Registro DNS**:
Entrada tipada dentro de DNS. El tipo define el dato: A para IPv4, MX para correo, TXT para texto, NS para nameservers.
_Avoid_: fila, entrada

**Subdominio**:
Nombre que cuelga de un dominio, como `mail.example.com`.
_Avoid_: alias

**Dominio organizacional**:
El dominio registrado bajo un sufijo público. Para `news.example.co.uk` es `example.co.uk`.
_Avoid_: dominio base, dominio raíz

**Lista de sufijos públicos (PSL)**:
Lista que distingue qué parte de un nombre se puede registrar, para que `co.uk` no se confunda con un dominio organizacional.
_Avoid_: lista de TLD

**RDAP**:
Protocolo de consulta de registro que devuelve JSON y sustituye a whois en la práctica.
_Avoid_: whois 2.0

**Whois**:
Consulta de texto sobre el registro de un dominio o una IP. Muchos datos personales aparecen redactados.
_Avoid_: RDAP

**Registro TXT**:
Registro DNS de texto libre donde viven SPF, DMARC y verificaciones de servicios.
_Avoid_: metadata

**Registro MX**:
Registro que indica qué servidores reciben correo y con qué prioridad. Menor número, mayor preferencia.
_Avoid_: servidor de correo

## Correo

**SMTP**:
Protocolo que transporta correo entre servidores y no verifica por sí solo que el remitente controle el dominio que escribe.
_Avoid_: protocolo de correo seguro

**From (RFC5322.From)**:
Cabecera que el usuario ve como remitente. Es el identificador central de DMARC.
_Avoid_: remitente, autor

**MAIL FROM**:
Remitente del sobre SMTP, casi nunca visible. SPF autentica este dominio, no el From.
_Avoid_: From

**SPF**:
Registro TXT que enumera qué IPs pueden enviar correo para un dominio. Autentica el dominio del sobre.
_Avoid_: lista blanca de correo

**DKIM**:
Firma criptográfica del mensaje que declara un dominio firmante en `d=` y detecta cambios en tránsito.
_Avoid_: cifrado de correo

**Alineación**:
Condición de que el dominio autenticado por SPF o DKIM coincida con el dominio del From.
_Avoid_: coincidencia, match

**DMARC**:
Política publicada en DNS que indica qué hacer con el correo que usa un dominio en el From y no pasa SPF o DKIM alineados, y dónde enviar informes.
_Avoid_: antispam, firewall de correo

**Política DMARC**:
Valor de `p`, `sp` o `np`: `none`, `quarantine` o `reject`. Es una preferencia, no una orden absoluta.
_Avoid_: regla, bloqueo

**p**:
Política para el dominio del From. Si falta, se trata como `none`.

**sp**:
Política para subdominios existentes. No aplica al dominio raíz.

**np**:
Política para subdominios inexistentes. Nueva en RFC 9989. Si falta, se usa `sp` o `p`.

**rua**:
Dirección que recibe informes agregados. Sin `rua`, el dominio no recibe reportes.

**ruf**:
Dirección que recibe informes por mensaje fallido. Más detalle y más exposición de datos personales.

**Informe agregado**:
Resumen periódico, normalmente XML comprimido, con IPs, dominios y resultados de autenticación. Definido en RFC 9990.

**Informe de fallo**:
Reporte de un mensaje concreto que falló. Puede incluir cabeceras y datos del mensaje. Definido en RFC 9991.

**Spoofing exacto**:
Uso no autorizado del dominio exacto en el From. Es lo que DMARC puede frenar.
_Avoid_: phishing (es más amplio)

**Dominio primo**:
Dominio visualmente parecido al legítimo, como `tu-banco.co` frente a `tu-banco.com`. DMARC no lo cubre.
_Avoid_: dominio falso

## OSINT

**OSINT**:
Inteligencia obtenida de fuentes públicas, sin credenciales ni explotación.
_Avoid_: hacking, espionaje

**Reconocimiento pasivo**:
Consulta de fuentes y registros existentes sin enviar tráfico al objetivo.
_Avoid_: reconocimiento invisible

**Reconocimiento activo**:
Interacción directa con la infraestructura del objetivo. Requiere autorización.
_Avoid_: escaneo pasivo

**Banner**:
Respuesta inicial de un servicio que revela software, versión o configuración.
_Avoid_: cabecera

**Fingerprinting**:
Identificación de la tecnología de un sitio o servidor a partir de cabeceras, cookies, rutas y comportamiento.
_Avoid_: huella digital

**Metadatos**:
Datos dentro de un archivo que no se ven al abrirlo: autor, software, ruta, fechas, usuarios.
_Avoid_: información oculta

**Certificate transparency**:
Registro público de certificados TLS emitidos, útil para descubrir subdominios.
_Avoid_: registro de certificados
