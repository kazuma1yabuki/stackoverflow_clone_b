<template>
  <div>
    <top-header
      @logout="logout"
    />
    <div class="main">
      <router-view/>
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
      this.$store.dispatch('logout');
    },
  },
};
</script>

<style scoped>
.main {
  width: 80%;
  margin: 30px auto auto auto;
}
</style>
