use v5.42;
use strictures 2;
use Crypt::Misc qw( random_v4uuid );
use Kelp::Base -strict;
use Kelp::Test              ();
use Test2::V0               qw( done_testing isa_ok ok subtest );
use Test2::Tools::Compare   qw( like );
use Test2::Tools::Exception qw( lives );
use Types::UUID             qw( Uuid );
use Kg                      ();
use Kg::Type                qw( Key );

my $app = Kg->new(mode => $ENV{PLACK_ENV} // undef);
my $t   = Kelp::Test->new(app => $app);

subtest 'has configs' => sub {
  for my $k (qw( api_version default_role repository_base )) {
    ok(defined $app->config($k));
  }
};

subtest 'has attrs' => sub {
  for my $attr (qw( dbh encryption_key_version get_key signing_key )) {
    ok($app->can($attr));
  }
  isa_ok($app->dbh, 'DBI::db');
  ok(ref($app->can('get_key')), 'CODE');
  ok(Uuid->check($app->encryption_key_version));
  ok(Uuid->check($app->signing_key));
};

subtest 'get_key' => sub {
  ok(
    lives {
      my $key = $app->get_key($app->encryption_key_version);
      ok(Key->check($key));
    },
  );

  ok(
    lives {
      my $caught = false;
      try {
        $app->get_key(random_v4uuid);
      }
      catch ($e) {
        like($e, qr/bad key_version/);
        $caught = true;
      }
      ok($caught);
    },
  );
  done_testing;
};

done_testing;
