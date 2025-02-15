import { listIcons, loadIcons } from "iconify-icon";

const ICON_LIST = listIcons("", "game-icons");

export default {
  mounted() {
    loadIcons(ICON_LIST, (loaded) => {
      const icons = loaded.flatMap((icon) => icon.name);
      this.pushEventTo(this.el, "icon-picker:icons", { icons: icons });
    });
  },
};
