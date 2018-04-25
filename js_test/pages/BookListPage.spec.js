import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { mount } from '@vue/test-utils';
import '../TestHelper';
import BookListPage from '@/pages/BookListPage';
import router from '@/router';

describe('BookListPage', function () {
  let store;
  let sandbox;
  let retrieveBooksStub;
  const books = [{
    id: 'bookX',
    title: 'titleX',
    author: 'authorX',
    createdAt: '2000-00-00T00:00:00+00:00',
  }];

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    retrieveBooksStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
        books,
      },
      actions: {
        retrieveBooks: retrieveBooksStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('renders books', function () {
    const wrapper = mount(BookListPage, {
      store,
      router,
    });
    assert(retrieveBooksStub.called);
    assert(wrapper.find('.title').text().includes(books[0].title));
    assert(wrapper.find('.additional').text().includes(books[0].author));
  });
});
