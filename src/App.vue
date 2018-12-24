<template>
  <div id="app">
    <b-container>
      <S3FileUpload />
    </b-container>
  </div>
</template>

<script>
import S3FileUpload from './components/S3FileUpload';
export default {
  name: 'app',
  components: {
    S3FileUpload,
  },
  data () {
    return {
      file: []
    }
  },
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
