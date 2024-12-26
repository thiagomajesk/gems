import { parseHookProps } from "../utils/attribute";

const UPDATE_INTERVAL = 1000;
const REQUIRED_PROPS = ["duration", "remaining"];

export default {
  interval: null,

  initialize() {
    const { remaining, duration } = parseHookProps(this.el, REQUIRED_PROPS);
    const progress = 100 - ((remaining ?? duration) / duration) * 100;

    this.animate = remaining != null;
    this.el.value = Math.floor(progress);
    this.increment = duration / UPDATE_INTERVAL;
  },

  mounted() {
    this.initialize();
    this.updateDOM();
  },

  updated() {
    this.initialize();
    this.updateDOM();
  },

  destroyed() {
    clearInterval(this.interval);
  },

  updateDOM() {
    clearInterval(this.interval);

    if (!this.animate) return;

    this.interval = setInterval(() => {
      this.el.value += this.increment;
    }, UPDATE_INTERVAL);
  },
};
