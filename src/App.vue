<template>
  <div id="app">
    <Game v-if="started" />
    <div v-else class="welcome">
      <p>Welcome to <b>WAR!</b> Press 'Start Game' to begin.</p>
      <button @click.prevent="eventStartGame">Start Game</button>
    </div>
  </div>
</template>

<script>
import './assets/style.css';
import Game from './components/Game.vue';

export default {
  name: 'App',
  components: {
    Game
  },
  data: () => {
    return {
      started: false,
    };
  },
  methods: {
    eventStartGame () {
      this.started = true;
    },
  },
};
</script>
