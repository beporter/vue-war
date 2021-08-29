<template>
  <div class="game">

    <div class="players" v-bind="decks">
      <Player v-for="(deck, i) in decks" :key="`${i}${deck.remaining}`" :number="i" :card="cards[i]" />
    </div>

    <Scoreboard :scores="scores" />

    <button v-if="!gameOver" @click.prevent="eventNextRound">Draw Cards</button>
    <p v-else>Game Over! Player {{ winningPlayer() }} wins!</p>

  </div>
</template>

<script>
// Will control the entire game. This is a top-down monolith.

import axios from 'axios';
import Player from './Player.vue';
import Scoreboard from './Scoreboard.vue';

// Order matters for scoring here.
const CARD_VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'JACK', 'QUEEN', 'KING', 'ACE'];

export default {
  name: 'Game',
  components: {
    Player,
    Scoreboard,
  },
  props: {
    msg: String
  },
  data: () => {
    return {
      decks: [{remaining: 100}, {remaining: 100}], // This "priming" crudely works around the initial render being "empty" otherwise.
      cards: [],
      scores: [],
      gameOver: false,
    };
  },
  created () {
    let promises = [];
    for(const i of [0, 1]) {
      promises.push(this.fetchDeck().then((deck) => {
        this.$set(this.decks, i, deck);
      }));
      // Jump through Vue reactivity hoops.
      this.$set(this.cards, i, { image: '#' });
      this.$set(this.scores, i, 0);
    }
    Promise.all(promises).then(this.eventNextRound);
  },
  methods: {
    fetchDeck() {
      return axios
        .get('http://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1')
        .then((response) => {
          return response.data;
        });
        // TODO: Error handling.
    },
    fetchNextCard(deck) {
      return axios
        .get(`http://deckofcardsapi.com/api/deck/${deck.deck_id}/draw/?count=1`)
        .then((response) => {
          if(response.data.remaining == 0) {
            this.gameOver = true;
          }
          return response.data.cards[0];
        });
        // TODO: Error handling.
    },
    eventNextRound() {
      let promises = [];
      this.decks.forEach((deck, i) => {
        promises.push(this.fetchNextCard(deck).then((card) => {
          this.$set(this.cards, i, card);
        }));
      });

      Promise.all(promises).then(this.scoreRound);
    },
    scoreRound() {
      let maxValue = -1;
      let maxValueIndex = -1;
      this.cards.forEach((card, i) => {
        if (CARD_VALUES.indexOf(card.value) > maxValue) {
          maxValue = card.value;
          maxValueIndex = i;
        }
      });

      this.$set(this.scores, maxValueIndex, this.scores[maxValueIndex] + 1);
    },
    winningPlayer () {
      return this.scores.indexOf(Math.max(...this.scores))
    },
  },
};
</script>
