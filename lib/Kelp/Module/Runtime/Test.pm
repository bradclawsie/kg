package Kelp::Module::Runtime::Test;
use v5.42;
use strictures 2;
use Carp           qw( croak );
use Crypt::Misc    qw( random_v4uuid );
use Path::Tiny     qw( path );
use Kg::Crypt::Key qw( rand_key );

use Moo;
extends 'Kelp::Module';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub build ($self, %args) {

  # build :memory: db
  my $schema_file = $ENV{SCHEMA}                   || croak 'SCHEMA not set';
  my $schema      = path($schema_file)->slurp_utf8 || croak $!;
  $self->app->dbh->do($schema);

  # build get_key and encryption_key_version
  my $encryption_key_version = random_v4uuid;
  my $encryption_keys        = {
    $encryption_key_version => rand_key,
    random_v4uuid()         => rand_key,
    random_v4uuid()         => rand_key,
  };
  my $get_key = sub($key_version) {
    return $encryption_keys->{$key_version} // croak 'bad key_version';
  };
  $self->app->get_key($get_key);
  $self->app->encryption_key_version($encryption_key_version);
}

__END__
