import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { mount } from '@vue/test-utils';
import '../TestHelper';
import QuestionListPage from '@/pages/QuestionListPage';
import router from '@/router';

describe('QuestionListPage', function () {
  let store;
  let sandbox;
  let retrieveQuestionsStub;
  const questions = [{
    id: 'bookX',
    title: 'titleX',
    userId: 'userX',
    comments: [],
    likeVoterIds: [],
    dislikeVoterIds: [],
    createdAt: '2000-00-00T00:00:00+00:00',
  }];

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    retrieveQuestionsStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
        questions,
      },
      actions: {
        retrieveQuestions: retrieveQuestionsStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('renders questions', function () {
    const wrapper = mount(QuestionListPage, {
      store,
      router,
    });
    assert(retrieveQuestionsStub.called);
    assert(wrapper.find('.title').text().includes(questions[0].title));
    assert(wrapper.find('.additional').text().includes(questions[0].userId));
    assert(wrapper.find('.additional').text().includes(questions[0].createdAt));
  });
});
