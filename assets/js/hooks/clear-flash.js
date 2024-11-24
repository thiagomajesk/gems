const HIDE_AFTER = 5000;
const CLEAR_AFTER = HIDE_AFTER + 500;

export default {
  mounted() {
    this.hideTimeout = this.hideFlash();
    this.clearTimeout = this.clearFlash();
  },

  destroyed() {
    clearTimeout(this.hideTimeout);
    clearTimeout(this.clearTimeout);
  },

  hideFlash() {
    setTimeout(() => {
      this.el.style.opacity = 0;
    }, HIDE_AFTER);
  },

  clearFlash() {
    setTimeout(() => {
      this.pushEvent("lv:clear-flash");
    }, CLEAR_AFTER);
  },
};
