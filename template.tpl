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
      res = encodeUriComponent(modTable[j].utmName) + '=' + encodeUriComponent(tmp[1]);
      break;
    } else res = encodeUriComponent(tmp[0]) + '=' + encodeUriComponent(tmp[1]);
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

scenarios:
- name: URL without parameters
  code: |-
    const decodeUriComponent = require('decodeUriComponent');

    const mockData = {
      customParams: [
        { cusName: 'this', utmName: 'that' },
        { cusName: 'foo', utmName: 'bar' },
      ]
    };

    mock('getEventData', (key) => {
      if (key === 'page_location') return page_location_without_query_params;
    });

    let variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(page_location_without_query_params);
- name: URL with parameters and no modification
  code: |-
    const decodeUriComponent = require('decodeUriComponent');

    const mockData = {
      customParams: [
        { cusName: 'this', utmName: 'that' },
        { cusName: 'foo', utmName: 'bar' },
      ]
    };

    mock('getEventData', (key) => {
      if (key === 'page_location') return page_location_with_query_params;
    });

    let variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(page_location_with_query_params);
- name: URL with parameters and with modification
  code: |+
    const decodeUriComponent = require('decodeUriComponent');

    const mockData = {
      customParams: [
        { cusName: 'oneparam', utmName: 'new_one_param' },
        { cusName: 'teste', utmName: 'new_teste' },
        { cusName: 'parâmetro', utmName: 'testão' },
      ]
    };

    mock('getEventData', (key) => {
      if (key === 'page_location') return page_location_with_query_params;
    });

    let variableResult = runCode(mockData);

    assertThat(variableResult).contains('new_teste=123');
    assertThat(variableResult).contains('new_one_param=1%202%203%204');
    assertThat(variableResult).contains('test%C3%A3o=%C3%A7%C3%A3o');

setup: |
  const page_location_without_query_params = 'https://example.com/?';
  const page_location_with_query_params = 'https://example.com/?oneparam=1%202%203%204&teste=123&anotherparam=hahsdhasd&par%C3%A2metro=%C3%A7%C3%A3o';


___NOTES___

Created on 26/11/2024, 13:54:56
