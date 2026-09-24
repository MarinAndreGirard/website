import PhotoSwipeLightbox from '../photoswipe/photoswipe-lightbox.esm.min.js';

const lightbox = new PhotoSwipeLightbox({
  gallery: '#quarto-document-content',
  children: 'a.original-photo',
  pswpModule: () => import('../photoswipe/photoswipe.esm.min.js'),
  initialZoomLevel: 'fit',
  secondaryZoomLevel: 1,
  maxZoomLevel: 2,
  wheelToZoom: true,
  preload: [0, 1],
  loop: false,
  showHideAnimationType: 'fade',
  errorMsg: 'The original could not load. Use “Original” to open it directly and try again.'
});
lightbox.on('uiRegister', () => {
  lightbox.pswp.ui.registerElement({
    name: 'original', order: 8, isButton: true, tagName: 'a',
    html: 'Original', ariaLabel: 'Open original full-resolution image',
    onInit: (link, pswp) => {
      link.target = '_blank';
      link.rel = 'noopener';
      pswp.on('change', () => { link.href = pswp.currSlide.data.src; });
    }
  });
});
lightbox.init();
