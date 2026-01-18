use v5.42;
use strictures 2;
use Crypt::Digest::SHA256   qw( sha256_hex );
use Crypt::Misc             qw( random_v4uuid );
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing is note ok );
use Test2::Tools::Exception qw( dies lives );
use Kg::User                ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

ok(
  lives {
    my ($u, undef) = Kg::User->random;

    is($u->display_name_digest,   sha256_hex($u->display_name));
    is($u->ed25519_public_digest, sha256_hex($u->ed25519_public));
    is($u->email_digest,          sha256_hex($u->email));

    $u->display_name(random_v4uuid);
    is($u->display_name_digest, sha256_hex($u->display_name));

    $u->ed25519_public(random_v4uuid);
    is($u->ed25519_public_digest, sha256_hex($u->ed25519_public));
  },
) or note($EVAL_ERROR);

ok(
  dies {
    my ($u, undef) = Kg::User->random;
    $u->display_name_digest(q{});
  },
) or note($EVAL_ERROR);

ok(
  dies {
    my ($u, undef) = Kg::User->random;
    $u->ed25519_public_digest(q{});
  },
) or note($EVAL_ERROR);

ok(
  dies {
    my ($u, undef) = Kg::User->random;
    $u->email(q{});
  },
) or note($EVAL_ERROR);

ok(
  dies {
    my ($u, undef) = Kg::User->random;
    $u->password(q{});
  },
) or note($EVAL_ERROR);

done_testing;
