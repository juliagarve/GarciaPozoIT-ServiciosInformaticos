<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'DBgarciapozoit' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'labii' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

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
define( 'AUTH_KEY',         'r~u.pvW8TD=?!uFp/=[JZ!P6^2@R)?-y@%!#vnz]eQST3H@I{`K9K*>I(u*U14bK' );
define( 'SECURE_AUTH_KEY',  'f%5A,v5]b[5UHx>M?phQ&Vd>3*)yxEiT]}LGQK9|2>Q8H}DHs`)zz9#Y_Fg=#qEj' );
define( 'LOGGED_IN_KEY',    'a[?jMvL)ZnJU&|pVa2PQs`C}2~lv/+o&EEQkscvq{;w_Hn?yWkxM5&y/ h`<3gp$' );
define( 'NONCE_KEY',        '#!{f~;adr1J=X4me1r]1 N~yQN$2Io%.SR@z!1:t6,07U}_y7!>=9f%E,/H~Y`.E' );
define( 'AUTH_SALT',        'e%_?=#ZT<t-D~{3dd/bX*I@?&hUdzr9~]|ihiF&],c5L`,Y4G?6. $r6~k9<+>D?' );
define( 'SECURE_AUTH_SALT', '*eJyAU=Q,{%eM=~L_SRiks4~Yp#J#LeGjhSv5}#aUE3|iJ`{Io&7nC]L];4o23`{' );
define( 'LOGGED_IN_SALT',   ';(W8%u2)IT_C;m9Ezc!oSS/ i3XC[<yX0?N{.[bNk5 /b8-D!~p+CjgZP >fKAVS' );
define( 'NONCE_SALT',       '6q)9<2HNu{ni:D7=)tlGNzvN9WE0tBw_h[Be)]:cMw_g`1Z#faV46jS4kiU`gHi,' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
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
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
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
