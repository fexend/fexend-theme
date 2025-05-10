<template>
  <div class="counter">
    <h2>{{ title }}</h2>
    <div class="counter-display">{{ count }}</div>
    <div class="counter-controls">
      <button @click="increment">Increment</button>
      <button @click="decrement" :disabled="count <= 0">Decrement</button>
      <button @click="reset">Reset</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "Counter",
  props: {
    title: {
      type: String,
      default: "Counter",
    },
    initialValue: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      count: this.initialValue,
    };
  },
  methods: {
    increment() {
      this.count++;
      this.$emit("change", this.count);
    },
    decrement() {
      if (this.count > 0) {
        this.count--;
        this.$emit("change", this.count);
      }
    },
    reset() {
      this.count = this.initialValue;
      this.$emit("reset", this.count);
    },
  },
  watch: {
    initialValue(newVal) {
      this.count = newVal;
    },
  },
};
</script>

<style scoped>
.counter {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 4px;
  max-width: 300px;
  text-align: center;
}

.counter-display {
  font-size: 48px;
  font-weight: bold;
  margin: 20px 0;
  color: #333;
}

.counter-controls {
  display: flex;
  justify-content: space-between;
}

button {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  background-color: #3498db;
  color: white;
  cursor: pointer;
  font-size: 14px;
}

button:hover {
  background-color: #2980b9;
}

button:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}
</style>
