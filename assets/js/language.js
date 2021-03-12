function setLanguage(language) {
  document.cookie = 'language=' + language + '; path=/';
  reloadText(getLanguage());
}

function getLanguage() {
  const cookies = document.cookie.split(';');

  for (let i = 0; i < cookies.length; i++) {
    let cookie = cookies[i];
    while (cookie.charAt(0) === ' ') cookie = cookie.substring(1, cookie.length);
    if (cookie.indexOf('language=') === 0) return cookie.substring(9, cookie.length);
  }

  // noinspection JSDeprecatedSymbols
  const userLang = navigator.language || navigator.userLanguage;
  return userLang ? userLang.split('-')[0] : 'en';
}

function reloadText(language) {
  const i18n = document.getElementsByClassName('i18n');
  if (i18n.length <= 0) return;

  getJSON('../assets/language/' + language + '.json')
    .then((json) => {
      for (let i = 0; i < i18n.length; i++) {
        const element = i18n.item(i), key = element.getAttribute('translation');

        let text = eval('json.translations.' + key);
        text = text.replaceAll('$CURRENT_YEAR', new Date().getFullYear());

        if (element.hasAttribute('arguments')) {
          const arguments = JSON.parse(element.getAttribute('arguments'));
          Object.keys(arguments).forEach((replaceKey) => text = text.replaceAll(replaceKey, eval('arguments.' + replaceKey)));
        }

        element.innerHTML = text;
      }
    })
    .catch((error) => console.error(error));
}

function getJSON(file) {
  return new Promise(((resolve, reject) => {
    try {
      const request = new XMLHttpRequest();
      request.overrideMimeType('application/json');

      request.open('GET', file, true);
      request.onreadystatechange = () => {
        if (request.readyState !== 4 || request.status !== 200) return;
        resolve(JSON.parse(request.responseText));
      };

      request.send(null);
    } catch (error) {
      reject(error);
    }
  }));
}

reloadText(getLanguage());
