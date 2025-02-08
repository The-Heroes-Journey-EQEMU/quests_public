-- A burrower parasite in The Burrower Beast event

local EVENT_MOBS			= {
	ROCK_BURROWER			= 164118,
	SPINED_ROCK_BURROWER	= 164104,
	STONE_CARVER			= 164100,
	CORE_BURROWER			= 164108,
	PARASITE_LARVA			= 164085,
	BURROWER_PARASITE		= 164089,
	MASSIVE_BURROWER		= 164111
};

function event_spawn(e)
	eq.set_timer('depop', 60 * 60 * 1000);
end

function event_timer(e)
	if e.timer == 'depop' then
		cleanup();
		eq.depop();
	end
end

function event_death_complete(e)
	cleanup();
end

function cleanup()
	for _, mob in ipairs(EVENT_MOBS) do
		eq.depop_all(mob);
	end
end
