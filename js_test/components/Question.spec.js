import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Question from '@/components/Question';
import router from '@/router';

describe('Question', function () {
  let store;
  const question = {
    id: '5aef02ae36000036000cd039',
    created_at: '2018-05-06T13:27:10+00:00',
    user_id: '5aa2100737000037001811c3',
    title: 'titleX',
    like_voter_ids: [],
    dislike_voter_ids: [],
    comments: [
      {
        user_id: '5aa2100737000037001811c3',
        id: '0GhVJIvT3TUqastruFr9',
        created_at: '2018-05-06T14:00:23+00:00',
        body: 'bodyX',
      },
    ],
    body: 'bodyX',
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
    const wrapper = shallow(Question, {
      store,
      router,
      propsData: {
        question,
      },
    });
    assert(wrapper.find('.page-title').text().includes(question.title));
    assert(wrapper.find('.body').text().includes(question.body));
  });
});
