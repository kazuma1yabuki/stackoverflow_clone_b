import Vue from 'vue';
import Router from 'vue-router';
import LoginPage from '@/pages/LoginPage';
import QuestionListPage from '@/pages/QuestionListPage';
import QuestionDetailPage from '@/pages/QuestionDetailPage';
import QuestionCreationPage from '@/pages/QuestionCreationPage';
import UserDetailPage from '@/pages/UserDetailPage';
import BookListPage from '@/pages/BookListPage';
import BookDetailPage from '@/pages/BookDetailPage';
import BookCreationPage from '@/pages/BookCreationPage';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/login',
      name: 'LoginPage',
      component: LoginPage,
    },
    {
      path: '/',
      name: 'QuestionListPage',
      component: QuestionListPage,
    },
    {
      path: '/question/create',
      name: 'QuestionCreationPage',
      component: QuestionCreationPage,
    },
    {
      path: '/question/:id',
      name: 'QuestionDetailPage',
      component: QuestionDetailPage,
    },
    {
      path: '/user/:id',
      name: 'UserDetailPage',
      component: UserDetailPage,
    },
    // book example
    {
      path: '/book',
      name: 'BookListPage',
      component: BookListPage,
    },
    {
      path: '/book/create',
      name: 'BookCreationPage',
      component: BookCreationPage,
    },
    {
      path: '/book/:id',
      name: 'BookDetailPage',
      component: BookDetailPage,
    },
  ],
});
