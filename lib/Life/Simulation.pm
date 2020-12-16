package Life::Simulation;

use Moo;
use POSIX;
use Term::Cap;
use Time::HiRes 'sleep';
use Types::Standard qw(ArrayRef InstanceOf Num);

use Life::Grid;

has seed => (is => 'ro', isa => ArrayRef, required => 1);

has tick_delay => (is => 'ro', isa => Num, default => 1.00);

has grid => (is => 'ro', isa => InstanceOf['Life::Grid'], lazy => 1, builder => '_build_grid');
has term => (is => 'ro', isa => InstanceOf['Term::Cap'],  lazy => 1, builder => '_build_term');

sub simulate {
    my $self = shift;

    $self->grid->seed($self->seed);

    my $ticks = 0;

    while (1) {
        print $self->term->Tputs('cl');
        print $self->grid->render;

        $self->grid->lifecycle;

        sleep($self->tick_delay) if $ticks > 0;

        $ticks++;
    }

    return 1;
}

sub _build_grid {
    return Life::Grid->new;
}

sub _build_term {
    my $termios = POSIX::Termios->new;

    $termios->getattr;

    return Term::Cap->Tgetent({ OSPEED => $termios->getospeed });
}

1;

