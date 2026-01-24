package Kg;
use v5.42;
use strictures 2;

use parent 'Kelp';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub build ($self, %args) {
  my $r = $self->routes;

  $r->add(qw{/}, 'Controller::Test::test');

  $r->add(
    '/routes',
    {
      method => 'GET',
      to     => 'Controller::Status::list_routes',
    }
  );
}

__END__
