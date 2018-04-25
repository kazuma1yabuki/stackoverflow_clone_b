import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import BookCreationPage from '@/pages/BookCreationPage';
import router from '@/router';

describe('BookCreationPage', function () {
  let store;
  let sandbox;
  let createBookStub;

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    createBookStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
      },
      actions: {
        createBook: createBookStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('dispatches "createBook" when user clicks create button', function (done) {
    const title = 'title';
    const author = 'author';
    sandbox.stub(router, 'push').callsFake(({ path }) => {
      assert(path === '/book');
      done();
    });
    const wrapper = shallow(BookCreationPage, {
      store,
      router,
    });
    wrapper.find('.title-edit').element.value = title;
    wrapper.find('.title-edit').trigger('input');
    wrapper.find('.author-edit').element.value = author;
    wrapper.find('.author-edit').trigger('input');
    wrapper.find('.book-form').trigger('submit');
    const optionArg = createBookStub.getCall(0).args[1];
    assert(optionArg.title === title);
    assert(optionArg.author === author);
  });
});
