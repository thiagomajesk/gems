const SPEED_MULTIPLIER = 3;
const SCROLL_INTERVAL = 300;

export default {
  timeout: null,
  accumulated: 0,
  mounted() {
    this.el.addEventListener("wheel", (event) => {
      this.accumulated += SPEED_MULTIPLIER;

      if (this.timeout != null) clearTimeout(this.timeout);

      this.timeout = setTimeout(() => (this.accumulated = 0), SCROLL_INTERVAL);

      this.el.scrollLeft += event.deltaY * this.accumulated;
    });
  },
};
