import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow, mount } from '@vue/test-utils';
import '../TestHelper';
import Header from '@/components/Header';
import router from '@/router';

describe('Header', function () {
  let store;
  const userId = 'userX';

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
        id: userId,
      },
    });
  });

  describe('when user is logged in', function () {
    let methods;

    beforeEach(function () {
      methods = {
        isLoggedIn() {
          return true;
        },
      };
    });

    it('emits "logout" event when user clck logout link', function () {
      const wrapper = shallow(Header, {
        store,
        router,
        methods,
      });
      assert(wrapper.find('.logout-link').exists());
      wrapper.find('.logout-link').trigger('click');
      assert(wrapper.emitted().logout.length === 1);
    });
  });

  describe('when user is not logged in', function () {
    let methods;

    beforeEach(function () {
      methods = {
        isLoggedIn() {
          return false;
        },
      };
    });

    it('shows login link', function () {
      const wrapper = mount(Header, {
        store,
        router,
        methods,
      });
      assert(wrapper.find('.login-link').exists());
      assert(!wrapper.find('.logout-link').exists());
    });
  });
});
