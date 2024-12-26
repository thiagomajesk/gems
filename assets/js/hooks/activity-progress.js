import { parseHookProps } from "../utils/attribute";

const UPDATE_INTERVAL = 1000;
const REQUIRED_PROPS = ["animate"];

export default {
  interval: null,

  initialize() {
    this.props = parseHookProps(this.el, REQUIRED_PROPS);
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
    if (!this.props.animate) return;

    this.interval = setInterval(() => {
      this.el.value += UPDATE_INTERVAL;
    }, UPDATE_INTERVAL);
  },
};
