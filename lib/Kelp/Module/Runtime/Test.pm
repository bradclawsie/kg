package Kelp::Module::Runtime::Test;
use v5.42;
use strictures 2;
use Carp            qw( croak );
use Crypt::Misc     qw( random_v4uuid );
use DBI             ();
use Path::Tiny      qw( path );
use Types::Standard qw( CodeRef InstanceOf );
use Types::UUID     qw( Uuid );
use Kg::Crypt::Key  qw( rand_key );

use Moo;
extends 'Kelp::Module';

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

has encryption_key_version => (
  is       => 'ro',
  isa      => Uuid,
  required => true,
  default  => Uuid->generator,
);

has get_key => (
  is       => 'ro',
  isa      => CodeRef,
  lazy     => true,
  required => true,
  builder  => sub ($self) {
    my $encryption_keys = {
      $self->encryption_key_version => rand_key,
      random_v4uuid()               => rand_key,
      random_v4uuid()               => rand_key,
    };
    my $get_key = sub ($app, $key_version) {
      return $encryption_keys->{$key_version} // croak 'bad key_version';
    };
    return $get_key;
  },
);

has signing_key => (
  is       => 'ro',
  isa      => Uuid,
  required => true,
  default  => Uuid->generator,
);

sub build ($self, %args) {

  # build :memory: db
  my $schema_file = $ENV{SCHEMA}                   || croak 'SCHEMA not set';
  my $schema      = path($schema_file)->slurp_utf8 || croak $!;
  $self->dbh->do($schema);

  $self->register(dbh                    => $self->dbh);
  $self->register(get_key                => $self->get_key);
  $self->register(encryption_key_version => $self->encryption_key_version);
  $self->register(signing_key            => $self->signing_key);
}

__END__
