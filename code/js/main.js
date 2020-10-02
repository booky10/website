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
    $(".lang-de").fadeIn(1000);
    updateLanguageText("Deutsch");
  } else {
    $(".lang-en").fadeIn(1000);
    updateLanguageText("English");
  }
}

function updateLanguageText(lang) {
  $("#lang-text").text(lang);
}

function writeCopyright() {
  document.write(
    "&copy; " + new Date().getFullYear() + " booky.tk. Made by booky10."
  );
}

function addLines(amount) {
  for (let i = 0; i < amount; i++) document.write("<br>");
}
