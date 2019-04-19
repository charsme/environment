<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Beanstalkd UI Configuration
    |--------------------------------------------------------------------------
    |
    | This file stores the configuration parameters to connect to our
    | Beanstalkd Server. By default the default Beanstalkd server
    | parameters are used. But feel free to override then below.
    |
    */

    'host' => env('BEANSTALKD_HOST', '127.0.0.1'),

    'port' => env('BEANSTALKD_PORT', '11300'),

    /*
    |--------------------------------------------------------------------------
    | Route Middleware
    |--------------------------------------------------------------------------
    |
    | Here you can specify the route middleware that should be applied the
    | Admin UI routes. By default we simply require the user to be
    | logged in. If you have any additional authorization to
    | perform, this would be the place to specify it.
    |
    */

    'middleware' => explode(',', env('BEANSTALKD_MIDDLEWARE', 'web')),

    /*
    |--------------------------------------------------------------------------
    | Route Prefix
    |--------------------------------------------------------------------------
    |
    | Here you can specify the route prefix that should be applied the
    | Admin UI routes.
    |
    */
    'prefix' => env('BEANSTALKD_PREFIX', ''),

    /*
    |--------------------------------------------------------------------------
    | Failed Jobs
    |--------------------------------------------------------------------------
    |
    | If you do not want to be able to manage your failed jobs through
    | the UI as well, simply change this setting to `false`.
    |
    */

    'failed_jobs' => env('BEANSTALKD_SHOW_FAILED', true),

    'failed_jobs_table' => env('BEANSTALKD_FAILED_TABLE', 'failed_jobs'),
];
