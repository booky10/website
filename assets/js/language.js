$(document).ready(function () {
  refreshLanguageText();
});

function setLanguage(language) {
  document.cookie = "lang=" + language + "; path=/";
  location.reload();
}

function refreshLanguageText() {
  const lang_de = $(".lang-de");
  const lang_en = $(".lang-en");

  lang_de.hide();
  lang_en.hide()

  if (document.cookie.startsWith("lang=de"))
    lang_de.show();
  else if (document.cookie.startsWith("lang=en"))
    lang_en.show();
  else {
    // noinspection JSDeprecatedSymbols
    const userLang = navigator.language || navigator.userLanguage;

    if (userLang === "de-DE") setLanguage("de")
    else setLanguage("en")
  }
}
