package Kg;
use v5.42;
use strictures 2;
use Carp qw( croak );
use DBI;
use Types::Standard qw( InstanceOf );
use Kelp::Base 'Kelp';
use Moo;
use namespace::clean;

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

has dbh => (
  is      => 'ro',
  isa     => InstanceOf ['DBI::db'],
  lazy    => true,
  default => sub($self) {
    my $dbh = DBI->connect(@{$self->config('dbi')}) || croak $DBI::errstr;
    for my $pragma (@{$self->config('dbh_pragmas')}) {
      $dbh->do($pragma) || croak $!;
    }
    return $dbh;
  },
);

sub build ($self, %args) {
  my $r = $self->routes;

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
