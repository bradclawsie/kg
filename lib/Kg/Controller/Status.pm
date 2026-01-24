package Kg::Controller::Status;
use v5.42;
use strictures 2;
use Kelp::Base 'Kelp::Module';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub list_routes ($self) {
  my @routes = map {
    {
      method  => $_->method // qw{*},
      route   => $_->pattern,
      handler => ref($_->to) eq 'CODE' ? '(anonymous)' : $_->to,
    }
  } grep { not $_->bridge } @{$self->routes->routes};

  return \@routes;
}

__END__
