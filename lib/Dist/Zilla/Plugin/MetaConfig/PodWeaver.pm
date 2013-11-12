package Dist::Zilla::Plugin::MetaConfig::PodWeaver;

use 5.010001;
use Moose;
with 'Dist::Zilla::Role::ConfigDumper';
with 'Dist::Zilla::Role::Plugin';

# VERSION

use namespace::autoclean;

sub dump_config {
    my $self = shift;

    my $dump = {};

    #$dump->{_debug_inc} = \%INC;

    my $zilla  = $self->zilla;
    my $dzp_pw;
    for (@{ $zilla->plugins }) {
        say "D0:$_";
        if ($_->isa("Dist::Zilla::Plugin::PodWeaver")) {
            $dzp_pw = $_;
            last;
        }
    }

    say "D:$dzp_pw";
    if ($dzp_pw) {
        my $weaver   = $dzp_pw->weaver;
        $dump->{plugins} = [];
        for my $plugin (@{ $weaver->plugins }) {
            say "D:$plugin";
            push @{ $dump->{plugins} }, {
                class   => $plugin->meta->name,
                name    => $plugin->plugin_name,
                version => $plugin->VERSION,
            };
        }
    }

    return $dump;
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Dump more information about Pod::Weaver

=head1 SYNOPSIS

In your F<dist.ini>:

  [MetaConfig::PodWeaver]


=head1 DESCRIPTION

This plugin adds more information about Pod::Weaver configuration (currently:
list of Pod::Weaver plugins and their versions) to be included in top-level
C<X-Dist_Zilla> key of distmeta, under this plugin's config dump.


=head1 SEE ALSO

L<Dist::Zilla::Plugin::MetaConfig>
