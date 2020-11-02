$(document).ready(function () {
  $(".fade-out").show().fadeOut(1000);
  $(".fade-in").hide().fadeIn(1000);
  $(".hide").hide();
});

function setLanguage(language) {
  document.cookie = "lang=" + language + "; path=/";
  location.reload();
}

function refreshLanguageText() {
  $(".lang-de").hide();
  $(".lang-en").hide();

  if (document.cookie.startsWith("lang=de")) {
    $(".lang-de").show();
    updateLanguageText("Deutsch");
  } else if (document.cookie.startsWith("lang=")) {
    var userLang = navigator.language || navigator.userLanguage;
    if (userLang == "de-DE")
      setLanguage("de")
    else
      setLanguage("en")
  } else {
    $(".lang-en").show();
    updateLanguageText("English");
  }
}

function updateLanguageText(lang) {
  $("#lang-text").text(lang);
}

function writeCopyright() {
  if (document.cookie.startsWith("lang=de")) {
    document.write(
      "&copy; " + new Date().getFullYear() + " booky.tk, gecodet von booky10."
    );
  } else {
    document.write(
      "&copy; " + new Date().getFullYear() + " booky.tk, made by booky10."
    );
  }
}

function addLines(amount) {
  for (let i = 0; i < amount; i++) document.write("<br>");
}
