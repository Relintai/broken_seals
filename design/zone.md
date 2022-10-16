# Zone Design

This is currently the thinking I plan to follow on roughing out the first few zones.

This is a high level overview on how zones should be designed.
Note that art should trump these (like when things becomes monotonous, etc), these are just guidelines.
Look at this as a staring point. 

## Notes

MMO = A Massively Multiplayer Online Game

## Problems

### I want complex MMO-Esque classes in the game.

Levelling also actually need to serve as a tutorial.

### The game should work well in single player.

Levelling needs to be shorter than in MMOs, because it will be boring otherwise (MMOs typically make levelling slow, 
in order to help people meet and quest together). However this makes traditional levelling slow and extremely tedious
in a single player setting.

This also means that zones need to be extremely big, and that you need to create tons of them.

For example Vanilla WoW has something like 18 (Kalimdor) + 22 (Eastern Kingdoms) zones not counting dungeons and battlegrounds.
Something like this is really cool, but unnecessary, and will not work well.

### The game needs to support multiplayer. 

Especially if the classes work well, it would be a wasted opportunity not to have it.
However the game shouldn't be an MMO, as MMOS are designed in a way where you NEED to have certain numbers of players
per server in order for everything to function properly, which is a big issue, if you don't have enough players.

IF (and that's a big IF), the game turns out really good, people will likely want to have mmo like features,
but that's out of the scope of this particular project, stuff can be reworked like that in a different repo 
IF and WHEN the need arises.

### World Scaling

Since the game will need to support both single and multiplayer I'd say that world scaling (like the one in skyrim, and in WoW) 
is out of the question, especially since I was (un?)lucky enough to see multiplayer player + world scaling in action in WoW. 
It does not work well, especially not in PvP.

Now there is a way to scale worlds, that I think will work in this case, which is a "new game +", or diablo solution.
I think this will be implemented, especially before there is enough content to level a character, but even after,
it will be able to give optional content to people that want it. It will be similar to Diablo II's difficulty, 
except maybe it could go on for more (that could mostly be used for multiplayer challenges).
It should not powercreep gear though (it should drop better gear, but only up to a point - Also I think gear should 
be hand crafted -).

Note that the World - Viewport separation in the engine is preparation for this feature + dungeons to be able to work
on servers.

### Levelling cannot be too fast

Since I want classes to be complex, this means they will need to have lots of levels. (Not yet sure how much.)
I'm pretty sure it will be 70-80-ish.

If levelling is too fast, players either outlevel a zone without really being able to finish it, or
if mobs are scaled to a levelling setup like this, then the end of a zone will be way too high level,
and it will look awkward.

WoW actually used to have this problem before they did the level squish, and levelling rework at the end of BFA.
(To be fair, I think they caused more issues with the levelling rework, but let's ignore that for now,
as it's really irrelevant.)

### In essence

The main issue is that levelling has to be slow, but not too slow, also the world cannot be just scaled around 
the player like in Skyrim. 

## The solution

I think I came up with a base setup that might work.

A normal run-of-the-mill zone should be similar in size to a standard MMO zone. This will give lots of leeway.

A subzone is a quest hub with it's perimeter. Usually I saw around 5 of these in a zone in MMOS, 
that I ended up messing with. Note that it does not really have to be a normal quest hub every single time,
so it doesn't get boring.

### Zone Setup

The starter zone should level players from 1 to (around) 12, as the lower levels can be quite boring before you really
start to have your class spells. This will have to be baked in into the stats.

The next zone should level players to around 20.

After that each standard zone should give around 5 levels (1 per subzone) if you can finish the entire zone in maybe an hour or 2,
not counting optional dungeons. And of course not counting artistic variations.

This would ensure that zones don't need that much gap in mob levels, while the thing won't get boring, and repetitive.
Also less quests to create.

This will get fine tuned when I get to it, but I think this is likely a good figure to be aiming at.


