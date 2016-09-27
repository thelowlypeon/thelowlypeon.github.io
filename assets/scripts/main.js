if (/iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream) {
  Array.from(document.getElementsByClassName('hidden apple-news-container')).forEach(function(el) {
    el.className = (el.className || '').replace(/hidden/g, '');
  })
}
