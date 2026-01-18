package Kg::User;
use v5.42;
use strictures 2;
use Crypt::Digest::SHA256 qw( sha256_hex );
use Crypt::Misc           qw( random_v4uuid );
use Crypt::PK::Ed25519    ();
use Types::Common::String qw( NonEmptyStr );
use Types::Standard       qw( Str );
use Types::UUID           qw( Uuid );
use Kg::Crypt::Password   qw( rand_password );
use Kg::Model::Attribute  qw( $ROLE_TEST $STATUS_ACTIVE );

use Moo;
with 'Kg::Model::Base';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

our $SCHEMA_VERSION = 0;

has display_name => (
  is      => 'rw',
  isa     => NonEmptyStr,
  trigger => sub ($self, $v) {
    $self->_set_display_name_digest(sha256_hex($v));
  },
);

has display_name_digest => (
  is     => 'ro',
  isa    => NonEmptyStr,
  writer => '_set_display_name_digest',
);

has ed25519_public => (
  is      => 'rw',
  isa     => NonEmptyStr,
  trigger => sub ($self, $v) {
    $self->_set_ed25519_public_digest(sha256_hex($v));
  },
);

has ed25519_public_digest => (
  is     => 'ro',
  isa    => NonEmptyStr,
  writer => '_set_ed25519_public_digest',
);

has email => (
  is      => 'ro',
  isa     => NonEmptyStr,
  trigger => sub ($self, $v) {
    $self->_set_email_digest(sha256_hex($v));
  },
);

has email_digest => (
  is     => 'ro',
  isa    => NonEmptyStr,
  writer => '_set_email_digest',
);

has key_version => (
  is      => 'rw',
  isa     => Uuid,
  coerce  => 1,
  default => sub { '00000000-0000-0000-0000-000000000000' },
);

has org => (
  is      => 'ro',
  isa     => Uuid,
  coerce  => 1,
  default => sub { '00000000-0000-0000-0000-000000000000' },
);

has password => (
  is      => 'rw',
  isa     => Str->where('$_ =~ m/\$argon2/'),
  default => sub { rand_password },
);

# for testing
sub random ($class, %args) {
  my $pk = Crypt::PK::Ed25519->new->generate_key;

  return (
    $class->new(
      id             => random_v4uuid,
      display_name   => $args{display_name} // random_v4uuid,
      ed25519_public => $pk->export_key_pem('public'),
      email          => $args{email}    // random_v4uuid,
      org            => $args{org}      // random_v4uuid,
      password       => $args{password} // rand_password,
      role           => $args{role}     // $ROLE_TEST,
      status         => $args{status}   // $STATUS_ACTIVE,
    ),
    $pk->export_key_pem('private')
  );
}

__END__
