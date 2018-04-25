<template>
  <div class="main">
    <form @submit.prevent="submit">
      <label>
        Email:
        <input
          v-model="email"
          class="email-edit"
          type="email"
          required>
      </label>
      <label>Password:
        <input
          v-model="password"
          class="password-edit"
          type="password"
          minlength="8"
          required>
      </label>
      <button type="submit">ログイン</button>
      <div class="error-message">{{ errorMsg }}</div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',
  data() {
    return {
      email: '',
      password: '',
      errorMsg: '',
    };
  },
  methods: {
    submit() {
      this.$store.dispatch('login', { email: this.email, password: this.password })
        .then(() => {
          this.$router.push({ path: '/' });
        })
        .catch(() => {
          this.errorMsg = 'ログインに失敗しました';
        });
    },
  },
};
</script>

<style scoped>
.main {
  margin: 20% auto auto auto;
  background-color: #f7f7f7;
  width: 500px;
}
.error-message {
  color: red;
}
</style>
