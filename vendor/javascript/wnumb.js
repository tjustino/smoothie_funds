var e="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var r={};(function(e){r=e()})((function(){var r=["decimals","thousand","mark","prefix","suffix","encoder","decoder","negativeBefore","negative","edit","undo"];function strReverse(e){return e.split("").reverse().join("")}function strStartsWith(e,r){return e.substring(0,r.length)===r}function strEndsWith(e,r){return e.slice(-1*r.length)===r}function throwEqualError(e,r,t){if((e[r]||e[t])&&e[r]===e[t])throw new Error(r)}function isValidNumber(e){return"number"===typeof e&&isFinite(e)}function toFixed(e,r){e=e.toString().split("e");e=Math.round(+(e[0]+"e"+(e[1]?+e[1]+r:r)));e=e.toString().split("e");return(+(e[0]+"e"+(e[1]?+e[1]-r:-r))).toFixed(r)}function formatTo(e,r,t,i,n,o,f,s,a,u,l,d){var c=d,h,p,v,g="",m="";o&&(d=o(d));if(!isValidNumber(d))return false;false!==e&&0===parseFloat(d.toFixed(e))&&(d=0);if(d<0){h=true;d=Math.abs(d)}false!==e&&(d=toFixed(d,e));d=d.toString();if(-1!==d.indexOf(".")){p=d.split(".");v=p[0];t&&(g=t+p[1])}else v=d;if(r){v=strReverse(v).match(/.{1,3}/g);v=strReverse(v.join(strReverse(r)))}h&&s&&(m+=s);i&&(m+=i);h&&a&&(m+=a);m+=v;m+=g;n&&(m+=n);u&&(m=u(m,c));return m}function formatFrom(e,r,t,i,n,o,f,s,a,u,l,d){var c=d,h,p="";l&&(d=l(d));if(!d||"string"!==typeof d)return false;if(s&&strStartsWith(d,s)){d=d.replace(s,"");h=true}i&&strStartsWith(d,i)&&(d=d.replace(i,""));if(a&&strStartsWith(d,a)){d=d.replace(a,"");h=true}n&&strEndsWith(d,n)&&(d=d.slice(0,-1*n.length));r&&(d=d.split(r).join(""));t&&(d=d.replace(t,"."));h&&(p+="-");p+=d;p=p.replace(/[^0-9\.\-.]/g,"");if(""===p)return false;p=Number(p);f&&(p=f(p));return!!isValidNumber(p)&&p}function validate(e){var t,i,n,o={};void 0===e["suffix"]&&(e["suffix"]=e["postfix"]);for(t=0;t<r.length;t+=1){i=r[t];n=e[i];if(void 0===n)"negative"!==i||o.negativeBefore?"mark"===i&&"."!==o.thousand?o[i]=".":o[i]=false:o[i]="-";else if("decimals"===i){if(!(n>=0&&n<8))throw new Error(i);o[i]=n}else if("encoder"===i||"decoder"===i||"edit"===i||"undo"===i){if("function"!==typeof n)throw new Error(i);o[i]=n}else{if("string"!==typeof n)throw new Error(i);o[i]=n}}throwEqualError(o,"mark","thousand");throwEqualError(o,"prefix","negative");throwEqualError(o,"prefix","negativeBefore");return o}function passAll(e,t,i){var n,o=[];for(n=0;n<r.length;n+=1)o.push(e[r[n]]);o.push(i);return t.apply("",o)}function wNumb(r){if(!((this||e)instanceof wNumb))return new wNumb(r);if("object"===typeof r){r=validate(r);(this||e).to=function(e){return passAll(r,formatTo,e)};(this||e).from=function(e){return passAll(r,formatFrom,e)}}}return wNumb}));var t=r;export default t;

