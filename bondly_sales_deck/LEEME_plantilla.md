# Bondly · Sales Deck + Plantilla reutilizable

Deck comercial B2B (19 slides, español, calidad "keynote") para vender Bondly a
empresas. Diseñado como **plantilla reutilizable** para cualquier press/pitch futuro.

- **`Bondly_Sales_Deck.pptx`** — el deck final, editable en PowerPoint / Keynote / Google Slides.
- **`plantilla/`** — el generador (código + assets) para volver a producirlo o crear variantes.

---

## 1. Qué contiene el deck (arco narrativo)

1. Portada · 2. El problema (rotación) · 3. El costo oculto · 4. El reconocimiento como palanca ·
5. Hoy está roto (Excel/WhatsApp) · 6. Conoce Bondly (reveal) · 7. Cómo funciona (3 pasos) ·
8. Reconocer · 9. Feed social · 10. Economía de puntos · 11. Recompensas · 12. Actividad y gamificación ·
13. Panel de administración · 14. Bondly IA · 15. Por qué Bondly · 16. Para quién es (ICP) ·
17. Resultados + prueba social · 18. Expansiones (base + a medida) · 19. Cierre / CTA.

Cada slide lleva **notas del presentador** (habla-por-habla) para hacer la demo. En PowerPoint:
*Ver → Notas* o *Vista de moderador*.

## 2. ICP (definido en el deck)

Empresas **de 50 a 500 empleados en México**, en crecimiento y formalizando RRHH, con fuerza
distribuida (frontline / híbrida / multi-sucursal). Sectores de mayor necesidad: retail, BPO/call
centers, manufactura, logística, servicios y tech. **Comprador:** Dirección / Gerencia de RRHH,
Cultura, Talento o Experiencia del Colaborador.

## 3. Datos y fuentes (todo citado, nada inventado)

- 7 de cada 10 profesionales en México consideraban un cambio de empleo (2024) — **OCC Mundial**.
- Cubrir cada vacante cuesta 50–200% del salario anual — **SHRM**.
- ~9% del PIB mundial (US$8.9 B) se pierde por bajo compromiso — **Gallup, State of the Global Workplace 2024**.
- Hasta 45% de la rotación voluntaria es prevenible con buen reconocimiento — **Workhuman + Gallup, 2024**.
- 9× más probabilidad de compromiso con reconocimiento de calidad; 88–98% vs 37% por frecuencia — **Gallup, 2024**.

> Las cifras del slide 17 (−45%, 9×, 100%) son **datos de mercado**, NO resultados de clientes de Bondly.
> Reemplaza los `[ Logo ]` / `[ Testimonio ]` por pruebas reales cuando las tengas.

## 4. Placeholders a completar antes de enviar

- Portada: `[ Nombre del cliente ]`
- Slide 17: testimonio, nombre/puesto/empresa y 3 logos de cliente
- Slide 19 (CTA): `[ correo ]` y `[ teléfono ]` (el dominio `bondly.mx` ya está puesto)

## 5. Notas de honestidad (para no sobre-prometer en la demo)

- **Backend:** hoy corre sobre **Supabase**; el REST anterior (`api.bondly.mx`) quedó latente.
- **IA:** las 3 funciones (feed personalizado, sentimiento, recomendaciones) **están integradas y activas**.
- **Slide 18 – columna derecha ("a la medida"):** SSO/HRIS, Slack/Teams, multi-empresa/multi-moneda,
  API/webhooks y white-label son **desarrollo a medida / roadmap**, no funciones ya activas. El producto
  es hoy **single-tenant** (una empresa por instancia). Preséntalas como "lo construimos para ti".

## 6. Assets usados

- **Logo:** `assets/img_logo.png` (de la app). **Colores:** tomados de `lib/config/colors.dart`
  (morado `#7C3AED` → rosa `#EC4899`, acento `#9B7FFF`, oro `#FFD648`). **Tipografía:** Montserrat
  (fuente de marca — instálala para el render exacto; si no, PowerPoint sustituye sin romper el layout).
- **Screenshots:** limpiados (se recortó la barra de estado y el listón "DEBUG") y enmarcados en un
  mockup de teléfono con glow de marca. Fuente: tu carpeta de capturas.

---

## 7. Cómo regenerar / crear una nueva versión

Requiere Node.js. Desde `plantilla/`:

```bash
npm install pptxgenjs react-icons react react-dom sharp   # una sola vez
python3 assets.py     # (opcional) regenera fondos/gradiente
python3 frame.py      # (opcional) reenmarca screenshots de assets/raw → assets/dev
node icons.js         # (opcional) regenera iconos
node build.js         # genera Bondly_Sales_Deck.pptx
```

Para **editar contenido**: abre `build.js`. Los colores viven en el objeto `THEME` (`T`), y cada slide
es un bloque claramente comentado. Cambia textos, cifras o reordena slides ahí y vuelve a correr `node build.js`.
Para cambiar screenshots: pon los PNG nuevos en `assets/raw/`, ajusta los nombres en `frame.py` y `build.js`, y re-corre.

> El deck ya se puede editar directo en PowerPoint; el generador es para cambios de marca a gran escala
> o para producir varias versiones (por sector, por cliente) de forma consistente.
