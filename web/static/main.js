import Vue from 'vue';
import App from '@/App';
import router from '@/router';
import { store } from '@/store';
import '@/global_mixin';
import '@/css/global.css';

Vue.config.productionTip = false;

new Vue({ /* eslint-disable-line no-new */
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>',
});
