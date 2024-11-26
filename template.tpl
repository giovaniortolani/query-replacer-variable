___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Query Replacer",
  "description": "Replace query parameters in the page location.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "LABEL",
    "name": "label",
    "displayName": "Specify below which parameters in the ‘page_location’ event data should be replaced"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "customParams",
    "displayName": "",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "replace this",
        "name": "cusName",
        "type": "TEXT",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "isUnique": true
      },
      {
        "defaultValue": "",
        "displayName": "with this",
        "name": "utmName",
        "type": "TEXT",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "page_location"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 26/11/2024, 13:54:56


