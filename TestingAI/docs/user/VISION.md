# Project Vision

## Project Name
Elden Ring — League of Legends Movement and Combat

## Primary Objective

Transform Elden Ring's movement and combat controls into a system inspired by League of Legends.

The player should control a character through mouse-based commands rather than Elden Ring's traditional direct movement controls.

The project will initially control an NPC instead of the standard player character.

## Intended Gameplay

### Movement
- Right-clicking a location commands the controlled character to navigate there.
- The character uses Elden Ring's existing movement, navigation, and animation systems wherever possible.
- New movement commands can interrupt or replace previous movement commands.
- The character should navigate around obstacles when supported by the game's navigation system.

### Combat
- Right-clicking an enemy commands the controlled character to approach and attack it.
- The character should automatically move into attack range when necessary.
- Combat should reuse Elden Ring's existing attacks, animations, damage calculations, and AI systems where feasible.
- The player should be able to issue new movement commands during combat.

### Responsiveness
- Controls should feel responsive and predictable.
- The character should not require repeated commands to complete ordinary movement.
- New commands should take effect without unnecessary delays.

## Development Philosophy

Prioritize adapting existing Elden Ring systems over recreating functionality from scratch.

The project is an experimental gameplay modification. Technical feasibility must be demonstrated through small, reproducible tests.

## Initial Prototype

Use Soldier of Godrick as the first controlled character.

The initial objective is to make the soldier navigate to a predefined destination through its existing AI movement systems.

After that succeeds, investigate dynamic destinations, custom input, and combat targeting.

## Outside Initial Scope

- Isometric camera implementation
- Custom user interface
- Multiplayer support
- Replacing the standard player character
- New combat animations
- New character models

These features may be investigated in later development phases.

## Long-Term Success

A user can navigate and fight in Elden Ring primarily through League of Legends-style mouse commands, with movement and combat handled by the game's existing systems wherever technically feasible.