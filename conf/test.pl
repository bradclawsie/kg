# Options specific to testing only
{
    modules => [
        'Template',
        'JSON',
        'Logger',
        'Runtime::Test',
    ],

    # No Logger output when testing
    modules_init => {
        Logger => {
            outputs => [],
        },
    },

    dbi => [
        'dbi:SQLite:dbname=:memory:',
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
}

