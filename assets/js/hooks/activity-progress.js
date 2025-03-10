import { parseHookProps } from "../utils/attribute";

const UPDATE_INTERVAL = 1000;

const REQUIRED_PROPS = ["timestamp", "main", "trail"];

function clamp(number, min, max) {
  return Math.min(Math.max(number, min), max);
}

function updateProgress(element, progress, delay = 0) {
  setTimeout(() => (element.style.width = `${progress}%`), delay);
}

/**
 * ActivityProgress Hook
 *
 * A LiveView hook that displays and updates a visual progress bar for timed activities.
 *
 * @prop {string} main - CSS selector for the main progress bar element
 * @prop {string} trail - CSS selector for the trailing progress bar element
 * @prop {string} timestamp - ISO timestamp when the activity will end
 */
export default {
  mainEl: null,
  trailEl: null,
  interval: null,
  startTime: null,
  completed: false,

  initialize() {
    this.props = parseHookProps(this.el, REQUIRED_PROPS);

    this.startTime = Date.now();
    this.endTime = new Date(this.props.timestamp);
    this.completed = this.interval && !this.props.timestamp;

    this.mainEl = this.el.querySelector(this.props.main);
    this.trailEl = this.el.querySelector(this.props.trail);
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
    clearTimeout(this.timeout);
    clearInterval(this.interval);
  },

  updateDOM() {
    clearInterval(this.interval);

    // If we receive an empty timestamp from the server and we still have the
    // previous animating running, we force the completion state on the client.
    // Otherwise we'll never reach 100% unless the UPDATE_INTERVAL is super low.
    // Then, after we had the chance to show the animation for 100% progress, cleanup.
    if (this.completed) {
      this.fillProgress();
      setTimeout(() => this.clearProgress(), UPDATE_INTERVAL);
    }

    // Don't animate if we didn't get a valid timestamp from the server.
    // This will only be true if the animation hasn't started yet (on mount).
    if (!this.props.timestamp) return;

    const now = Date.now();
    const elapsedTime = now - this.startTime;
    const totalDuration = this.endTime - this.startTime;

    // We clamp the progress to avoid visual glitches in case the user has
    // a slow connection (causing the client time to be ahead of the server time).
    const progress = clamp((elapsedTime / totalDuration) * 100, 0, 100);

    this.updateIncreasing(progress);

    this.interval = setInterval(() => this.updateDOM(), UPDATE_INTERVAL);
  },

  fillProgress() {
    updateProgress(this.trailEl, 100);
    updateProgress(this.mainEl, 100, UPDATE_INTERVAL / 2);
  },

  clearProgress() {
    updateProgress(this.mainEl, 0);
    updateProgress(this.trailEl, 0, UPDATE_INTERVAL / 2);
  },

  updateIncreasing(progress) {
    updateProgress(this.trailEl, progress);
    updateProgress(this.mainEl, progress, UPDATE_INTERVAL / 2);
  },

  updateDecreasing(progress) {
    updateProgress(this.mainEl, progress);
    updateProgress(this.trailEl, progress, UPDATE_INTERVAL / 2);
  },
};
