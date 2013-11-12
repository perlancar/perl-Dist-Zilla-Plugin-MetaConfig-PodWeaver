package Dist::Zilla::Plugin::MetaConfig::PodWeaver;

use 5.010001;
use Moose;
with 'Dist::Zilla::Role::ConfigDumper';
with 'Dist::Zilla::Role::Filegatherer';
with 'Dist::Zilla::Role::Plugin';

# VERSION

use namespace::autoclean;

sub dump_config {
    my $self = shift;

    my $dump = {};

    $dump->{plugins} = [];
    for (sort keys %INC) {
        next unless m!^\APod/Weaver/Plugin/!;
        no strict 'refs';
        my $pkg = $_; $pkg =~ s!/!::!g; $pkg =~ s/\.pm\z//;
        push @{ $dump->{plugins} }, {
            class   => $pkg,
            version => ${"$pkg\::VERSION"} // 0,
        };
    }

    $dump->{plugin_bundles} = [];
    for (sort keys %INC) {
        next unless m!^\APod/Weaver/PluginBundle/!;
        no strict 'refs';
        my $pkg = $_; $pkg =~ s!/!::!g; $pkg =~ s/\.pm\z//;
        push @{ $dump->{plugin_bundles} }, {
            class   => $pkg,
            version => ${"$pkg\::VERSION"} // 0,
        };
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
C<X-Dist_Zilla> key of distmeta.


=head1 SEE ALSO

L<Dist::Zilla::Plugin::MetaConfig>
