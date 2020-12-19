package Life::Tile;

use Moo;
use Types::Standard qw(Bool Str);

has chr_alive => (is => 'ro', isa => Str, required => 1);
has chr_dead  => (is => 'ro', isa => Str, required => 1);

has alive      => (is => 'rw', isa => Bool, default => 0);
has next_state => (is => 'rw', isa => Bool, default => 0);

sub determine_state {
    my $self             = shift;
    my $alive_neighbours = shift;

    if ($self->alive) {
        $self->flip if $alive_neighbours != 2 && $alive_neighbours != 3;
    } else {
        $self->flip if $alive_neighbours == 3;
    }

    return 1;
}

sub flip {
    my $self = shift;

    return $self->next_state(!$self->alive || 0);
}

sub render {
    my $self = shift;

    return $self->alive ? $self->chr_alive : $self->chr_dead;
}

1;
__END__

=head1 NAME

Life::Tile - an individual tile in the grid.

=head1 DESCRIPTION

=head2 METHODS

=over 4

=item * C<determine_state()>

Decides whether the tile should be alive or dead based on the number of alive
neighbours.

    $tile->alive(1);
    $tile->determine_state(5); # Will become dead

    $tile->alive(1);
    $tile->determine_state(2); # Will stay alive
    $tile->determine_state(3); # Will stay alive

    $tile->alive(0);
    $tile->determine_state(3); # Will become alive

    $tile->alive(0);
    $tile->determine_state(1); # Will stay dead

=item * C<flip()>

If the tile is alive, kill it. If the tile is dead, bring it to life.

    $tile->flip();

=item * C<render()>

Returns the character which should be shown for this tile. This is either the
"alive" or "dead" character.

    $tile->render();

=back

=head1 AUTHOR

L<Mike Jones|mike@netsplit.org.uk>

