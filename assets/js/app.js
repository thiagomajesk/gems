import "./phx";
import "./events";
import "iconify-icon";
import autoAnimate from "@formkit/auto-animate";
import { observe } from "selector-observer";

/*
 * Detect if existing or new auto animate elements
 * have been added to the DOM and initialize them.
 */
observe("[data-auto-animate]", {
  initialize: (element) => autoAnimate(element),
});

/*
 * Make sure to reinitialize all plugins when we navigate.
 * Because we receive two page-loading-stop events, we only
 * want to make sure we are running the initialization code only once.
 */
window.addEventListener("phx:page-loading-stop", (info) => {
  if (info.detail.kind != "initial") return;
  // TODO: Initialize any plugin that doesn't handle dynamic elements
});
