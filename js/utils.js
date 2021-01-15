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
    const lang_de = $(".lang-de");
    const lang_en = $(".lang-en");

    lang_de.hide();
    lang_en.hide()

    if (document.cookie.startsWith("lang=de")) lang_de.show();
    else if (document.cookie.startsWith("lang=en")) lang_en.show();
    else {
        const userLang = navigator.language || navigator.userLanguage;
        if (userLang === "de-DE") setLanguage("de")
        else setLanguage("en")
    }
}

function writeCopyright() {
    if (document.cookie.startsWith("lang=de"))
        document.write("&copy; " + new Date().getFullYear() + " booky.tk, gecodet von booky10.");
    else
        document.write("&copy; " + new Date().getFullYear() + " booky.tk, made by booky10.");
}

function addLines(amount) {
    for (let i = 0; i < amount; i++) document.write("<br>");
}
