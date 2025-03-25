<?php
/**
 * The base configuration for Wordpress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'vt' );

/** Database username */
define( 'DB_USER', 'vt' );

/** Database password */
define( 'DB_PASSWORD', 'vt' );

/** Database hostname */
define( 'DB_HOST', '192.168.8.131' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'H?%6Q&UEV.fx9l^6i-7KvMai$=AZ/+1LnQm4aoH-S6looUbOk+b9~<}])WLfhLmr');
define('SECURE_AUTH_KEY',  'W6[:dM4SR0|9yj<CVH-}P=WGkdB8:7_g,Qi+}.n*@.#m(/OW~K7I#lD[D?^2KlX-');
define('LOGGED_IN_KEY',    '~Co#|s>*ZF.cP<fme*VxD}|C4jaol|H) H2M)53a(-!Ty(bd1v.rXbEj{b{_>^y4');
define('NONCE_KEY',        'wz8@sy{-5z)AQ7P|o=sDx0B0jD| W~!<AuN+{o:Ti87+o@LV~+%l[O`S>1f eUqt');
define('AUTH_SALT',        '0my4]Nf1tZK1x9v8V}~?ro2P6t$1HUM,$)XyFj#!O|Qf;dY--$+H2L& h%7u(6$4');
define('SECURE_AUTH_SALT', 'Q8HS0XtduUsgdGWC!B1c83Qq%#m|f-q&+q]A^uY9;*M!L31LtV.ujI<DRG`g7$bO');
define('LOGGED_IN_SALT',   ']?#jOND]Pkkif$D|bN[+Y]~WUTeHa*klSPWZchWjZ#x`.Lhd<w7{rlRR7QaRtu7]');
define('NONCE_SALT',       'J`QPK.8D/x4](]C^z^nb;%eIh4J)a%Lo`(h<2.8sn2P~3^.{[0gG}/ 8vIhv.bkU');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
