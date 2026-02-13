import type { StrapiApp } from '@strapi/strapi/admin';

export default {
  config: {
    // Locales permitidos
    locales: ['en', 'es'],

    // 1. Logos y Favicon (Asegúrate de tenerlos en src/admin/extensions/)
    head: {
      favicon: './extensions/favicon.ico',
    },
    auth: {
      logo: './extensions/logo-login.png', 
    },
    menu: {
      logo: './extensions/logo-menu.png',
    },

    // 2. Traducciones y Nombre de la App
    translations: {
      es: {
        'app.components.LeftMenu.navbrand.title': 'Mi Panel',
        'app.components.LeftMenu.navbrand.workplace': 'Producción',
        'Auth.form.welcome.title': 'Bienvenido',
        'Auth.form.welcome.subtitle': 'Inicia sesión en tu cuenta',
      },
      en: {
        'app.components.LeftMenu.navbrand.title': 'My Dashboard',
        'app.components.LeftMenu.navbrand.workplace': 'Production',
      },
    },

    // 3. Tema Completo (Elimina el morado y aplica tu paleta)
    theme: {
      light: {
        colors: {
          // Primarios (Tu Azul)
          primary100: '#e6f5fc',
          primary200: '#80ceee',
          primary500: '#009DDC',
          primary600: '#008bc4', // Este elimina la mayoría del morado en selecciones
          primary700: '#0079ab',
          
          // Botones y Acciones (Para forzar el azul)
          buttonPrimary500: '#009DDC',
          buttonPrimary600: '#008bc4',
          action100: '#e6f5fc',
          action500: '#009DDC',
          action600: '#008bc4',

          // Secundarios (Tu Verde)
          success100: '#ecf6ed',
          success600: '#3FA34D',
          success700: '#32823d',

          // Neutros (Tus Grises)
          neutral0: '#ffffff',    // --color-base-100
          neutral100: '#f8f9fa',  // --color-base-200
          neutral150: '#e9ecef',  // --color-base-300
          neutral800: '#212529',  // --color-base-content
        },
        shadows: {
          filterShadow: 'rgba(33, 37, 41, 0.1) 0px 2px 4px',
        },
        borderRadius: '12px', // Tu --radius-field (0.75rem)
      },
      dark: {
        colors: {
          // Primarios en modo oscuro
          primary100: '#002d40',
          primary200: '#009DDC',
          primary500: '#009DDC',
          primary600: '#33b1e3', // Azul más brillante para contraste
          primary700: '#4dc4f0',

          buttonPrimary500: '#009DDC',
          action100: '#002d40',
          action500: '#009DDC',

          // Fondos Oscuros (Basados en tus colores neutrales)
          neutral0: '#1a1a1a',    // Fondo principal profundo
          neutral100: '#212529',  // Tarjetas y elementos elevados
          neutral150: '#2c3136',  // Bordes
          neutral800: '#f8f9fa',  // Texto claro
        },
        borderRadius: '12px',
      },
    },
  },

  bootstrap(app: StrapiApp) {
    console.log('Cargando interfaz personalizada...');
  },
};