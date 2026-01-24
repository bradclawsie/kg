use v5.42;
use strictures 2;
use HTTP::Request::Common qw( GET );
use Kelp::Base -strict;
use Kelp::Test ();
use Test2::V0  qw( done_testing subtest );
use Kg         ();

my $app = Kg->new(mode => $ENV{PLACK_ENV} // undef);
my $t   = Kelp::Test->new(app => $app);

subtest 'test template' => sub {
  $t->request(GET '/')
    ->code_is(200)
    ->content_type_is('text/html')
    ->content_like(qr/Kg::Controller::Test/);

  done_testing;
};

subtest 'list routes' => sub {
  $t->request(GET '/routes')->code_is(200);

  done_testing;
};

done_testing;
