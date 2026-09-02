/* ============================================================================
   BONDLY — PLANTILLA DE PRESENTACIÓN (Press / Sales Deck)
   Reutilizable: edita el objeto CONTENT o cambia THEME / assets y re-genera.
   node build.js  ->  Bondly_Sales_Deck.pptx
   ============================================================================ */
const pptxgen = require("pptxgenjs");
const pres = new pptxgen();
pres.defineLayout({ name: "W", width: 13.333, height: 7.5 });
pres.layout = "W";
pres.author = "Bondly";
pres.title = "Bondly — Presentación comercial";

const PW = 13.333, PH = 7.5;

/* ---- THEME (marca Bondly, tomada de lib/config/colors.dart) ------------- */
const T = {
  ink:   "FFFFFF",
  sub:   "C9C9D8",
  mute:  "8E8EA6",
  faint: "6B6B80",
  acc:   "9B7FFF",   // darkAccent
  accStrong: "7C3AED",
  pink:  "EC4899",   // accentGradientEnd
  gold:  "FFD648",
  like:  "FF4D6A",
  green: "10B981",
  blue:  "3B82F6",
  amber: "F59E0B",
  card:  "17171F",
  cardHi:"1E1B2E",
  border:"33324C",
  FONT:  "Montserrat",
  FONTB: "Montserrat",
};
const A = {
  bgDark: "assets/gen/bg_dark.png",
  bgCover:"assets/gen/bg_cover.png",
  logo:   "assets/img/img_logo.png",
  mark:   "assets/img/icon.png",
  dev: (n)=>`assets/dev/${n}_dev.png`,
  ic:  (n)=>`assets/ic/${n}.png`,
};
const DEV_R = 1432/2630; // ancho/alto del mockup

/* ---- helpers ------------------------------------------------------------ */
const shadow = () => ({ type:"outer", color:"000000", blur:14, offset:4, angle:90, opacity:0.45 });
function bg(slide, cover){ slide.background = { path: cover ? A.bgCover : A.bgDark }; }

function kicker(slide, txt, x=0.85, y=0.72, color=T.acc){
  slide.addText(txt.toUpperCase(), { x, y, w:9.5, h:0.3, margin:0, fontFace:T.FONTB,
    fontSize:12.5, bold:true, color, charSpacing:3, align:"left" });
}
function title(slide, runs, x=0.85, y=1.12, w=9.0, size=31){
  const arr = (typeof runs==="string") ? [{text:runs}] : runs;
  slide.addText(arr.map(r=>({text:r.text, options:{color:r.c||T.ink, bold:true}})),
    { x, y, w, h:1.15, margin:0, fontFace:T.FONTB, fontSize:size, align:"left", valign:"top", lineSpacingMultiple:1.02 });
}
function footer(slide, n){
  slide.addImage({ path:A.mark, x:0.85, y:7.03, w:0.24, h:0.24 });
  slide.addText("Bondly", { x:1.15, y:7.0, w:2, h:0.3, margin:0, fontFace:T.FONTB, fontSize:10, color:T.mute, valign:"middle" });
  slide.addText(String(n).padStart(2,"0")+" / 19", { x:PW-2.35, y:7.0, w:1.5, h:0.3, margin:0,
    fontFace:T.FONT, fontSize:10, color:T.mute, align:"right", valign:"middle" });
}
function card(slide, x,y,w,h, fill=T.card){
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x,y,w,h, rectRadius:0.12,
    fill:{color:fill}, line:{color:T.border, width:1}, shadow:shadow() });
}
function circleIcon(slide, x,y,d, name, fill, scale=0.5){
  slide.addShape(pres.shapes.OVAL, { x,y,w:d,h:d, fill:{color:fill} });
  const id=d*scale;
  slide.addImage({ path:A.ic(name), x:x+(d-id)/2, y:y+(d-id)/2, w:id, h:id });
}
function phone(slide, n, h, opts={}){
  const w=h*DEV_R;
  const x = opts.x!==undefined ? opts.x : (PW - w - (opts.pad!==undefined?opts.pad:0.7));
  const y = opts.y!==undefined ? opts.y : (PH - h)/2;
  slide.addImage({ path:A.dev(n), x, y, w, h });
  return {x,y,w,h};
}
// filas icono + título + subtítulo (columna izquierda junto a un mockup)
function iconRows(slide, rows, x, yStart, colW, step){
  rows.forEach((r,i)=>{
    const y=yStart+i*step;
    circleIcon(slide, x, y, 0.62, r.icon, r.fill||T.accStrong, 0.5);
    slide.addText(r.h, { x:x+0.85, y:y-0.05, w:colW-0.85, h:0.4, margin:0, fontFace:T.FONTB, fontSize:16.5, bold:true, color:T.ink, valign:"middle" });
    slide.addText(r.s, { x:x+0.85, y:y+0.36, w:colW-0.85, h:0.62, margin:0, fontFace:T.FONT, fontSize:12.5, color:T.sub, valign:"top", lineSpacingMultiple:1.02 });
  });
}
function sources(slide, txt){
  slide.addText("Fuentes: "+txt, { x:0.85, y:6.62, w:11.6, h:0.3, margin:0, fontFace:T.FONT, fontSize:9.5, italic:true, color:T.faint, align:"left" });
}

/* ======================================================================= */
/* 1 — PORTADA                                                             */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s,true);
  s.addText("PLATAFORMA DE RECONOCIMIENTO Y RECOMPENSAS", { x:0, y:2.02, w:PW, h:0.35, margin:0,
    fontFace:T.FONTB, fontSize:13, bold:true, color:T.acc, charSpacing:4, align:"center" });
  const lw=4.5, lh=lw*(338/800);
  s.addImage({ path:A.logo, x:(PW-lw)/2, y:2.5, w:lw, h:lh });
  s.addText("Convierte el reconocimiento entre tu equipo en una ventaja de retención — medible, social y móvil.",
    { x:2.4, y:4.35, w:PW-4.8, h:0.9, margin:0, fontFace:T.FONT, fontSize:16.5, color:T.sub, align:"center", lineSpacingMultiple:1.12 });
  s.addText([
    {text:"Presentación comercial", options:{color:T.ink}},
    {text:"      ·      ", options:{color:T.faint}},
    {text:"[ Nombre del cliente ]", options:{color:T.mute}},
  ], { x:0, y:5.75, w:PW, h:0.35, margin:0, fontFace:T.FONT, fontSize:12.5, align:"center" });
  s.addNotes("Portada. Preséntate y nombra a la empresa. Frase de apertura: 'En los próximos 10 minutos les muestro cómo Bondly convierte el reconocimiento diario en menos rotación y en datos que RRHH puede presentar a dirección.' Reemplaza [Nombre del cliente].");
})();

/* ======================================================================= */
/* 2 — EL PROBLEMA                                                         */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,2);
  kicker(s,"El problema");
  title(s,[{text:"La gente se va — y cada salida "},{text:"cuesta caro.",c:T.pink}]);
  // gran stat
  s.addText("7 de 10", { x:0.85, y:2.75, w:5.2, h:1.4, margin:0, fontFace:T.FONTB, fontSize:88, bold:true, color:T.pink, align:"left" });
  s.addText("profesionales en México consideraban un cambio de empleo en 2024.",
    { x:0.9, y:4.15, w:5.0, h:1.3, margin:0, fontFace:T.FONT, fontSize:17, color:T.sub, lineSpacingMultiple:1.12 });
  // panel derecho: dolores
  card(s, 6.7, 2.55, 5.75, 3.7);
  s.addText("El reto #1 de RRHH hoy", { x:7.05, y:2.8, w:5.1, h:0.4, margin:0, fontFace:T.FONTB, fontSize:16, bold:true, color:T.ink });
  const rows=[
    {icon:"fire", h:"Rotación alta", s:"Sobre todo en operación y primera línea."},
    {icon:"heart", h:"Desconexión", s:"Equipos remotos, híbridos y multi-sucursal sin sentido de pertenencia."},
    {icon:"eye", h:"Cultura invisible", s:"La dirección no ve —ni puede medir— lo que pasa en el día a día."},
  ];
  iconRows(s, rows, 7.05, 3.42, 5.1, 0.92);
  sources(s,"OCC Mundial, 2024.");
  s.addNotes("Ancla el reto en la rotación, el disparador de compra #1 en México. Pregunta al prospecto: '¿cuál es su rotación anual hoy?'. Deja que el 7 de 10 respire antes de pasar al costo.");
})();

/* ======================================================================= */
/* 3 — EL COSTO OCULTO                                                     */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,3);
  kicker(s,"El costo");
  title(s,[{text:"Cada salida se paga "},{text:"dos veces.",c:T.pink}]);
  const box=(x,ic,icf,num,numc,lab)=>{
    card(s,x,2.7,5.55,3.35);
    circleIcon(s,x+0.4,3.05,0.7,ic,icf,0.5);
    s.addText(num,{x:x+0.35,y:3.95,w:4.9,h:1.0,margin:0,fontFace:T.FONTB,fontSize:60,bold:true,color:numc});
    s.addText(lab,{x:x+0.4,y:5.05,w:4.8,h:0.85,margin:0,fontFace:T.FONT,fontSize:14.5,color:T.sub,lineSpacingMultiple:1.08});
  };
  box(0.85,"coins",T.accStrong,"50–200%",T.acc,"del salario anual cuesta cubrir cada vacante.");
  box(6.93,"chartline",T.pink,"≈ 9%",T.pink,"del PIB mundial se pierde por bajo compromiso (US$8.9 billones/año).");
  sources(s,"SHRM; Gallup, State of the Global Workplace 2024.");
  s.addNotes("Traduce el problema a dinero. El 50–200% suele sorprender: incluye reclutamiento, capacitación, curva de productividad y conocimiento perdido. Conecta: 'lo que se va en rotación es presupuesto que hoy no ven'.");
})();

/* ======================================================================= */
/* 4 — LA PALANCA                                                          */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,4);
  kicker(s,"La oportunidad");
  title(s,[{text:"El reconocimiento es la palanca más "},{text:"rentable",c:T.acc},{text:" de RRHH."}]);
  const stat=(x,num,numc,lab)=>{
    s.addText(num,{x,y:2.78,w:5.7,h:1.0,margin:0,fontFace:T.FONTB,fontSize:56,bold:true,color:numc});
    s.addText(lab,{x:x+0.05,y:3.86,w:5.45,h:1.1,margin:0,fontFace:T.FONT,fontSize:15,color:T.sub,lineSpacingMultiple:1.1});
  };
  stat(0.85,"hasta 45%",T.acc,"de la rotación voluntaria se puede prevenir con buen reconocimiento.");
  stat(6.9,"9×",T.pink,"más probabilidad de estar comprometidos entre quienes reciben reconocimiento de calidad.");
  // franja frecuencia
  card(s,0.85,5.2,11.6,1.05,T.cardHi);
  circleIcon(s,1.15,5.42,0.6,"calendar",T.accStrong,0.5);
  s.addText([
    {text:"La frecuencia lo es todo:  ",options:{bold:true,color:T.ink}},
    {text:"88–98% ",options:{bold:true,color:T.acc}},
    {text:"de los colaboradores se sienten valorados con reconocimiento frecuente, vs. ",options:{color:T.sub}},
    {text:"37% ",options:{bold:true,color:T.pink}},
    {text:"con feedback solo anual.",options:{color:T.sub}},
  ],{x:1.95,y:5.2,w:10.3,h:1.05,margin:0,fontFace:T.FONT,fontSize:14,valign:"middle",lineSpacingMultiple:1.05});
  sources(s,"Workhuman + Gallup, 2024; Gallup, Employee Retention (2024).");
  s.addNotes("El giro de la historia: el reconocimiento no es un 'nice to have', es la intervención de retención más barata. Enfatiza frecuencia: por eso una app de uso diario gana a un evento anual.");
})();

/* ======================================================================= */
/* 5 — HOY ESTÁ ROTO                                                       */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,5);
  kicker(s,"La realidad hoy");
  title(s,[{text:"Pero el reconocimiento sigue viviendo en "},{text:"Excel y WhatsApp.",c:T.pink}]);
  const items=[
    {icon:"clock", h:"Esporádico", s:"Un ‘empleado del mes’ no mueve la aguja del compromiso."},
    {icon:"users", h:"Inequitativo", s:"Siempre se reconoce a los mismos; el resto queda invisible."},
    {icon:"eye", h:"Invisible", s:"La dirección no ve la cultura ni el esfuerzo cotidiano."},
    {icon:"chartbar", h:"Sin datos", s:"Imposible medir participación, impacto o retorno."},
  ];
  const cw=5.75, ch=1.72, gx=0.85, gy=2.75, gapx=0.1, gapy=0.25;
  items.forEach((it,i)=>{
    const x=gx+(i%2)*(cw+gapx), y=gy+Math.floor(i/2)*(ch+gapy);
    card(s,x,y,cw,ch);
    circleIcon(s,x+0.35,y+0.35,0.62,it.icon,T.accStrong,0.5);
    s.addText(it.h,{x:x+1.15,y:y+0.28,w:cw-1.4,h:0.4,margin:0,fontFace:T.FONTB,fontSize:17,bold:true,color:T.ink,valign:"middle"});
    s.addText(it.s,{x:x+1.15,y:y+0.78,w:cw-1.45,h:0.8,margin:0,fontFace:T.FONT,fontSize:13,color:T.sub,lineSpacingMultiple:1.05});
  });
  s.addNotes("Nombra el status quo del prospecto (seguramente hacen algo de esto). Estos 4 problemas son exactamente lo que Bondly resuelve — cada uno reaparece como beneficio más adelante.");
})();

/* ======================================================================= */
/* 6 — CONOCE BONDLY (reveal)                                              */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s,true); footer(s,6);
  const lw=2.35, lh=lw*(338/800);
  s.addImage({ path:A.logo, x:0.85, y:0.85, w:lw, h:lh });
  title(s,[{text:"Convierte el reconocimiento en un "},{text:"hábito diario",c:T.acc},{text:" — y en datos."}],0.85,2.15,8.1,33);
  s.addText("De reconocimiento manual e invisible  →  a una cultura medible, social y móvil que tu equipo quiere usar.",
    {x:0.85,y:3.55,w:8.0,h:1.1,margin:0,fontFace:T.FONT,fontSize:17,color:T.sub,lineSpacingMultiple:1.15});
  const chips=["Reconocer","Feed","Recompensas","Ranking","Panel admin"];
  let cx=0.85;
  chips.forEach(c=>{
    const w=0.42+c.length*0.11;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:cx,y:4.95,w,h:0.5,rectRadius:0.25,fill:{color:T.cardHi},line:{color:T.border,width:1}});
    s.addText(c,{x:cx,y:4.95,w,h:0.5,margin:0,fontFace:T.FONTB,fontSize:12,bold:true,color:T.sub,align:"center",valign:"middle"});
    cx+=w+0.18;
  });
  phone(s,"1000048434",6.6,{x:9.35,y:0.45});
  s.addNotes("El pivote. Aquí revelas el producto. Sostén el mockup de 'Reconocer' — es el corazón del producto. Frase: 'Esto es lo que ve tu equipo cada mañana'.");
})();

/* ======================================================================= */
/* 7 — CÓMO FUNCIONA                                                       */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,7);
  kicker(s,"Cómo funciona");
  title(s,[{text:"Un ciclo simple que la gente "},{text:"quiere repetir.",c:T.acc}]);
  const steps=[
    {n:"1",icon:"award",c:T.accStrong,h:"Reconoce",s:"Elige una insignia, a un compañero y escribe por qué lo reconoces."},
    {n:"2",icon:"comments",c:T.pink,h:"Se hace social",s:"El reconocimiento aparece en el feed: likes, comentarios y @menciones."},
    {n:"3",icon:"gift",c:T.green,h:"Canjea",s:"Los puntos acumulados se cambian por recompensas reales."},
  ];
  const cw=3.72, gy=2.65, ch=3.35; let x=0.85;
  steps.forEach((st,i)=>{
    card(s,x,gy,cw,ch);
    circleIcon(s,x+0.4,gy+0.45,0.95,st.icon,st.c,0.5);
    s.addText(st.n,{x:x+cw-1.05,y:gy+0.35,w:0.8,h:0.9,margin:0,fontFace:T.FONTB,fontSize:44,bold:true,color:T.border,align:"right"});
    s.addText(st.h,{x:x+0.4,y:gy+1.65,w:cw-0.8,h:0.5,margin:0,fontFace:T.FONTB,fontSize:20,bold:true,color:T.ink});
    s.addText(st.s,{x:x+0.4,y:gy+2.2,w:cw-0.75,h:1.0,margin:0,fontFace:T.FONT,fontSize:13.5,color:T.sub,lineSpacingMultiple:1.1});
    if(i<2){ s.addImage({path:A.ic("arrow"),x:x+cw+0.04,y:gy+ch/2-0.16,w:0.32,h:0.32}); }
    x+=cw+0.4;
  });
  s.addNotes("Muestra la mecánica de un vistazo: dar → socializar → canjear. Es el loop de engagement. Recalca que reconocer toma segundos y que el que recibe gana puntos canjeables — el incentivo tangible que impulsa la adopción.");
})();

/* ---- generador de slides de producto (mockup a la derecha) ------------- */
function productSlide(n, kick, ttl, rows, dev){
  const s=pres.addSlide(); bg(s); footer(s,n);
  kicker(s,kick);
  title(s,ttl,0.85,1.12,8.3,30);
  iconRows(s, rows, 0.9, 2.55, 8.0, 1.05);
  phone(s,dev,6.15,{x:9.35});
  return s;
}

/* 8 — RECONOCER */
productSlide(8,"Producto · Reconocer",
  [{text:"Reconocer toma "},{text:"15 segundos.",c:T.acc}],
  [
    {icon:"medal",fill:T.accStrong,h:"Tres tipos de insignia",s:"Competencias, Especiales y Valores — cada una con su identidad visual."},
    {icon:"coins",fill:T.amber,h:"Otorga puntos reales",s:"Cada insignia entrega puntos a quien la recibe (valor configurable)."},
    {icon:"at",fill:T.pink,h:"Mensaje con @menciones",s:"Un reconocimiento siempre lleva un por qué, personal y público."},
    {icon:"sync",fill:T.green,h:"Presupuesto mensual",s:"Cada persona tiene puntos ‘para dar’ que se recargan solos cada mes."},
  ],"1000048434").addNotes("Deep-dive del acto de reconocer. Insiste en la simpleza (15 s) y en que reconocer 'cuesta' del presupuesto mensual de quien da — eso lo vuelve valioso y equitativo.");

/* 9 — FEED */
productSlide(9,"Producto · Feed",
  [{text:"La cultura, por fin "},{text:"visible.",c:T.acc}],
  [
    {icon:"comments",fill:T.accStrong,h:"Muro de reconocimientos",s:"Toda la empresa ve, en un solo lugar, quién aporta y por qué."},
    {icon:"heart",fill:T.like,h:"Likes y comentarios",s:"El reconocimiento se vuelve conversación, no un correo que nadie abre."},
    {icon:"bell",fill:T.pink,h:"Avisos y banners",s:"Comunica campañas y noticias a todo el equipo desde la misma app."},
    {icon:"magic",fill:T.blue,h:"Orden por IA (opcional)",s:"Feed cronológico o personalizado por relevancia para cada persona."},
  ],"1000048435").addNotes("El feed es la prueba social que impulsa la adopción. Menciona el toggle 'IA ON/OFF' visible en pantalla como gancho al slide de IA.");

/* 10 — PUNTOS */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,10);
  kicker(s,"Producto · Puntos");
  title(s,[{text:"Una economía de puntos que "},{text:"se explica sola.",c:T.acc}],0.85,1.12,8.3,30);
  const bal=[
    {c:T.acc,h:"Acumulados",s:"Los puntos que recibes por ser reconocido."},
    {c:T.pink,h:"Para gastar",s:"Tu saldo disponible para canjear recompensas."},
    {c:T.green,h:"Para dar",s:"Tu presupuesto mensual para reconocer (se recarga solo)."},
  ];
  let y=2.5;
  bal.forEach(b=>{
    card(s,0.9,y,7.7,1.18);
    s.addShape(pres.shapes.OVAL,{x:1.2,y:y+0.34,w:0.5,h:0.5,fill:{color:b.c}});
    s.addImage({path:A.ic("coins"),x:1.32,y:y+0.46,w:0.26,h:0.26});
    s.addText(b.h,{x:1.95,y:y+0.2,w:5.6,h:0.4,margin:0,fontFace:T.FONTB,fontSize:17,bold:true,color:T.ink});
    s.addText(b.s,{x:1.95,y:y+0.62,w:6.3,h:0.45,margin:0,fontFace:T.FONT,fontSize:12.5,color:T.sub});
    y+=1.34;
  });
  phone(s,"1000048437",6.15,{x:9.35});
  s.addNotes("Explica los tres saldos con el mockup del perfil (225 / 500 / 250). El punto clave: separar 'lo que doy' de 'lo que recibo' hace el sistema justo y presupuestable para la empresa.");
})();

/* 11 — RECOMPENSAS (tarjetas diseñadas) */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,11);
  kicker(s,"Producto · Recompensas");
  title(s,[{text:"Puntos que se sienten: "},{text:"recompensas reales.",c:T.acc}]);
  const cats=[
    {icon:"seedling",c:T.green,h:"Experiencias",s:"Ej. un día libre adicional."},
    {icon:"tag",c:T.pink,h:"Gift Cards",s:"Ej. tarjeta de regalo de $500 MXN."},
    {icon:"gift",c:T.accStrong,h:"Incentivos",s:"Catálogo a medida de cada empresa."},
  ];
  const cw=3.72; let x=0.85;
  cats.forEach(cat=>{
    card(s,x,2.5,cw,2.2);
    circleIcon(s,x+0.4,2.82,0.85,cat.icon,cat.c,0.5);
    s.addText(cat.h,{x:x+0.4,y:3.78,w:cw-0.8,h:0.4,margin:0,fontFace:T.FONTB,fontSize:18,bold:true,color:T.ink});
    s.addText(cat.s,{x:x+0.4,y:4.22,w:cw-0.75,h:0.5,margin:0,fontFace:T.FONT,fontSize:12.5,color:T.sub});
    x+=cw+0.4;
  });
  // flujo canje
  card(s,0.85,4.98,11.6,0.92,T.cardHi);
  const flow=[["store","Explora el catálogo"],["gift","Agrega al carrito"],["check","Canjea con código"]];
  let fx=1.25;
  flow.forEach((f,i)=>{
    circleIcon(s,fx,5.14,0.6,f[0],T.accStrong,0.5);
    s.addText(f[1],{x:fx+0.72,y:5.14,w:2.9,h:0.6,margin:0,fontFace:T.FONTB,fontSize:13.5,bold:true,color:T.ink,valign:"middle"});
    fx+=3.75;
    if(i<2) s.addImage({path:A.ic("arrow"),x:fx-0.95,y:5.28,w:0.3,h:0.3});
  });
  s.addText([{text:"✦  Recomendaciones IA  ",options:{bold:true,color:T.acc}},{text:"sugieren la recompensa ideal para cada persona.",options:{color:T.sub}}],
    {x:0.9,y:6.2,w:11,h:0.3,margin:0,fontFace:T.FONT,fontSize:12});
  s.addNotes("Las recompensas son el incentivo tangible. Usa ejemplos reales de la app (día libre, gift card). El catálogo es 100% configurable por empresa: gancho para el slide de expansiones.");
})();

/* 12 — MI ACTIVIDAD / GAMIFICACIÓN */
productSlide(12,"Producto · Engagement",
  [{text:"Cada logro queda "},{text:"registrado y visible.",c:T.acc}],
  [
    {icon:"medal",fill:T.accStrong,h:"Historial de actividad",s:"Reconocimientos dados y recibidos, con fecha y detalle."},
    {icon:"award",fill:T.amber,h:"Insignias y embajadores",s:"Colecciona insignias y destaca como embajador de un valor."},
    {icon:"trophy",fill:T.gold,h:"Ranking con podio",s:"Tablas por mes, trimestre y año que sanamente motivan."},
    {icon:"coins",fill:T.green,h:"Estado de cuenta",s:"Cada movimiento de puntos, transparente para la persona."},
  ],"1000048442").addNotes("La gamificación sostiene el uso en el tiempo. Ranking + insignias + estado de cuenta dan sensación de progreso. Aclara que el ranking es motivacional, no punitivo.");

/* 13 — PANEL DE ADMINISTRACIÓN */
productSlide(13,"Para RRHH · Administración",
  [{text:"RRHH por fin puede "},{text:"medir la cultura.",c:T.acc}],
  [
    {icon:"chartline",fill:T.accStrong,h:"Dashboard con KPIs",s:"Colaboradores activos, puntos en circulación, reconocimientos y canjes."},
    {icon:"sliders",fill:T.blue,h:"Gestión total",s:"Colaboradores, insignias, recompensas, avisos y zonas — todo autoservicio."},
    {icon:"chartbar",fill:T.pink,h:"Reportes y tendencias",s:"Uso de insignias, actividad y evolución en el tiempo."},
    {icon:"shield",fill:T.green,h:"Roles y permisos",s:"Control por módulo para tu equipo de RRHH y líderes."},
  ],"1000048439").addNotes("Slide clave para el comprador (RRHH/Dirección). Aquí vendes CONTROL y DATOS. Nota: los números del demo son de una cuenta de prueba; en su empresa reflejarán su realidad.");

/* ======================================================================= */
/* 14 — BONDLY IA                                                          */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s,true); footer(s,14);
  kicker(s,"Diferenciador · Inteligencia artificial");
  title(s,[{text:"Inteligencia que hace el reconocimiento "},{text:"más relevante.",c:T.acc}]);
  const ai=[
    {icon:"magic",c:T.accStrong,h:"Feed personalizado",s:"La IA ordena el feed por relevancia para cada persona."},
    {icon:"brain",c:T.pink,h:"Análisis de sentimiento",s:"Detecta el tono de cada reconocimiento y lo etiqueta."},
    {icon:"gift",c:T.green,h:"Recompensas sugeridas",s:"Recomendaciones personalizadas según cada colaborador."},
  ];
  const cw=3.72,gy=2.75,ch=3.05; let x=0.85;
  ai.forEach(a=>{
    card(s,x,gy,cw,ch,T.cardHi);
    circleIcon(s,x+0.4,gy+0.45,0.95,a.icon,a.c,0.5);
    s.addText(a.h,{x:x+0.4,y:gy+1.6,w:cw-0.8,h:0.5,margin:0,fontFace:T.FONTB,fontSize:18,bold:true,color:T.ink});
    s.addText(a.s,{x:x+0.4,y:gy+2.1,w:cw-0.75,h:0.85,margin:0,fontFace:T.FONT,fontSize:13,color:T.sub,lineSpacingMultiple:1.1});
    x+=cw+0.4;
  });
  s.addText([{text:"Integrada y funcional dentro de la app.",options:{bold:true,color:T.ink}}],
    {x:0.85,y:6.05,w:11.6,h:0.35,margin:0,fontFace:T.FONT,fontSize:13.5,align:"center"});
  s.addNotes("El diferenciador tecnológico. Las tres funciones de IA están construidas y activas en la app. Frase: 'no es un roadmap, ya está corriendo'.");
})();

/* ======================================================================= */
/* 15 — POR QUÉ BONDLY                                                     */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,15);
  kicker(s,"Por qué Bondly");
  title(s,[{text:"El poder de las plataformas globales, "},{text:"hecho para México.",c:T.acc}]);
  const p=[
    {icon:"language",c:T.accStrong,h:"Español nativo",s:"Pensado para tu gente, no traducido."},
    {icon:"mobile",c:T.pink,h:"Móvil para todo el equipo",s:"De primera línea a corporativo."},
    {icon:"bolt",c:T.amber,h:"En marcha en días",s:"Precio PyME, sin implementación de meses."},
    {icon:"chartline",c:T.green,h:"Cultura medible",s:"Datos que le muestras a dirección."},
  ];
  const cw=2.83,gy=2.7,ch=2.65,gap=0.13; let x=0.85;
  p.forEach(it=>{
    card(s,x,gy,cw,ch);
    circleIcon(s,x+0.35,gy+0.4,0.8,it.icon,it.c,0.5);
    s.addText(it.h,{x:x+0.3,y:gy+1.35,w:cw-0.55,h:0.7,margin:0,fontFace:T.FONTB,fontSize:15.5,bold:true,color:T.ink,valign:"top",lineSpacingMultiple:1.0});
    s.addText(it.s,{x:x+0.3,y:gy+1.98,w:cw-0.5,h:0.6,margin:0,fontFace:T.FONT,fontSize:12,color:T.sub,lineSpacingMultiple:1.05});
    x+=cw+gap;
  });
  card(s,0.85,5.62,11.6,0.72,T.cardHi);
  s.addText([
    {text:"vs. suites enterprise:  ",options:{bold:true,color:T.pink}},
    {text:"caras, en inglés, con precio ‘hablemos con ventas’ e implementación pesada que tu mid-market no necesita.",options:{color:T.sub}},
  ],{x:1.15,y:5.62,w:11,h:0.72,margin:0,fontFace:T.FONT,fontSize:13,valign:"middle"});
  s.addNotes("Posicionamiento competitivo. No ataques por nombre; contrasta categoría: global/enterprise vs. hecho-para-México/PyME. Cuatro pilares = tus mensajes de venta centrales.");
})();

/* ======================================================================= */
/* 16 — PARA QUIÉN ES (ICP)                                                */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,16);
  kicker(s,"Para quién es");
  title(s,[{text:"Hecho para empresas de "},{text:"50 a 500",c:T.acc},{text:" personas en México."}]);
  // col izq: la empresa
  card(s,0.85,2.6,5.75,3.7);
  s.addText("La empresa",{x:1.2,y:2.85,w:5,h:0.4,margin:0,fontFace:T.FONTB,fontSize:16,bold:true,color:T.acc});
  const emp=[
    {icon:"building",h:"50–500 colaboradores",s:"El reconocimiento manual ya no escala; el enterprise es demasiado."},
    {icon:"seedling",h:"En crecimiento",s:"Abriendo turnos/sucursales y formalizando RRHH."},
    {icon:"mobile",h:"Equipos distribuidos",s:"Primera línea, híbridos y multi-sucursal."},
  ];
  iconRows(s,emp,1.2,3.4,5.1,0.92);
  // col der: quién compra + sectores
  card(s,6.7,2.6,5.75,3.7);
  s.addText("Quién lo compra",{x:7.05,y:2.85,w:5,h:0.4,margin:0,fontFace:T.FONTB,fontSize:16,bold:true,color:T.pink});
  s.addText([
    {text:"Dirección / Gerencia de RRHH, ",options:{bold:true,color:T.ink}},
    {text:"Cultura, Talento y Experiencia del Colaborador.",options:{color:T.sub}},
  ],{x:7.05,y:3.35,w:5.05,h:0.8,margin:0,fontFace:T.FONT,fontSize:13.5,lineSpacingMultiple:1.1});
  s.addText("Sectores con mayor necesidad",{x:7.05,y:4.35,w:5,h:0.35,margin:0,fontFace:T.FONTB,fontSize:12.5,bold:true,color:T.mute});
  const secs=["Retail","BPO / Call centers","Manufactura","Logística","Servicios","Tech"];
  let sx=7.05, sy=4.78;
  secs.forEach(se=>{
    const w=0.4+se.length*0.108;
    if(sx+w>12.4){ sx=7.05; sy+=0.62; }
    s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:sx,y:sy,w,h:0.48,rectRadius:0.24,fill:{color:T.cardHi},line:{color:T.border,width:1}});
    s.addText(se,{x:sx,y:sy,w,h:0.48,margin:0,fontFace:T.FONTB,fontSize:11.5,bold:true,color:T.sub,align:"center",valign:"middle"});
    sx+=w+0.15;
  });
  s.addNotes("Confirma que el prospecto es ICP. Si están fuera del rango (muy chicos o enterprise), ajusta el mensaje. Los sectores listados son los de mayor rotación en primera línea: ahí el reto es más agudo.");
})();

/* ======================================================================= */
/* 17 — RESULTADOS / PRUEBA                                                */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s); footer(s,17);
  kicker(s,"Lo que mueve en tu organización");
  title(s,[{text:"Menos rotación. Más compromiso. "},{text:"Cultura medible.",c:T.acc}]);
  const out=[
    {icon:"seedling",c:T.green,big:"−45%",lab:"rotación voluntaria evitable con buen reconocimiento."},
    {icon:"thumbs",c:T.pink,big:"9×",lab:"más compromiso entre quienes reciben reconocimiento de calidad."},
    {icon:"chartline",c:T.accStrong,big:"100%",lab:"visibilidad: cada reconocimiento y canje, medible."},
  ];
  const cw=3.72; let x=0.85;
  out.forEach(o=>{
    card(s,x,2.5,cw,2.15);
    circleIcon(s,x+0.35,2.8,0.62,o.icon,o.c,0.5);
    s.addText(o.big,{x:x+1.1,y:2.72,w:cw-1.3,h:0.75,margin:0,fontFace:T.FONTB,fontSize:34,bold:true,color:o.c,valign:"middle"});
    s.addText(o.lab,{x:x+0.4,y:3.6,w:cw-0.75,h:0.9,margin:0,fontFace:T.FONT,fontSize:12.5,color:T.sub,lineSpacingMultiple:1.08});
    x+=cw+0.4;
  });
  // prueba social — placeholders honestos
  card(s,0.85,4.95,11.6,1.4,T.cardHi);
  s.addText("Prueba social  ·  completar con tus datos reales",{x:1.15,y:5.1,w:10,h:0.3,margin:0,fontFace:T.FONTB,fontSize:11,bold:true,color:T.mute,charSpacing:1});
  s.addText("“ [ Testimonio del cliente ] ”",{x:1.15,y:5.42,w:6.6,h:0.85,margin:0,fontFace:T.FONT,fontSize:15,italic:true,color:T.ink,valign:"middle"});
  s.addText("— [ Nombre, puesto, empresa ]",{x:1.15,y:6.02,w:6.6,h:0.3,margin:0,fontFace:T.FONT,fontSize:11.5,color:T.mute});
  ["[ Logo ]","[ Logo ]","[ Logo ]"].forEach((l,i)=>{
    s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:8.2+i*1.42,y:5.5,w:1.28,h:0.75,rectRadius:0.1,fill:{color:T.card},line:{color:T.border,width:1}});
    s.addText(l,{x:8.2+i*1.42,y:5.5,w:1.28,h:0.75,margin:0,fontFace:T.FONT,fontSize:10.5,color:T.faint,align:"center",valign:"middle"});
  });
  sources(s,"Workhuman + Gallup (2024). Métricas de resultado del cliente: a completar.");
  s.addNotes("Honestidad: las cifras son de mercado (citadas); los logos/testimonio son placeholders para SUS datos reales. Cuando tengan clientes, reemplaza. Nunca inventes métricas de cliente.");
})();

/* ======================================================================= */
/* 18 — EXPANSIONES                                                        */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s,true); footer(s,18);
  kicker(s,"Planes · A la medida");
  title(s,[{text:"Empieza con el producto base. "},{text:"Crece a tu medida.",c:T.acc}]);
  // base
  card(s,0.85,2.55,5.75,4.0,T.cardHi);
  circleIcon(s,1.2,2.85,0.6,"check",T.green,0.5);
  s.addText("Producto base",{x:1.95,y:2.85,w:4.3,h:0.5,margin:0,fontFace:T.FONTB,fontSize:19,bold:true,color:T.ink,valign:"middle"});
  s.addText("Todo listo desde el día uno",{x:1.2,y:3.5,w:5.1,h:0.3,margin:0,fontFace:T.FONT,fontSize:11.5,italic:true,color:T.green});
  const base=["Reconocimiento con insignias, puntos y menciones","Feed social con likes y comentarios","Economía de puntos y recompensas canjeables","Insignias, embajadores y ranking","Panel de administración y analítica","IA integrada (feed, sentimiento, recompensas)","Multiplataforma: iOS, Android y Web"];
  s.addText(base.map(b=>({text:b,options:{bullet:{code:"2022"},breakLine:true,color:T.sub}})),
    {x:1.25,y:3.85,w:5.1,h:2.55,margin:0,fontFace:T.FONT,fontSize:12.5,paraSpaceAfter:6,lineSpacingMultiple:1.02});
  // a medida
  card(s,6.7,2.55,5.75,4.0);
  circleIcon(s,7.05,2.85,0.6,"puzzle",T.accStrong,0.5);
  s.addText("Sets de mejora a la medida",{x:7.8,y:2.85,w:4.5,h:0.5,margin:0,fontFace:T.FONTB,fontSize:19,bold:true,color:T.ink,valign:"middle"});
  s.addText("Desarrollo a medida / roadmap por empresa",{x:7.05,y:3.5,w:5.2,h:0.3,margin:0,fontFace:T.FONT,fontSize:11.5,italic:true,color:T.acc});
  const addons=["Notificaciones push y centro de avisos","Integraciones SSO / HRIS (Workday, BambooHR…)","Slack / Microsoft Teams","Multi-empresa y multi-moneda","API y webhooks para tus sistemas","White-label y marca por cliente","Analítica avanzada y exportables"];
  s.addText(addons.map(b=>({text:b,options:{bullet:{code:"2022"},breakLine:true,color:T.sub}})),
    {x:7.1,y:3.85,w:5.1,h:2.55,margin:0,fontFace:T.FONT,fontSize:12.5,paraSpaceAfter:6,lineSpacingMultiple:1.02});
  s.addNotes("El modelo comercial: base sólido + add-ons a medida (upsell). IMPORTANTE (honestidad): la columna derecha es desarrollo a medida / roadmap, no features ya activas. Preséntalas como 'lo construimos para ti', no como 'ya existe'. Aquí se personaliza por cada empresa.");
})();

/* ======================================================================= */
/* 19 — CIERRE / CTA                                                       */
/* ======================================================================= */
(function(){
  const s=pres.addSlide(); bg(s,true);
  const lw=2.1, lh=lw*(338/800);
  s.addImage({ path:A.logo, x:(PW-lw)/2, y:1.55, w:lw, h:lh });
  s.addText([{text:"Convirtamos el reconocimiento en tu "},{text:"ventaja de retención.",c:T.acc}].map(r=>({text:r.text,options:{color:r.c||T.ink,bold:true}})),
    {x:1.5,y:2.95,w:PW-3,h:1.3,margin:0,fontFace:T.FONTB,fontSize:33,align:"center",lineSpacingMultiple:1.05});
  // CTA
  s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:(PW-3.4)/2,y:4.55,w:3.4,h:0.78,rectRadius:0.39,fill:{color:T.accStrong},shadow:shadow()});
  s.addText("Agenda una demo",{x:(PW-3.4)/2,y:4.55,w:3.4,h:0.78,margin:0,fontFace:T.FONTB,fontSize:16,bold:true,color:"FFFFFF",align:"center",valign:"middle"});
  s.addText([
    {text:"[ correo ]",options:{color:T.sub}},
    {text:"      ·      ",options:{color:T.faint}},
    {text:"bondly.mx",options:{color:T.sub}},
    {text:"      ·      ",options:{color:T.faint}},
    {text:"[ teléfono ]",options:{color:T.sub}},
  ],{x:0,y:5.7,w:PW,h:0.35,margin:0,fontFace:T.FONT,fontSize:13,align:"center"});
  s.addNotes("Cierre y llamada a la acción. Propón el siguiente paso concreto: una demo en vivo con datos de su empresa. Reemplaza [correo] y [teléfono]. Deja que la última frase (ventaja de retención) sea lo que recuerden.");
})();

pres.writeFile({ fileName:"Bondly_Sales_Deck.pptx" }).then(f=>console.log("OK:",f));
