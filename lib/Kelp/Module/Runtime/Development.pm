package Kelp::Module::Runtime::Development;
use v5.42;
use strictures 2;
use Carp       qw( croak );
use Path::Tiny qw( path );

use Moo;
extends 'Kelp::Module::Runtime::Test';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub build ($self, %args) {
  my $schema_file = $ENV{SCHEMA}                   || croak 'SCHEMA not set';
  my $schema      = path($schema_file)->slurp_utf8 || croak $!;
  if (-f $self->app->config('db_file')) {
    my @tables = $self->dbh->tables;
    croak 'development db tables' if scalar @tables == 0;
  }
  else {
    $self->dbh->do($schema);
  }

  $self->register(dbh                    => $self->dbh);
  $self->register(get_key                => $self->get_key);
  $self->register(encryption_key_version => $self->encryption_key_version);
  $self->register(signing_key            => $self->signing_key);
}

__END__
