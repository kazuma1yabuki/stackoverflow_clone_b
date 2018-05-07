import Vue from 'vue';
import Vuex from 'vuex';
import '@/global_mixin';

Vue.config.productionTip = false;

class DummyLocalStorage {
  constructor() {
    this.storage = {};
  }
  getItem(key) {
    return this.storage[key];
  }
  setItem(key, value) {
    this.storage[key] = value;
  }
  removeItem(key) {
    delete this.storage[key];
  }
}
global.localStorage = new DummyLocalStorage();

Vue.use(Vuex);
