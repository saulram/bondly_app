const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
const fa = require("react-icons/fa");
const fs = require("fs");
if(!fs.existsSync("assets/ic")) fs.mkdirSync("assets/ic",{recursive:true});

const set = {
  users: fa.FaUsers, user: fa.FaUser, usersgear: fa.FaUsersCog,
  chartline: fa.FaChartLine, chartbar: fa.FaChartBar, chartpie: fa.FaChartPie,
  heart: fa.FaHeart, gift: fa.FaGift, comments: fa.FaComments, coins: fa.FaCoins,
  trophy: fa.FaTrophy, medal: fa.FaMedal, brain: fa.FaBrain, magic: fa.FaMagic,
  mobile: fa.FaMobileAlt, globe: fa.FaGlobe, language: fa.FaLanguage, bolt: fa.FaBolt,
  rocket: fa.FaRocket, check: fa.FaCheck, checkcircle: fa.FaCheckCircle, puzzle: fa.FaPuzzlePiece,
  calendar: fa.FaCalendarAlt, clock: fa.FaClock, warning: fa.FaExclamationTriangle, xmark: fa.FaTimes,
  building: fa.FaBuilding, shield: fa.FaShieldAlt, store: fa.FaStore, bell: fa.FaBell,
  plug: fa.FaPlug, tag: fa.FaTag, eye: fa.FaEye, arrow: fa.FaArrowRight,
  bulb: fa.FaLightbulb, layers: fa.FaLayerGroup, cog: fa.FaCog, handshake: fa.FaHandshake,
  thumbs: fa.FaThumbsUp, at: fa.FaAt, sync: fa.FaSyncAlt, award: fa.FaAward, sliders: fa.FaSlidersH,
  paperplane: fa.FaPaperPlane, seedling: fa.FaSeedling, fire: fa.FaFireAlt, lock: fa.FaLock,
};
(async()=>{
  for(const [name,Comp] of Object.entries(set)){
    if(!Comp){ console.log("MISSING",name); continue; }
    const svg = ReactDOMServer.renderToStaticMarkup(React.createElement(Comp,{color:"#FFFFFF",size:"256"}));
    await sharp(Buffer.from(svg)).resize(256,256,{fit:"contain",background:{r:0,g:0,b:0,alpha:0}}).png().toFile(`assets/ic/${name}.png`);
  }
  console.log("icons rendered:", Object.keys(set).length);
})();
