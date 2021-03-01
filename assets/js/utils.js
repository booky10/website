$(document).ready(function () {
  $(".fade-out").show().fadeOut(1000);
  $(".fade-in").hide().fadeIn(1000);
  $(".hide").hide();
});

function writeCopyright() {
  if (document.cookie.startsWith("lang=de"))
    document.write("&copy; " + new Date().getFullYear() + " booky.tk, gemacht von booky10.");
  else
    document.write("&copy; " + new Date().getFullYear() + " booky.tk, made by booky10.");
}
