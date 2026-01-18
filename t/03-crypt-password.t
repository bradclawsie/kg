use v5.42;
use strictures 2;
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing is isnt note ok );
use Test2::Tools::Exception qw( lives );
use Kg::Crypt::Password     qw( text_to_password verify_password );

# ABSTRACT: Test Crypt::Password.

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

my $password;
my $text = 'secret';

ok(
  lives {
    $password = text_to_password($text);
  },
) or note($EVAL_ERROR);

is(verify_password($password, $text), true, 'match password');
isnt(verify_password($password, 'guess'), true, 'mismatch password');

done_testing;

