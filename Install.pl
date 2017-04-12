#!/usr/bin/env perl

use strict;

my %COPIED_FILES = (
  'vim'                 => '~/.vim',
  'vimrc.local'         => '~/.vimrc.local',
  'vimrc.bundles.local' => '~/.vimrc.bundles.local',
  'tmux.conf.local'     => '~/.tmux.conf.local'
);

my %LINKED_FILES = (
  #'vim'           => '~/.vim',
  'tmux.conf'     => '~/.tmux.conf',
  'vimrc'         => '~/.vimrc',
  'vimrc.bundles' => '~/.vimrc.bundles'
);

sub install_github_bundle($$)
{
  my ($user, $package) = @_;
  mkdir "~/.vim/bundle" unless -d ("~/.vim/bundle");
  unless (-d "~/.vim/bundle/$package") {
   system("git clone https://github.com/$user/$package ~/.vim/bundle/$package");
  }
  system('vim -c "BundleInstall" -c "q" -c "q"');
}

sub copy_link_files($$$)
{
  my ($src, $dst, $dolink) = @_;
  if ($dolink) {
    system("ln -s $src $dst");
  } else {
    system("cp -a $src $dst");
  }
}

my $dir = "$ENV{'PWD'}/$0";
$dir=~s@/[^/]+$@@;
print "$dir\n";
install_github_bundle('gmarik','vundle');

for my $k (keys(%COPIED_FILES)) {
  copy_link_files($k, $COPIED_FILES{$k}, 0);
}

for my $k (keys(%LINKED_FILES)) {
  copy_link_files($k, $LINKED_FILES{$k}, 1);
}
