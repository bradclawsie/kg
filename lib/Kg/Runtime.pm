package Kg::Runtime;
use v5.42;
use strictures 2;
use Carp qw( croak );
use DBI;
use Moo::Role;
use Types::Standard qw( InstanceOf );
use namespace::clean;

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

has dbh => (
  is      => 'ro',
  isa     => InstanceOf ['DBI::db'],
  lazy    => true,
  default => sub($self) {
    my $dbh = DBI->connect(@{$self->app->config('dbi')}) || croak $DBI::errstr;
    for my $pragma (@{$self->app->config('dbh_pragmas')}) {
      $dbh->do($pragma) || croak $!;
    }
    return $dbh;
  },
);

__END__
