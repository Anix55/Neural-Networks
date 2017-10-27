Self Driving Car: Grand Prix Version 3.0 2017/10/27

GENERAL USEAGE NOTES
____________________
This program uses *Neuro-evolution to generate artificial neural 
networks that control the behaviours of self-driving cars.
After a few generations, the population learns how go around the track 
while avoiding obstacles.
Each car has 6 proximity sensors that they must learn to use to 
navigate through the environment. Each car also contains an additional 
sensor that tells it whether it is driving in the right direction (CW).


The program has 2 modes: EVOLVE & REVIVE

EVOLVE:
This is the default mode but it can be re-activated by pressing 'E' 
(Shift + 'e' or CAPS + 'e')

The program begins will an initial population of randomly generated 
cars consisting of poor drivers.  However, after many cycles of 
reproduction mutation, recombination and selection, the population 
will learn to navigate the race track.  After each generation, the
program saves the DNA of the fittest car in the file titled 
"fossilRecord.txt", which can later be revived in REVIVE mode.

There are two knobs in the top right corner:
- COLLISION_DMG: controls how much the cars are "hurt" by collisions
- MUTATION_RATE: controls how often mutations occur
It is recommended that you initially turn the MUTATION_RATE dial to the 
maximum.  This ensures that the population does not converge 
prematurely.  Also since the initial population will collide often, it 
is recommended that you turn the COLLISSION_DMG to the minimum.  As the 
algorithm progresses, experiment with these parameters.

There is a slider in the bottom left corner that can be used to view
the Neural Network activity of a specific car in the population.  The 
car that is being viewed will be coloured red.


REVIVE:
This mode is activated by pressing 'R' (Shift + 'r' or CAPS + 'r')

In the bottom left there is a text field that can receive the following
commands:
- "new race": remove all cars from the track
- "new course": change the position of obstacles
- "random": randomly pick cars from the fossil record
- "[0-9]+": selects the best car from the inputted generation

This mode allows you to revisit the best cars in each generation. If
you would like to revive cars in "fossilRecord.txt” simply change the
name of the text file to "revive.txt".

To end the program press 'Q'.

DEPENDANCIES
____________
To run this, you must first install Processing 3(.3.6) as well as the 
following libraries:
- ControlP5
- Box2DProcessing
If you do not have these dependencies then consider viewing my YouTube 
video: https://youtu.be/t38mfCemKhs


* a form of artificial intelligence that uses **evolutionary algorithms
** an optimization algorithm that uses mechanisms inspired by 
biological evolution such as reproduction, mutation, recombination and 
selection.







