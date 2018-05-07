import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { mount } from '@vue/test-utils';
import '../TestHelper';
import UserDetailPage from '@/pages/UserDetailPage';
import router from '@/router';

describe('UserDetailPage', function () {
  let store;
  let sandbox;
  let retrieveQuestionsStub;
  let retrieveAnswersStub;
  const userId = 'userX';
  const questions = [{
    id: 'questionX',
    title: 'titleX',
    userId: userId,
    comments: [],
    likeVoterIds: [],
    dislikeVoterIds: [],
    createdAt: '2000-00-00T00:00:00+00:00',
  }];
  const answers = [{
    id: 'answerX',
    userId: userId,
    body: 'bodyX',
    questionId: 'questionX',
    comments: [],
    createdAt: '2000-00-00T00:00:00+00:00',
  }];

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    retrieveQuestionsStub = sandbox.stub().callsFake(() => Promise.resolve());
    retrieveAnswersStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
        questions,
        answers,
      },
      actions: {
        retrieveQuestions: retrieveQuestionsStub,
        retrieveAnswers: retrieveAnswersStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('renders own questions and answers', function () {
    router.push({ name: 'UserDetailPage', params: { id: userId } });
    const wrapper = mount(UserDetailPage, {
      store,
      router,
    });
    const retrieveQuestionsArg = retrieveQuestionsStub.getCall(0).args[1];
    assert(retrieveQuestionsArg.userId === userId);
    const retrieveAnswersArg = retrieveAnswersStub.getCall(0).args[1];
    assert(retrieveAnswersArg.userId === userId);
    assert(wrapper.find('.question-list .question-title').text().includes(questions[0].title));
    assert(wrapper.find('.question-list .additional').text().includes(questions[0].createdAt));
    assert(wrapper.find('.answer-list .answer-body').text().includes(answers[0].body));
    assert(wrapper.find('.answer-list .additional').text().includes(answers[0].createdAt));
  });
});
