const getEventData = require('getEventData');
const decodeUriComponent = require('decodeUriComponent');
const encodeUriComponent = require('encodeUriComponent');

const modTable = data.customParams;
const pageLocation = decodeUriComponent(getEventData('page_location'));

let resQueryArr = [];

let splitUrl = pageLocation.split('?');

if (!splitUrl[1]) return pageLocation;

let qArr = splitUrl[1].split('&');

for (let i = 0; i < qArr.length; i++) {
  let res;
  let tmp = qArr[i].split('=');

  for (let j = 0; j < modTable.length; j++) {
    if (tmp[0] === modTable[j].cusName) {
      res = modTable[j].utmName + '=' + tmp[1];
      break;
    } else res = qArr[i];
  }

  resQueryArr.push(res);
}

return splitUrl[0] + '?' + resQueryArr.join('&');
