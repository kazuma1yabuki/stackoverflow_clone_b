import { createLocalVue } from '@vue/test-utils';
import assert from 'power-assert';
import './TestHelper';
import Vuex from 'vuex';
import { __RewireAPI__ as rewiredApi, state, mutations, actions } from '@/store';
import _ from 'lodash';

describe('store', function () {
  let store;
  const comment = {
    id: 'commentIdX',
    body: 'comentBodyX',
    createdAt: '2000-00-00T00:00:00+00:00',
    userId: 'user3',
  };
  const comments = [comment];
  const question = {
    id: 'questionX',
    title: 'titleX',
    body: 'bodyX',
    createdAt: '2000-00-00T00:00:00+00:00',
    likeVoterIds: ['likeVoterId1', 'likeVoterId2'],
    dislikeVoterIds: ['dislikeVoterId1'],
    userId: 'user2',
    comments,
  };
  const questions = [question];
  const answer = {
    id: 'answerX',
    comments,
    userId: 'userX',
    questionId: 'questionX',
    createdAt: '2000-00-00T00:00:00+00:00',
  };
  const answers = [answer];
  const key = 'keyX';
  const book = {
    id: 'bookX',
    title: 'titleX',
    author: 'authorX',
  };
  const books = [book];

  beforeEach(function () {
    const localVue = createLocalVue();
    localVue.use(Vuex);
    store = new Vuex.Store(_.cloneDeep({ state, mutations, actions }));
  });

  afterEach(function () {
    afterEach(function () {
      rewiredApi.__ResetDependency__('HttpClient');
    });
  });

  function setCredential() {
    const email = 'test@example.com';
    const id = 'userX';
    const expiresAt = '2000-00-00T00:00:00+00:00';
    store.commit('setCredential', {
      email, key, id, expiresAt,
    });
  }

  describe('actions', function () {
    describe('login()', function () {
      it('', function () {
        const email = 'test@example.com';
        const password = 'passX';
        const id = 'userX';
        const expiresAt = '2000-00-00T00:00:00+00:00';
        rewiredApi.__Rewire__('HttpClient', {
          post(url, body) {
            assert(url === '/v1/user/login');
            assert.deepEqual(body, { email, password });
            return Promise.resolve({
              data: {
                email,
                id,
                session: {
                  expiresAt,
                  key,
                },
              },
            });
          },
        });
        return store.dispatch('login', { email, password })
          .then(() => {
            assert(store.state.id === id);
            assert(store.state.email === email);
            assert(store.state.key === key);
            assert(store.state.expiresAt === expiresAt);
          });
      });
    });

    describe('logout()', function () {
      it('', function () {
        setCredential();
        return store.dispatch('logout')
          .then(() => {
            assert(store.state.id === '');
            assert(store.state.email === '');
            assert(store.state.key === '');
            assert(store.state.expiresAt === '');
          });
      });
    });

    describe('retrieveQuestion()', function () {
      it('', function () {
        const id = 'questionx';
        rewiredApi.__Rewire__('HttpClient', {
          get(url) {
            assert(url === `/v1/question/${id}`);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('retrieveQuestion', { id })
          .then(() => {
            assert.deepEqual(store.state.question, question);
          });
      });
    });

    describe('updateQuestion()', function () {
      it('', function () {
        const id = 'questionX';
        const title = 'titleX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          put(url, reqBody, { headers }) {
            assert(url === `/v1/question/${id}`);
            assert(reqBody.title === title);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('updateQuestion', { id, title, body })
          .then(() => {
            assert.deepEqual(store.state.question, question);
          });
      });
    });

    describe('retrieveQuestions()', function () {
      it('', function () {
        const userId = 'userX';
        rewiredApi.__Rewire__('HttpClient', {
          get(url, { params }) {
            assert(url === '/v1/question');
            assert(params.userId === userId);
            return Promise.resolve({
              data: questions,
            });
          },
        });
        return store.dispatch('retrieveQuestions', { userId })
          .then(() => {
            assert.deepEqual(store.state.questions, questions);
          });
      });
    });

    describe('createQuestion()', function () {
      it('', function () {
        const title = 'titleX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody, { headers }) {
            assert(url === '/v1/question');
            assert(reqBody.title === title);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('createQuestion', { title, body })
          .then(() => {
            assert.deepEqual(store.state.questions, [question]);
          });
      });
    });

    describe('retrieveAnswers()', function () {
      it('', function () {
        const userId = 'userX';
        const questionId = 'questionX';
        rewiredApi.__Rewire__('HttpClient', {
          get(url, { params }) {
            assert(url === '/v1/answer');
            assert(params.userId === userId);
            assert(params.questionId === questionId);
            return Promise.resolve({
              data: answers,
            });
          },
        });
        return store.dispatch('retrieveAnswers', { questionId, userId })
          .then(() => {
            assert.deepEqual(store.state.answers, answers);
          });
      });
    });

    describe('createAnswer()', function () {
      it('', function () {
        const questionId = 'questionX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody, { headers }) {
            assert(url === '/v1/answer');
            assert(reqBody.questionId === questionId);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: answer,
            });
          },
        });
        return store.dispatch('createAnswer', { questionId, body })
          .then(() => {
            assert.deepEqual(store.state.answers, [answer]);
          });
      });
    });

    describe('updateAnswer()', function () {
      it('', function () {
        const questionId = 'questionX';
        const id = 'answerX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          put(url, reqBody, { headers }) {
            assert(url === `/v1/answer/${id}`);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: answer,
            });
          },
          get() {
            return Promise.resolve({
              data: answers,
            });
          },
        });
        return store.dispatch('updateAnswer', { questionId, id, body })
          .then(() => {
            assert.deepEqual(store.state.answers, answers);
          });
      });
    });

    describe('createQuestionComment()', function () {
      it('', function () {
        const questionId = 'questionX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody, { headers }) {
            assert(url === `/v1/question/${questionId}/comment`);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: comment,
            });
          },
          get(url) {
            assert(url === `/v1/question/${questionId}`);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('createQuestionComment', { questionId, body })
          .then(() => {
            assert.deepEqual(store.state.question, question);
          });
      });
    });

    describe('updateQuestionComment()', function () {
      it('', function () {
        const questionId = 'questionX';
        const id = 'commentX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          put(url, reqBody, { headers }) {
            assert(url === `/v1/question/${questionId}/comment/${id}`);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: comment,
            });
          },
          get(url) {
            assert(url === `/v1/question/${questionId}`);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('updateQuestionComment', { questionId, id, body })
          .then(() => {
            assert.deepEqual(store.state.question, question);
          });
      });
    });

    describe('createAnswerComment()', function () {
      it('', function () {
        const questionId = 'questionX';
        const answerId = 'answerX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody, { headers }) {
            assert(url === `/v1/answer/${answerId}/comment`);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: comment,
            });
          },
          get(url, { params }) {
            assert(url === '/v1/answer');
            assert(params.questionId === questionId);
            return Promise.resolve({
              data: answers,
            });
          },
        });
        return store.dispatch('createAnswerComment', { questionId, answerId, body })
          .then(() => {
            assert.deepEqual(store.state.answers, answers);
          });
      });
    });

    describe('updateAnswerComment()', function () {
      it('', function () {
        const questionId = 'questionX';
        const answerId = 'answerX';
        const id = 'commentX';
        const body = 'bodyX';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          put(url, reqBody, { headers }) {
            assert(url === `/v1/answer/${answerId}/comment/${id}`);
            assert(reqBody.body === body);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: comment,
            });
          },
          get(url, { params }) {
            assert(url === '/v1/answer');
            assert(params.questionId === questionId);
            return Promise.resolve({
              data: answers,
            });
          },
        });
        return store.dispatch('updateAnswerComment', {
          questionId, answerId, id, body,
        })
          .then(() => {
            assert.deepEqual(store.state.answers, answers);
          });
      });
    });

    describe('createQuestionVote()', function () {
      it('', function () {
        const questionId = 'questionX';
        const voteType = 'like';
        setCredential();
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody, { headers }) {
            assert(url === `/v1/question/${questionId}/vote/${voteType}`);
            assert(headers.Authorization === key);
            return Promise.resolve({
              data: question,
            });
          },
          get(url) {
            assert(url === `/v1/question/${questionId}`);
            return Promise.resolve({
              data: question,
            });
          },
        });
        return store.dispatch('createQuestionVote', {
          questionId, voteType,
        })
          .then(() => {
            assert.deepEqual(store.state.question, question);
          });
      });
    });

    describe('retrieveBook()', function () {
      it('', function () {
        const id = 'bookX';
        rewiredApi.__Rewire__('HttpClient', {
          get(url) {
            assert(url === `/v1/book/${id}`);
            return Promise.resolve({
              data: book,
            });
          },
        });
        return store.dispatch('retrieveBook', { id })
          .then(() => {
            assert.deepEqual(store.state.book, book);
          });
      });
    });

    describe('retrieveBooks()', function () {
      it('', function () {
        rewiredApi.__Rewire__('HttpClient', {
          get(url) {
            assert(url === '/v1/book');
            return Promise.resolve({
              data: books,
            });
          },
        });
        return store.dispatch('retrieveBooks')
          .then(() => {
            assert.deepEqual(store.state.books, books);
          });
      });
    });

    describe('createBook()', function () {
      it('', function () {
        const title = 'titleX';
        const author = 'bodyX';
        rewiredApi.__Rewire__('HttpClient', {
          post(url, reqBody) {
            assert(url === '/v1/book');
            assert(reqBody.title === title);
            assert(reqBody.author === author);
            return Promise.resolve({
              data: book,
            });
          },
        });
        return store.dispatch('createBook', { title, author })
          .then(() => {
            assert.deepEqual(store.state.book, {});
            assert.deepEqual(store.state.books, []);
          });
      });
    });

    describe('updateBook()', function () {
      it('', function () {
        const id = 'bookX';
        const title = 'titleX';
        const author = 'bodyX';
        rewiredApi.__Rewire__('HttpClient', {
          put(url, reqBody) {
            assert(url === `/v1/book/${id}`);
            assert(reqBody.title === title);
            assert(reqBody.author === author);
            return Promise.resolve({
              data: book,
            });
          },
        });
        return store.dispatch('updateBook', { id, title, author })
          .then(() => {
            assert.deepEqual(store.state.book, book);
          });
      });
    });
  });
});
