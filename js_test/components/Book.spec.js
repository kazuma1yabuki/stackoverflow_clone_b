import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Book from '@/components/Book';
import router from '@/router';

describe('Book', function () {
  let store;
  const book = {
    id: 'bookX',
    title: 'titleX',
    author: 'authorX',
  };

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
      },
      actions: {
      },
    });
  });

  it('renders answer body and comment components', function () {
    const wrapper = shallow(Book, {
      store,
      router,
      propsData: {
        book,
      },
    });
    assert(wrapper.find('.page-title').text().includes(book.title));
    assert(wrapper.find('.author').text().includes(book.author));
  });

  const editedTitle = 'editedTitle';
  const editedAuthor = 'editedAuthor';

  function startEdit() {
    const wrapper = shallow(Book, {
      store,
      router,
      propsData: {
        book,
      },
    });
    assert(wrapper.find('.edit-button').exists());
    wrapper.find('.edit-button').trigger('click');
    assert(wrapper.find('.title-edit').element.value === book.title);
    assert(wrapper.find('.author-edit').element.value === book.author);
    return wrapper;
  }

  it('emits "update" event when user clicks save button', function () {
    const wrapper = startEdit();
    wrapper.find('.title-edit').element.value = editedTitle;
    wrapper.find('.title-edit').trigger('input');
    wrapper.find('.author-edit').element.value = editedAuthor;
    wrapper.find('.author-edit').trigger('input');
    wrapper.find('.book-form').trigger('submit');
    const eventArgs = wrapper.emitted().update[0];
    assert(eventArgs[0].title === editedTitle);
    assert(eventArgs[0].author === editedAuthor);
    assert(!wrapper.find('.title-edit').exists());
  });

  it('cancels editing when user clicks cancel button', function () {
    const wrapper = startEdit();
    wrapper.find('.title-edit').element.value = editedTitle;
    wrapper.find('.title-edit').trigger('input');
    wrapper.find('.cancel-edit-button').trigger('click');
    assert(!wrapper.find('.title-edit').exists());
    assert(wrapper.find('.page-title').text().includes(book.title));
  });
});
