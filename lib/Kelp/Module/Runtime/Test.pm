package Kelp::Module::Runtime::Test;
use v5.42;
use strictures 2;
use Carp       qw( croak );
use Path::Tiny qw( path );

use Moo;
extends 'Kelp::Module';
use namespace::clean;

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub build ($self, %args) {
  my $schema_file = $ENV{SCHEMA}                   || croak 'SCHEMA not set';
  my $schema      = path($schema_file)->slurp_utf8 || croak $!;
  $self->app->dbh->do($schema);
}

__END__
