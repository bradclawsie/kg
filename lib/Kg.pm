package Kg;
use v5.42;
use strictures 2;
use Kelp::Base 'Kelp';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub build {
  my $self = shift;
  my $r    = $self->routes;

  $r->add(qw{/}, 'test');

  $r->add(
    '/routes',
    {
      method => 'GET',
      to     => 'list_routes',
    }
  );
}

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

sub test ($self) {
  $self->template(
    'test',
    {
      name => __PACKAGE__,
    }
  );
}

__END__
