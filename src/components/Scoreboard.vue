<template>
  <div class="scoreboard">
    <h2>Scores</h2>
    <ul>
      <li v-for="(score, player_number) in scores" :key="`${player_number}_${score}`">
        Player {{ player_number }}: <b>{{ score }}</b>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Scoreboard',
  props: {
    scores: Array,
  }
};
</script>
