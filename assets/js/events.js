import topbar from "topbar";

topbar.config({
  shadowColor: "rgba(0, 0, 0, .3)",
  barColors: { 0: "#9580FF", "1.0": "#80FFEA" },
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(500));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());
