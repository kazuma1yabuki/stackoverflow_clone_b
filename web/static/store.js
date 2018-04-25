import Vue from 'vue';
import Vuex from 'vuex';
import HttpClient from '@/utils/HttpClient';

/* eslint-disable no-param-reassign */

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    question: {},
    answers: [],
    questions: [],
    email: localStorage.getItem('email') || '',
    key: localStorage.getItem('key') || '',
    id: localStorage.getItem('id') || '',
    expiresAt: localStorage.getItem('expiresAt') || '',
    // book example
    book: {},
    books: [],
  },
  mutations: {
    updateCurrentQuestion(state, question) {
      state.question = question;
    },
    updateQuestions(state, questions) {
      state.questions = questions;
    },
    addQuestion(state, question) {
      state.questions.push(question);
    },
    updateAnswers(state, answers) {
      state.answers = answers;
    },
    addAnswer(state, answer) {
      state.answers.push(answer);
    },
    setCredential(state, {
      email, key, id, expiresAt,
    }) {
      state.email = email;
      state.key = key;
      state.id = id;
      state.expiresAt = expiresAt;
      localStorage.setItem('email', email);
      localStorage.setItem('key', key);
      localStorage.setItem('id', id);
      localStorage.setItem('expiresAt', expiresAt);
    },
    clearCredential(state) {
      ['email', 'key', 'id', 'expiresAt'].forEach((k) => {
        localStorage.removeItem(k);
        state[k] = '';
      });
    },
    // book example
    setBook(state, book) {
      state.book = book;
    },
    setBooks(state, books) {
      state.books = books;
    },
  },
  actions: {
    login({ commit }, { email, password }) {
      return HttpClient.post('/v1/user/login', {
        email,
        password,
      })
        .then(({ data: { id, session: { key, expiresAt } } }) => {
          commit('setCredential', {
            email, key, id, expiresAt,
          });
        });
    },
    logout({ commit, state: { key } }) {
      return HttpClient.post(
        '/v1/user/logout',
        {},
        { headers: { Authorization: key } },
      ).finally(() => {
        commit('clearCredential');
      });
    },
    retrieveCurrentQuestion({ commit }, { id }) {
      return HttpClient.get(`/v1/question/${id}`)
        .then(({ data }) => {
          commit('updateCurrentQuestion', data);
        });
    },
    updateCurrentQuestion({ commit, state: { key } }, { id, title, body }) {
      return HttpClient.put(
        `/v1/question/${id}`,
        {
          title,
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(({ data }) => {
          commit('updateCurrentQuestion', data);
        });
    },
    retrieveQuestions({ commit }, { userId } = {}) {
      return HttpClient.get('/v1/question', { params: { userId } })
        .then(({ data }) => {
          commit('updateQuestions', data);
        });
    },
    createQuestion({ commit, state: { key } }, { title, body }) {
      return HttpClient.post(
        '/v1/question',
        {
          title,
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(({ data }) => {
          commit('addQuestion', data);
        });
    },
    retrieveAnswers({ commit }, { questionId, userId }) {
      return HttpClient.get('/v1/answer', { params: { questionId, userId } })
        .then(({ data }) => {
          commit('updateAnswers', data);
        });
    },
    createAnswer({ commit, state: { key } }, { questionId, body }) {
      return HttpClient.post(
        '/v1/answer',
        {
          questionId,
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(({ data }) => {
          commit('addAnswer', data);
        });
    },
    updateAnswer({ dispatch, state: { key } }, { questionId, id, body }) {
      return HttpClient.put(
        `/v1/answer/${id}`,
        {
          body: body,
        },
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveAnswers', { questionId }));
    },
    createCurrentQuestionComment({ dispatch, state: { key } }, { questionId, body }) {
      return HttpClient.post(
        `/v1/question/${questionId}/comment`,
        {
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveCurrentQuestion', { id: questionId }));
    },
    updateCurrentQuestionComment({ dispatch, state: { key } }, { questionId, id, body }) {
      return HttpClient.put(
        `/v1/question/${questionId}/comment/${id}`,
        {
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveCurrentQuestion', { id: questionId }));
    },
    createAnswerComment({ dispatch, state: { key } }, { questionId, id, body }) {
      return HttpClient.post(
        `/v1/answer/${id}/comment`,
        {
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveAnswers', { questionId }));
    },
    updateAnswerComment({ dispatch, state: { key } }, {
      questionId, answerId, id, body,
    }) {
      return HttpClient.put(
        `/v1/answer/${answerId}/comment/${id}`,
        {
          body,
        },
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveAnswers', { questionId }));
    },
    createCurrentQuestionVote({ dispatch, state: { key } }, { questionId, voteType }) {
      return HttpClient.post(
        `/v1/question/${questionId}/vote/${voteType}`,
        {},
        { headers: { Authorization: key } },
      )
        .then(() => dispatch('retrieveCurrentQuestion', { id: questionId }));
    },
    // book example
    retrieveBook({ commit }, { id }) {
      return HttpClient.get(`/v1/book/${id}`)
        .then(({ data }) => {
          commit('setBook', data);
        });
    },
    retrieveBooks({ commit }) {
      return HttpClient.get('/v1/book')
        .then(({ data }) => {
          commit('setBooks', data);
        });
    },
    createBook(_context, { title, author }) {
      return HttpClient.post(
        '/v1/book',
        {
          title,
          author,
        },
      );
    },
    updateBook({ commit }, { id, title, author }) {
      return HttpClient.put(
        `/v1/book/${id}`,
        {
          title,
          author,
        },
      )
        .then(({ data }) => {
          commit('setBook', data);
        });
    },
  },
});
