<template>
  <div class="player">
    <h2>Player {{ number }}</h2>
    <div class="card">
      <img :src="card.image" :alt="card.code" />
    </div>
  </div>
</template>

<script>
export default {
  name: 'Player',
  props: {
    number: Number,
    card: Object, // { image, code }
  }
};
</script>
