use Kelp::Base -strict;
use Kelp::Test ();
use v5.42;
use strictures 2;
use HTTP::Request::Common qw( GET );
use Kg ();
use Test2::V0 qw( done_testing );

my $app = Kg->new(mode => 'test');
my $t   = Kelp::Test->new(app => $app);

$t->request(GET '/')
  ->code_is(200)
  ->content_type_is('text/html')
  ->content_like(qr/test/);

done_testing;
