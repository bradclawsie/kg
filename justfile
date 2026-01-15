set shell := ["bash", "-c"]

PERL5LIB_BASE := justfile_directory() / "local" / "lib" / "perl5"
PERL5LIB_LIB := PERL5LIB_BASE + ":" + justfile_directory() / "lib"
LOCAL_BIN := justfile_directory() / "local" / "bin"
export PATH := LOCAL_BIN + ":" + env("PATH")
PERLCRITIC := "perlcritic" + " --profile " + justfile_directory() / ".perlcritic"
PERLIMPORTS := "perlimports" + " -i --no-preserve-unused" + " --libs lib" + " --ignore-modules-filename " + justfile_directory() / ".perlimports-ignore" + " -f"
PERLTIDY := 'perltidier -i=2 -pt=2 -bt=2 -pvt=2 -b -cs '
YATH := 'yath --max-open-jobs=1000'

default:
    @just --list

# Initialize carton.
carton:
    mkdir -p local/bin;
    curl -L https://cpanmin.us/ -o local/bin/cpanm
    @chmod +x local/bin/cpanm
    env -u PERL5LIB cpanm -l local -n -f Carton

# Install carton dependencies; follows "carton" rule.
deps:
    @export PERL5LIB={{ PERL5LIB_BASE }};\
      carton install

# Update all carton dependencies.
update:
    @export PERL5LIB={{ PERL5LIB_BASE }};\
      carton update

# Open a perl repl.
repl:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      perl -de 0

# Run a command.
run *CMD:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      {{ CMD }}

# perltidy on all files.
tidy:
    @export PERL5LIB={{ PERL5LIB_BASE }};\
      find . -name \*.pm -print0 | xargs -0 {{ PERLTIDY }} 2>/dev/null
    @export PERL5LIB={{ PERL5LIB_BASE }};\
      find . -name \*.t -print0 | xargs -0 {{ PERLTIDY }} 2>/dev/null
    @find -name \*bak -delete
    @find -name \*tdy -delete
    @find -name \*.ERR -delete

check:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      for i in `find lib -name \*.pm`; do perl -c $i; done
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      for i in `find t -name \*.t`; do perl -c $i; done

critic:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      find lib -name \*.pm -print0 | xargs -0 {{ PERLCRITIC }}
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      find t -name \*.t -print0 | xargs -0 {{ PERLCRITIC }} --theme=tests

imports:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      find lib -name \*.pm -print0 | xargs -0 {{ PERLIMPORTS }} 2>/dev/null
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      find t -name \*.t -print0 | xargs -0 {{ PERLIMPORTS }} 2>/dev/null

test:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      find t -name \*.t -print0 | xargs -0 {{ YATH }}

# Run a single test; e.g. "just yath t/00-test.t".
yath TEST:
    @export PERL5LIB={{ PERL5LIB_LIB }};\
      {{ YATH }} {{ TEST }}
