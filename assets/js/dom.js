/*
 * https://github.com/livebook-dev/livebook/blob/main/assets/js/dom.js
 */
export const morphdomOptions = {
  onBeforeElUpdated(from, to) {
    // Keep data-js-* attributes we set on the client.
    for (const attr of from.attributes) {
      if (attr.name.startsWith("data-js-")) {
        to.setAttribute(attr.name, attr.value);
      }

      // Signals which other attributes to keep
      if (attr.name === "data-keep-attr") {
        if (from.hasAttribute(attr.value)) {
          to.setAttribute(attr.value, from.getAttribute(attr.value));
        } else {
          to.removeAttribute(attr.value);
        }
      }
    }
  },

  onNodeAdded(node) {
    // Mimic autofocus for dynamically inserted elements
    if (node.nodeType === Node.ELEMENT_NODE && node.hasAttribute("autofocus")) {
      node.focus();

      if (node.setSelectionRange && node.value) {
        const lastIndex = node.value.length;
        node.setSelectionRange(lastIndex, lastIndex);
      }
    }
  },
};
