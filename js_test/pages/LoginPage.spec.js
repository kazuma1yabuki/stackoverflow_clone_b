import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { mount } from '@vue/test-utils';
import '../TestHelper';
import LoginPage from '@/pages/LoginPage';
import router from '@/router';

describe('LoginPage', function () {
  let store;
  let sandbox;
  let loginStub;

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    loginStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
      },
      actions: {
        login: loginStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('dispatch "login" when user submits from', function (done) {
    const email = 'test@example.com';
    const password = 'passwordX';
    const wrapper = mount(LoginPage, {
      store,
      router,
    });
    wrapper.find('.email-edit').element.value = email;
    wrapper.find('.email-edit').trigger('input');
    wrapper.find('.password-edit').element.value = password;
    wrapper.find('.password-edit').trigger('input');
    wrapper.find('form').trigger('submit');
    const arg = loginStub.getCall(0).args[1];
    assert(arg.email === email);
    assert(arg.password === password);
    sandbox.stub(router, 'push').callsFake(({ path }) => {
      assert(path === '/');
      done();
    });
  });
});
