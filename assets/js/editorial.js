(function () {
  function initEditorialNavigation() {
    var nav = document.getElementById("site-nav");
    if (!nav) return;

    var button = nav.querySelector("button");
    var hiddenLinks = nav.querySelector(".hidden-links");
    if (!button || !hiddenLinks) return;

    function updateButtonState() {
      var isOpen = !hiddenLinks.classList.contains("hidden");
      button.setAttribute("aria-expanded", isOpen ? "true" : "false");
      button.setAttribute("aria-label", isOpen ? "Close navigation" : "Open navigation");
    }

    updateButtonState();

    var observer = new MutationObserver(updateButtonState);
    observer.observe(button, { attributes: true, attributeFilter: ["class"] });
    observer.observe(hiddenLinks, { attributes: true, attributeFilter: ["class"] });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initEditorialNavigation);
  } else {
    initEditorialNavigation();
  }
})();
