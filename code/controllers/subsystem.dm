/**
 * # Subsystem base class
 *
 * Defines a subsystem to be managed by the [Master Controller][/datum/controller/master]
 *
 * Simply define a child of this subsystem, using the [SUBSYSTEM_DEF] macro, and the MC will handle registration.
 * Changing the name is required.
 */
/datum/controller/subsystem
	//# Metadata; you should define these.

	/**
	 * Name of the subsystem
	 * YOU MUST CHANGE THIS
	 */
	name = "fire coderbus"

	/**
	 * Order of initialization.
	 * Higher numbers are initialized first, lower numbers later.
	 * Use or create defines such as [INIT_ORDER_DEFAULT] so we can see the order in one file.
	 */
	var/init_order = INIT_ORDER_DEFAULT

	/**
	 * Time to wait (in deciseconds) between each call to fire().
	 * Must be a positive integer.
	 */
	var/wait = 20

	/**
	 * Priority Weight:
	 *
	 * When mutiple subsystems need to run in the same tick,
	 * higher priority subsystems will be given a higher share of the tick before MC_TICK_CHECK triggers a sleep,
	 * higher priority subsystems also run before lower priority subsystems.
	 */
	var/priority = FIRE_PRIORITY_DEFAULT

	/**
	 * [Subsystem Flags][SS_NO_INIT] to control binary behavior.
	 * Flags must be set at compile time or before preinit finishes to take full effect.
	 * (You can also restart the mc to force them to process again)
	 */
	var/subsystem_flags = NONE

	/**
	 * Which stage does this subsystem init at.
	 * Earlier stages can fire while later stages init.
	 */
	//var/init_stage = INITSTAGE_MAIN

	/// This var is set to TRUE after the subsystem has been initialized.
	var/initialized = FALSE

	/**
	 * Set to FALSE to prevent fire() calls, mostly for admin use or subsystems that may be resumed later.
	 * use the [SS_NO_FIRE] flag instead for systems that never fire to keep it from even being added to list that is checked every tick.
	 */
	var/can_fire = TRUE

	/**
	 * Bitmap of what game states can this subsystem fire at.
	 * See [RUNLEVELS_DEFAULT] for more details.
	 */
	var/runlevels = RUNLEVELS_DEFAULT

	//# The following variables are managed by the MC and should not be modified directly.

	/// Last world.time the subsystem completed a run (as in wasn't paused by [MC_TICK_CHECK]).
	var/last_fire = 0

	/// Scheduled world.time for next fire().
	var/next_fire = 0

	/// Running average of the amount of milliseconds it takes the subsystem to complete a run (including all resumes but not the time spent paused).
	var/cost = 0

	/// Running average of the amount of tick usage in percents of a tick it takes the subsystem to complete a run.
	var/tick_usage = 0

	/// Running average of the amount of tick usage (in percents of a game tick) the subsystem has spent past its allocated time without pausing.
	var/tick_overrun = 0

	/// How much of a tick (in percents of a tick) were we allocated last fire.
	var/tick_allocation_last = 0

	/// How much of a tick (in percents of a tick) do we get allocated by the mc on avg.
	var/tick_allocation_avg = 0

	/// Tracks the current execution state of the subsystem. Used to handle subsystems that sleep in fire so the mc doesn't run them again while they are sleeping.
	var/state = SS_IDLE

	/// Tracks how many fires the subsystem has consecutively paused on in the current run.
	var/paused_ticks = 0

	/// Tracks how much of a tick the subsystem has consumed in the current run.
	var/paused_tick_usage

	/// Tracks how many fires the subsystem takes to complete a run on average.
	var/ticks = 1

	/// Tracks the amount of completed runs for the subsystem.
	var/times_fired = 0

	/// How many fires have we been requested to postpone.
	var/postponed_fires = 0

	/// Time the subsystem entered the queue, (for timing and priority reasons).
	var/queued_time = 0

	/**
	 * Priority at the time the subsystem entered the queue.
	 * Needed to avoid changes in priority (by admins and the like) from breaking things.
	 */
	var/queued_priority

	/**
	 * How many times we suspect a subsystem type has crashed the MC.
	 * 3 strikes and you're out!
	 */
	var/static/list/failure_strikes

	/// Next subsystem in the queue of subsystems to run this tick.
	var/datum/controller/subsystem/queue_next

	/// Previous subsystem in the queue of subsystems to run this tick.
	var/datum/controller/subsystem/queue_prev

	/**
	 * # Do not blindly add vars here to the bottom, put it where it goes above.
	 * # If your var only has two values, put it in as a flag.
	 */

// Do not override
// /datum/controller/subsystem/New()
// 	return

/**
 * Called before global vars are initialized
 * Called before Recover()
 *
 * ! Warning: Old subsystem won't be cleaned up yet if recovering,
 * ! be sure to reference us normally and not with SSname. pattern,
 * ! unless you are doing it on purpose.
 *
 * ? Prefer Initialize() where possible, don't put anything laggy in here please.
 */
/datum/controller/subsystem/proc/PreInit(recovering)
	return

/**
 * Called after global vars are initialized
 * Called before Recover()
 *
 * ! Warning: Old subsystem won't be cleaned up yet if recovering,
 * ! be sure to reference us normally and not with SSname. pattern,
 * ! unless you are doing it on purpose.
 *
 * ? Prefer Initialize() where possible, don't put anything laggy in here please.
 */
/datum/controller/subsystem/proc/Preload(recovering)
	return

/**
 * This is used so the mc knows when the subsystem sleeps.
 * DO NOT OVERRIDE THIS.
 */
/datum/controller/subsystem/proc/ignite(resumed = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	set waitfor = FALSE
	. = SS_IDLE

	tick_allocation_last = Master.current_ticklimit-(TICK_USAGE)
	tick_allocation_avg = MC_AVERAGE(tick_allocation_avg, tick_allocation_last)

	. = SS_SLEEPING
	fire(resumed)
	. = state
	if (state == SS_SLEEPING)
		state = SS_IDLE

	if (state == SS_PAUSING)
		var/QT = queued_time
		enqueue()
		state = SS_PAUSED
		queued_time = QT

/**
 * previously, this would have been named 'process()' but that name is used everywhere for different things!
 * fire() seems more suitable. This is the procedure that gets called every 'wait' deciseconds.
 * Sleeping in here prevents future fires until returned.
 */
/datum/controller/subsystem/proc/fire(resumed = FALSE)
	subsystem_flags |= SS_NO_FIRE
	CRASH("Subsystem [src]([type]) does not fire() but did not set the SS_NO_FIRE flag. Please add the SS_NO_FIRE flag to any subsystem that doesn't fire so it doesn't get added to the processing list and waste cpu.")


/datum/controller/subsystem/Destroy()
	dequeue()
	can_fire = 0
	subsystem_flags |= SS_NO_FIRE
	if (Master)
		Master.subsystems -= src

	return ..()


/**
 * Queue it to run.
 * (we loop thru a linked list until we get to the end or find the right point)
 * (this lets us sort our run order correctly without having to re-sort the entire already sorted list)
 */
/datum/controller/subsystem/proc/enqueue()
	var/SS_priority = priority
	var/SS_flags = subsystem_flags
	var/datum/controller/subsystem/queue_node
	var/queue_node_priority
	var/queue_node_flags

	for (queue_node = Master.queue_head; queue_node; queue_node = queue_node.queue_next)
		queue_node_priority = queue_node.queued_priority
		queue_node_flags = queue_node.subsystem_flags

		if (queue_node_flags & SS_TICKER)
			if (!(SS_flags & SS_TICKER))
				continue

			if (queue_node_priority < SS_priority)
				break

		else if (queue_node_flags & SS_BACKGROUND)
			if (!(SS_flags & SS_BACKGROUND))
				break

			if (queue_node_priority < SS_priority)
				break

		else
			if (SS_flags & SS_BACKGROUND)
				continue

			if (SS_flags & SS_TICKER)
				break

			if (queue_node_priority < SS_priority)
				break

	queued_time = world.time
	queued_priority = SS_priority
	state = SS_QUEUED
	if (SS_flags & SS_BACKGROUND) // Update our running total.
		Master.queue_priority_count_bg += SS_priority
	else
		Master.queue_priority_count += SS_priority

	queue_next = queue_node
	if (!queue_node) // We stopped at the end, add to tail.
		queue_prev = Master.queue_tail
		if (Master.queue_tail)
			Master.queue_tail.queue_next = src

		else // Empty queue, we also need to set the head.
			Master.queue_head = src

		Master.queue_tail = src

	else if (queue_node == Master.queue_head) // Insert at start of list.
		Master.queue_head.queue_prev = src
		Master.queue_head = src
		queue_prev = null

	else
		queue_node.queue_prev.queue_next = src
		queue_prev = queue_node.queue_prev
		queue_node.queue_prev = src

/datum/controller/subsystem/proc/dequeue()
	if (queue_next)
		queue_next.queue_prev = queue_prev

	if (queue_prev)
		queue_prev.queue_next = queue_next

	if (src == Master.queue_tail)
		Master.queue_tail = queue_prev

	if (src == Master.queue_head)
		Master.queue_head = queue_next

	queued_time = 0
	if (state == SS_QUEUED)
		state = SS_IDLE

/datum/controller/subsystem/proc/pause()
	. = TRUE
	switch(state)
		if(SS_RUNNING)
			state = SS_PAUSED

		if(SS_SLEEPING)
			state = SS_PAUSING

/// Called after the config has been loaded or reloaded.
/datum/controller/subsystem/proc/OnConfigLoad()
	return

/**
 * Used to initialize the subsystem AFTER the map has loaded.
 * This is expected to be overriden by subtypes.
 */
/datum/controller/subsystem/Initialize(start_timeofday)
	initialized = TRUE
	var/time = (REALTIMEOFDAY - start_timeofday) / 10
	var/msg = "Initialized [name] subsystem within [time] second[time == 1 ? "" : "s"]!"
	to_chat(world, SPAN_BOLDANNOUNCE("[msg]"))
	log_world(msg)
	log_subsystem("INIT", msg)
	return time

/**
 * Hook for printing stats to the "MC" statuspanel for admins to see performance and related stats etc.
 */
/datum/controller/subsystem/stat_entry()
	if(can_fire && !(SS_NO_FIRE & subsystem_flags))
		. = "[round(cost,1)]ms|[round(tick_usage,1)]%([round(tick_overrun,1)]%)|[round(ticks,0.1)]&emsp;"
	else
		. = "OFFLINE&emsp;"

/datum/controller/subsystem/stat_key()
	return can_fire? "\[[state_letter()]\][name]" : name

/datum/controller/subsystem/proc/state_letter()
	switch (state)
		if (SS_RUNNING)
			. = "R"
		if (SS_QUEUED)
			. = "Q"
		if (SS_PAUSED, SS_PAUSING)
			. = "P"
		if (SS_SLEEPING)
			. = "S"
		if (SS_IDLE)
			. = "  "

/**
 * Could be used to postpone a costly subsystem for (default one) var/cycles, cycles.
 * For instance, during cpu intensive operations like explosions.
 */
/datum/controller/subsystem/proc/postpone(cycles = 1)
	if(next_fire - world.time < wait)
		next_fire += (wait*cycles)


/**
 * Usually called via datum/controller/subsystem/New() when replacing a subsystem (i.e. due to a recurring crash).
 * Should attempt to salvage what it can from the old instance of subsystem.
 */
/datum/controller/subsystem/Recover()
	return TRUE


/datum/controller/subsystem/vv_edit_var(var_name, var_value)
	switch (var_name)
		if (NAMEOF(src, can_fire))
			// This is so the subsystem doesn't rapid fire to make up missed ticks causing more lag
			if (var_value)
				next_fire = world.time + wait

		if (NAMEOF(src, queued_priority)) // Editing this breaks things.
			return FALSE

	. = ..()

/datum/controller/subsystem/proc/subsystem_log(msg)
	return log_subsystem(name, msg)

/datum/controller/subsystem/proc/init_debug(msg)
	subsystem_log("init-debug: [msg]")

/datum/controller/subsystem/proc/init_log(msg)
	subsystem_log("init-log: [msg]")

/datum/controller/subsystem/proc/init_warning(msg)
	subsystem_log("init-warn: [msg]")
	message_admins("[src] load warning: [msg]")

/datum/controller/subsystem/proc/init_error(msg)
	subsystem_log("init-error: [msg]")
	message_admins(SPAN_BOLDANNOUNCE("[src] load error: [msg]"))

/datum/controller/subsystem/proc/init_fatal(msg)
	subsystem_log("init-fatal: [msg]")
	to_chat(world, SPAN_BOLDANNOUNCE("[src] load fatal: [msg]"))

/**
 * Called when max z is changed since subsystems hook it so much.
 *
 * todo: maploader might need to be able to init the new level before this fires if this ever does more than make indice-lists synchronize.
 *
 * Arguments:
 * * old_z_count - The old z count.
 * * new_z_count - The new z count.
 */
/datum/controller/subsystem/proc/on_max_z_changed(old_z_count, new_z_count)
	return

/**
 * Called when SQL is reconnected after being disconnected
 */
/datum/controller/subsystem/proc/on_sql_reconnect()
	return
