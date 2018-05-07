<template>
  <div>
    <top-header
      @logout="logout"
    />
    <div class="main">
      <transition
        appear
        name="fade"
        mode="out-in">
        <router-view/>
      </transition>
    </div>
  </div>
</template>

<script>
import Header from '@/components/Header';

export default {
  components: {
    TopHeader: Header,
  },
  methods: {
    logout() {
      this.$store.dispatch('logout')
        .then(() => {
          this.$router.push({ path: '/login' });
        });
    },
  },
};
</script>

<style scoped>
.main {
  width: 80%;
  margin: 30px auto auto auto;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity .3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
