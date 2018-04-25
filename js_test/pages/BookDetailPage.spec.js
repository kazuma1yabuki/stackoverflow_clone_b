import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import BookDetailPage from '@/pages/BookDetailPage';
import Book from '@/components/Book';
import router from '@/router';

describe('BookDetailPage', function () {
  const bookId = 'bookX';
  let store;
  let sandbox;
  let retrieveBookStub;
  let updateBookStub;

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    retrieveBookStub = sandbox.stub().callsFake(() => Promise.resolve());
    updateBookStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
        book: {
          id: bookId,
          title: 'titleX',
          author: 'authorX',
        },
      },
      actions: {
        retrieveBook: retrieveBookStub,
        updateBook: updateBookStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('dispatches "updateBook" when Book component emits "updateBook" event', function () {
    const editedTitle = 'editedTitle';
    const editedAuthor = 'editedAuthor';
    router.push({ name: 'BookDetailPage', params: { id: bookId } });
    const wrapper = shallow(BookDetailPage, {
      store,
      router,
      stubs: {
        Book,
      },
    });
    const retrieveBookArg = retrieveBookStub.getCall(0).args[1];
    assert(retrieveBookArg.id === bookId);
    wrapper.find(Book).vm.$emit('update', { title: 'editedTitle', author: 'editedAuthor' });
    const updateBookArg = updateBookStub.getCall(0).args[1];
    assert(updateBookArg.title === editedTitle);
    assert(updateBookArg.author === editedAuthor);
  });
});
