use v5.42;
use strictures 2;
use Crypt::Misc qw( random_v4uuid );
use Kelp::Base -strict;
use Kelp::Test              ();
use Test2::V0               qw( done_testing isnt ok subtest );
use Test2::Tools::Exception qw( dies lives );
use Kg                      ();

my $app = Kg->new(mode => 'test');
my $t   = Kelp::Test->new(app => $app);

subtest 'get_key' => sub {
  isnt(undef, $app->encryption_key_version);

  ok(
    lives {
      $app->get_key->($app->encryption_key_version);
    },
  );

  ok(
    dies {
      $app->get_key->(random_v4uuid);
    },
  );
  done_testing;
};

done_testing;
