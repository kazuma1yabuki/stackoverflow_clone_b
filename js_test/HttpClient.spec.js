import assert from 'power-assert';
import './TestHelper';
import HttpClient from '@/utils/HttpClient';

const orgResource = { data: { id: 'idX', field_x: 'fieldXValue' } };
const snakeResource = { data: { id: 'idX', fieldX: 'fieldXValue' } };
const apiUrl = '/v1/resource';

describe('HttpClient', function () {
  afterEach(function () {
    HttpClient.__ResetDependency__('axios');
  });

  describe('get()', function () {
    it('translates params and response', function () {
      HttpClient.__Rewire__('axios', {
        get(url, { params }) {
          assert(url === apiUrl);
          assert.deepEqual(params, { field_x: 'xxx' });
          return Promise.resolve(orgResource);
        },
      });
      return HttpClient.get(apiUrl, { params: { fieldX: 'xxx' } })
        .then((res) => {
          assert.deepEqual(res, snakeResource);
        });
    });
  });

  describe('post()', function () {
    it('translates body and params and response', function () {
      HttpClient.__Rewire__('axios', {
        post(url, body, { params }) {
          assert(url === apiUrl);
          assert.deepEqual(body, { field_y: 'xxx' });
          assert.deepEqual(params, { field_x: 'xxx' });
          return Promise.resolve(orgResource);
        },
      });
      return HttpClient.post(apiUrl, { fieldY: 'xxx' }, { params: { fieldX: 'xxx' } })
        .then((res) => {
          assert.deepEqual(res, snakeResource);
        });
    });
  });

  describe('put()', function () {
    it('translates body and params and response', function () {
      HttpClient.__Rewire__('axios', {
        put(url, body, { params }) {
          assert(url === apiUrl);
          assert.deepEqual(body, { field_y: 'xxx' });
          assert.deepEqual(params, { field_x: 'xxx' });
          return Promise.resolve(orgResource);
        },
      });
      return HttpClient.put(apiUrl, { fieldY: 'xxx' }, { params: { fieldX: 'xxx' } })
        .then((res) => {
          assert.deepEqual(res, snakeResource);
        });
    });
  });

  describe('_camelizeKeyRecursive()', function () {
    it('translates nested key', function () {
      const resoruce = {
        key_a: {
          key_b: 'valueB',
        },
        items: [{ key_c: 'valueC' }],
      };
      const expected = {
        keyA: {
          keyB: 'valueB',
        },
        items: [{ keyC: 'valueC' }],
      };
      assert.deepEqual(HttpClient._camelizeKeyRecursive(resoruce), expected);
    });
  });
});
