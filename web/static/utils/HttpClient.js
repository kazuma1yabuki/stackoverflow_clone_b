import axios from 'axios';
import _ from 'lodash';

export default class HttpClient {
  static get(path, options) {
    return axios.get(path, HttpClient._snakeCaseOptions(options))
      .then(res => HttpClient._camelizeResponse(res));
  }
  static post(path, body, options) {
    return axios.post(path, HttpClient._snakeCaseKeyRecursive(body), HttpClient._snakeCaseOptions(options))
      .then(res => HttpClient._camelizeResponse(res));
  }
  static put(path, body, options) {
    return axios.put(path, HttpClient._snakeCaseKeyRecursive(body), HttpClient._snakeCaseOptions(options))
      .then(res => HttpClient._camelizeResponse(res));
  }
  static _mapKeyRecursive(o, iteratee) {
    if (Array.isArray(o)) {
      return o.map(item => HttpClient._mapKeyRecursive(item, iteratee));
    } else if (_.isObject(o)) {
      return _.reduce(o, (memo, value, key) => {
        const camelizedKey = iteratee(key);
        return { ...memo, [camelizedKey]: HttpClient._mapKeyRecursive(value, iteratee) };
      }, {});
    }
    return o;
  }
  static _camelizeKeyRecursive(o) {
    return HttpClient._mapKeyRecursive(o, _.camelCase);
  }
  static _snakeCaseKeyRecursive(o) {
    return HttpClient._mapKeyRecursive(o, _.snakeCase);
  }
  static _camelizeResponse(res) {
    return { ...res, data: HttpClient._camelizeKeyRecursive(res.data) };
  }
  static _snakeCaseOptions(options = {}) {
    return { ...options, params: HttpClient._snakeCaseKeyRecursive(options.params) };
  }
}
