(function () {
  var loading = null;

  function loadHeic2any() {
    if (window.heic2any) return Promise.resolve(window.heic2any);
    if (loading) return loading;
    loading = new Promise(function (resolve, reject) {
      var script = document.createElement('script');
      script.src = 'heic/heic2any.min.js';
      script.onload = function () {
        if (window.heic2any) resolve(window.heic2any);
        else reject(new Error('heic2any failed to load'));
      };
      script.onerror = function () {
        script.src =
          'https://cdn.jsdelivr.net/npm/heic2any@0.0.4/dist/heic2any.min.js';
        script.onload = function () {
          if (window.heic2any) resolve(window.heic2any);
          else reject(new Error('heic2any failed to load'));
        };
        script.onerror = reject;
      };
      document.head.appendChild(script);
    });
    return loading;
  }

  window.__fieldNotesDecodeHeic = function (bytes) {
    return loadHeic2any().then(function (heic2any) {
      var blob = new Blob([bytes], { type: 'image/heic' });
      return heic2any({ blob: blob, toType: 'image/png' });
    }).then(function (result) {
      return Array.isArray(result) ? result[0] : result;
    });
  };
})();
