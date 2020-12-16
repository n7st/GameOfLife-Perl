package Life::Simulation;

use Moo;
use POSIX;
use Reflex::Interval;
use Reflex::Trait::Watched 'watches';
use Term::Cap;
use Time::HiRes 'sleep';
use Types::Standard qw(ArrayRef InstanceOf Int Num Str);

use Life::Grid;

extends 'Reflex::Base';

has seed => (is => 'ro', isa => ArrayRef, required => 1);

has dimension      => (is => 'ro', isa => Int, default => 50);
has chr_tile_alive => (is => 'ro', isa => Str, default => q{#});
has chr_tile_dead  => (is => 'ro', isa => Str, default => q{O});

has tick_delay => (is => 'ro', isa => Num, default => 1.00);

has grid => (is => 'ro', isa => InstanceOf['Life::Grid'], lazy => 1, builder => '_build_grid');
has term => (is => 'ro', isa => InstanceOf['Term::Cap'],  lazy => 1, builder => '_build_term');

watches ticker => (isa => 'Reflex::Interval', setup => { interval => 0.2, auto_repeat => 1 });

sub BUILD {
    my $self = shift;

    $self->grid->seed($self->seed);
    $self->grid->lifecycle;
    $self->_tick;

    return 1;
}

sub on_ticker_tick {
    my $self = shift;

    $self->_tick;

    return 1;
}

sub _tick {
    my $self = shift;

    print STDOUT $self->term->Tputs('cl');
    print STDOUT $self->grid->render;

    return $self->grid->lifecycle;
}

sub _build_grid {
    my $self = shift;

    return Life::Grid->new({
        chr_tile_alive => $self->chr_tile_alive,
        chr_tile_dead  => $self->chr_tile_dead,
        dimension      => $self->dimension,
    });
}

sub _build_term {
    my $termios = POSIX::Termios->new;

    $termios->getattr;

    return Term::Cap->Tgetent({ OSPEED => $termios->getospeed });
}

1;

