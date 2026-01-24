# Options specific to development only
{
    modules => [
        'Template',
        'JSON',
        'Logger',
        'Runtime::Development',
    ],

    # Add StackTrace in development
    '+middleware'   => ['StackTrace'],
    middleware_init => {
        StackTrace => {
            force => 1,
        },
    },

    modules_init => {
        # One log for errors and one for debug
        Logger => {
            '+outputs' => [
                [
                    'Screen',
                    name      => 'debug',
                    min_level => 'debug',
                    max_level => 'notice',
                    stderr => 0,
                    newline => 1,
                    utf8 => 1,
                ],
            ],
        },
    },

    api_version => 'v0',

    db_file => './db/development.db',

    dbi => [
        'dbi:SQLite:dbname=./db/development.db',
        q{},
        q{},
        {
            RaiseError                       => 1,
            PrintError                       => 0,
            AutoCommit                       => 1,
            sqlite_unicode                   => 1,
            sqlite_allow_multiple_statements => 1,
        },
    ],

    dbh_pragmas => [
        'PRAGMA foreign_keys = ON;',
        'PRAGMA journal_mode = WAL;',
        'PRAGMA synchronous = NORMAL',
    ],

    # ROLE_TEST
    default_role => 3,

    repository_bsae => '/tmp',
};

