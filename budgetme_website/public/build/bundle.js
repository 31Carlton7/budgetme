(function () {
    'use strict';

    function noop() { }
    function assign(tar, src) {
        // @ts-ignore
        for (const k in src)
            tar[k] = src[k];
        return tar;
    }
    function run(fn) {
        return fn();
    }
    function blank_object() {
        return Object.create(null);
    }
    function run_all(fns) {
        fns.forEach(run);
    }
    function is_function(thing) {
        return typeof thing === 'function';
    }
    function safe_not_equal(a, b) {
        return a != a ? b == b : a !== b || ((a && typeof a === 'object') || typeof a === 'function');
    }
    let src_url_equal_anchor;
    function src_url_equal(element_src, url) {
        if (!src_url_equal_anchor) {
            src_url_equal_anchor = document.createElement('a');
        }
        src_url_equal_anchor.href = url;
        return element_src === src_url_equal_anchor.href;
    }
    function is_empty(obj) {
        return Object.keys(obj).length === 0;
    }
    function subscribe(store, ...callbacks) {
        if (store == null) {
            return noop;
        }
        const unsub = store.subscribe(...callbacks);
        return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
    }
    function append(target, node) {
        target.appendChild(node);
    }
    function insert(target, node, anchor) {
        target.insertBefore(node, anchor || null);
    }
    function detach(node) {
        node.parentNode.removeChild(node);
    }
    function destroy_each(iterations, detaching) {
        for (let i = 0; i < iterations.length; i += 1) {
            if (iterations[i])
                iterations[i].d(detaching);
        }
    }
    function element(name) {
        return document.createElement(name);
    }
    function svg_element(name) {
        return document.createElementNS('http://www.w3.org/2000/svg', name);
    }
    function text(data) {
        return document.createTextNode(data);
    }
    function space() {
        return text(' ');
    }
    function empty() {
        return text('');
    }
    function listen(node, event, handler, options) {
        node.addEventListener(event, handler, options);
        return () => node.removeEventListener(event, handler, options);
    }
    function attr(node, attribute, value) {
        if (value == null)
            node.removeAttribute(attribute);
        else if (node.getAttribute(attribute) !== value)
            node.setAttribute(attribute, value);
    }
    function children(element) {
        return Array.from(element.childNodes);
    }
    function set_data(text, data) {
        data = '' + data;
        if (text.wholeText !== data)
            text.data = data;
    }
    function custom_event(type, detail, { bubbles = false, cancelable = false } = {}) {
        const e = document.createEvent('CustomEvent');
        e.initCustomEvent(type, bubbles, cancelable, detail);
        return e;
    }

    let current_component;
    function set_current_component(component) {
        current_component = component;
    }
    function get_current_component() {
        if (!current_component)
            throw new Error('Function called outside component initialization');
        return current_component;
    }
    function afterUpdate(fn) {
        get_current_component().$$.after_update.push(fn);
    }
    function onDestroy(fn) {
        get_current_component().$$.on_destroy.push(fn);
    }
    function createEventDispatcher() {
        const component = get_current_component();
        return (type, detail, { cancelable = false } = {}) => {
            const callbacks = component.$$.callbacks[type];
            if (callbacks) {
                // TODO are there situations where events could be dispatched
                // in a server (non-DOM) environment?
                const event = custom_event(type, detail, { cancelable });
                callbacks.slice().forEach(fn => {
                    fn.call(component, event);
                });
                return !event.defaultPrevented;
            }
            return true;
        };
    }
    // TODO figure out if we still want to support
    // shorthand events, or if we want to implement
    // a real bubbling mechanism
    function bubble(component, event) {
        const callbacks = component.$$.callbacks[event.type];
        if (callbacks) {
            // @ts-ignore
            callbacks.slice().forEach(fn => fn.call(this, event));
        }
    }

    const dirty_components = [];
    const binding_callbacks = [];
    const render_callbacks = [];
    const flush_callbacks = [];
    const resolved_promise = Promise.resolve();
    let update_scheduled = false;
    function schedule_update() {
        if (!update_scheduled) {
            update_scheduled = true;
            resolved_promise.then(flush);
        }
    }
    function tick() {
        schedule_update();
        return resolved_promise;
    }
    function add_render_callback(fn) {
        render_callbacks.push(fn);
    }
    // flush() calls callbacks in this order:
    // 1. All beforeUpdate callbacks, in order: parents before children
    // 2. All bind:this callbacks, in reverse order: children before parents.
    // 3. All afterUpdate callbacks, in order: parents before children. EXCEPT
    //    for afterUpdates called during the initial onMount, which are called in
    //    reverse order: children before parents.
    // Since callbacks might update component values, which could trigger another
    // call to flush(), the following steps guard against this:
    // 1. During beforeUpdate, any updated components will be added to the
    //    dirty_components array and will cause a reentrant call to flush(). Because
    //    the flush index is kept outside the function, the reentrant call will pick
    //    up where the earlier call left off and go through all dirty components. The
    //    current_component value is saved and restored so that the reentrant call will
    //    not interfere with the "parent" flush() call.
    // 2. bind:this callbacks cannot trigger new flush() calls.
    // 3. During afterUpdate, any updated components will NOT have their afterUpdate
    //    callback called a second time; the seen_callbacks set, outside the flush()
    //    function, guarantees this behavior.
    const seen_callbacks = new Set();
    let flushidx = 0; // Do *not* move this inside the flush() function
    function flush() {
        const saved_component = current_component;
        do {
            // first, call beforeUpdate functions
            // and update components
            while (flushidx < dirty_components.length) {
                const component = dirty_components[flushidx];
                flushidx++;
                set_current_component(component);
                update(component.$$);
            }
            set_current_component(null);
            dirty_components.length = 0;
            flushidx = 0;
            while (binding_callbacks.length)
                binding_callbacks.pop()();
            // then, once components are updated, call
            // afterUpdate functions. This may cause
            // subsequent updates...
            for (let i = 0; i < render_callbacks.length; i += 1) {
                const callback = render_callbacks[i];
                if (!seen_callbacks.has(callback)) {
                    // ...so guard against infinite loops
                    seen_callbacks.add(callback);
                    callback();
                }
            }
            render_callbacks.length = 0;
        } while (dirty_components.length);
        while (flush_callbacks.length) {
            flush_callbacks.pop()();
        }
        update_scheduled = false;
        seen_callbacks.clear();
        set_current_component(saved_component);
    }
    function update($$) {
        if ($$.fragment !== null) {
            $$.update();
            run_all($$.before_update);
            const dirty = $$.dirty;
            $$.dirty = [-1];
            $$.fragment && $$.fragment.p($$.ctx, dirty);
            $$.after_update.forEach(add_render_callback);
        }
    }
    const outroing = new Set();
    let outros;
    function group_outros() {
        outros = {
            r: 0,
            c: [],
            p: outros // parent group
        };
    }
    function check_outros() {
        if (!outros.r) {
            run_all(outros.c);
        }
        outros = outros.p;
    }
    function transition_in(block, local) {
        if (block && block.i) {
            outroing.delete(block);
            block.i(local);
        }
    }
    function transition_out(block, local, detach, callback) {
        if (block && block.o) {
            if (outroing.has(block))
                return;
            outroing.add(block);
            outros.c.push(() => {
                outroing.delete(block);
                if (callback) {
                    if (detach)
                        block.d(1);
                    callback();
                }
            });
            block.o(local);
        }
        else if (callback) {
            callback();
        }
    }

    function get_spread_update(levels, updates) {
        const update = {};
        const to_null_out = {};
        const accounted_for = { $$scope: 1 };
        let i = levels.length;
        while (i--) {
            const o = levels[i];
            const n = updates[i];
            if (n) {
                for (const key in o) {
                    if (!(key in n))
                        to_null_out[key] = 1;
                }
                for (const key in n) {
                    if (!accounted_for[key]) {
                        update[key] = n[key];
                        accounted_for[key] = 1;
                    }
                }
                levels[i] = n;
            }
            else {
                for (const key in o) {
                    accounted_for[key] = 1;
                }
            }
        }
        for (const key in to_null_out) {
            if (!(key in update))
                update[key] = undefined;
        }
        return update;
    }
    function get_spread_object(spread_props) {
        return typeof spread_props === 'object' && spread_props !== null ? spread_props : {};
    }
    function create_component(block) {
        block && block.c();
    }
    function mount_component(component, target, anchor, customElement) {
        const { fragment, on_mount, on_destroy, after_update } = component.$$;
        fragment && fragment.m(target, anchor);
        if (!customElement) {
            // onMount happens before the initial afterUpdate
            add_render_callback(() => {
                const new_on_destroy = on_mount.map(run).filter(is_function);
                if (on_destroy) {
                    on_destroy.push(...new_on_destroy);
                }
                else {
                    // Edge case - component was destroyed immediately,
                    // most likely as a result of a binding initialising
                    run_all(new_on_destroy);
                }
                component.$$.on_mount = [];
            });
        }
        after_update.forEach(add_render_callback);
    }
    function destroy_component(component, detaching) {
        const $$ = component.$$;
        if ($$.fragment !== null) {
            run_all($$.on_destroy);
            $$.fragment && $$.fragment.d(detaching);
            // TODO null out other refs, including component.$$ (but need to
            // preserve final state?)
            $$.on_destroy = $$.fragment = null;
            $$.ctx = [];
        }
    }
    function make_dirty(component, i) {
        if (component.$$.dirty[0] === -1) {
            dirty_components.push(component);
            schedule_update();
            component.$$.dirty.fill(0);
        }
        component.$$.dirty[(i / 31) | 0] |= (1 << (i % 31));
    }
    function init(component, options, instance, create_fragment, not_equal, props, append_styles, dirty = [-1]) {
        const parent_component = current_component;
        set_current_component(component);
        const $$ = component.$$ = {
            fragment: null,
            ctx: null,
            // state
            props,
            update: noop,
            not_equal,
            bound: blank_object(),
            // lifecycle
            on_mount: [],
            on_destroy: [],
            on_disconnect: [],
            before_update: [],
            after_update: [],
            context: new Map(options.context || (parent_component ? parent_component.$$.context : [])),
            // everything else
            callbacks: blank_object(),
            dirty,
            skip_bound: false,
            root: options.target || parent_component.$$.root
        };
        append_styles && append_styles($$.root);
        let ready = false;
        $$.ctx = instance
            ? instance(component, options.props || {}, (i, ret, ...rest) => {
                const value = rest.length ? rest[0] : ret;
                if ($$.ctx && not_equal($$.ctx[i], $$.ctx[i] = value)) {
                    if (!$$.skip_bound && $$.bound[i])
                        $$.bound[i](value);
                    if (ready)
                        make_dirty(component, i);
                }
                return ret;
            })
            : [];
        $$.update();
        ready = true;
        run_all($$.before_update);
        // `false` as a special case of no DOM component
        $$.fragment = create_fragment ? create_fragment($$.ctx) : false;
        if (options.target) {
            if (options.hydrate) {
                const nodes = children(options.target);
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.l(nodes);
                nodes.forEach(detach);
            }
            else {
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.c();
            }
            if (options.intro)
                transition_in(component.$$.fragment);
            mount_component(component, options.target, options.anchor, options.customElement);
            flush();
        }
        set_current_component(parent_component);
    }
    /**
     * Base class for Svelte components. Used when dev=false.
     */
    class SvelteComponent {
        $destroy() {
            destroy_component(this, 1);
            this.$destroy = noop;
        }
        $on(type, callback) {
            const callbacks = (this.$$.callbacks[type] || (this.$$.callbacks[type] = []));
            callbacks.push(callback);
            return () => {
                const index = callbacks.indexOf(callback);
                if (index !== -1)
                    callbacks.splice(index, 1);
            };
        }
        $set($$props) {
            if (this.$$set && !is_empty($$props)) {
                this.$$.skip_bound = true;
                this.$$set($$props);
                this.$$.skip_bound = false;
            }
        }
    }

    const subscriber_queue = [];
    /**
     * Creates a `Readable` store that allows reading by subscription.
     * @param value initial value
     * @param {StartStopNotifier}start start and stop notifications for subscriptions
     */
    function readable(value, start) {
        return {
            subscribe: writable(value, start).subscribe
        };
    }
    /**
     * Create a `Writable` store that allows both updating and reading by subscription.
     * @param {*=}value initial value
     * @param {StartStopNotifier=}start start and stop notifications for subscriptions
     */
    function writable(value, start = noop) {
        let stop;
        const subscribers = new Set();
        function set(new_value) {
            if (safe_not_equal(value, new_value)) {
                value = new_value;
                if (stop) { // store is ready
                    const run_queue = !subscriber_queue.length;
                    for (const subscriber of subscribers) {
                        subscriber[1]();
                        subscriber_queue.push(subscriber, value);
                    }
                    if (run_queue) {
                        for (let i = 0; i < subscriber_queue.length; i += 2) {
                            subscriber_queue[i][0](subscriber_queue[i + 1]);
                        }
                        subscriber_queue.length = 0;
                    }
                }
            }
        }
        function update(fn) {
            set(fn(value));
        }
        function subscribe(run, invalidate = noop) {
            const subscriber = [run, invalidate];
            subscribers.add(subscriber);
            if (subscribers.size === 1) {
                stop = start(set) || noop;
            }
            run(value);
            return () => {
                subscribers.delete(subscriber);
                if (subscribers.size === 0) {
                    stop();
                    stop = null;
                }
            };
        }
        return { set, update, subscribe };
    }
    function derived(stores, fn, initial_value) {
        const single = !Array.isArray(stores);
        const stores_array = single
            ? [stores]
            : stores;
        const auto = fn.length < 2;
        return readable(initial_value, (set) => {
            let inited = false;
            const values = [];
            let pending = 0;
            let cleanup = noop;
            const sync = () => {
                if (pending) {
                    return;
                }
                cleanup();
                const result = fn(single ? values[0] : values, set);
                if (auto) {
                    set(result);
                }
                else {
                    cleanup = is_function(result) ? result : noop;
                }
            };
            const unsubscribers = stores_array.map((store, i) => subscribe(store, (value) => {
                values[i] = value;
                pending &= ~(1 << i);
                if (inited) {
                    sync();
                }
            }, () => {
                pending |= (1 << i);
            }));
            inited = true;
            sync();
            return function stop() {
                run_all(unsubscribers);
                cleanup();
            };
        });
    }

    function parse(str, loose) {
    	if (str instanceof RegExp) return { keys:false, pattern:str };
    	var c, o, tmp, ext, keys=[], pattern='', arr = str.split('/');
    	arr[0] || arr.shift();

    	while (tmp = arr.shift()) {
    		c = tmp[0];
    		if (c === '*') {
    			keys.push('wild');
    			pattern += '/(.*)';
    		} else if (c === ':') {
    			o = tmp.indexOf('?', 1);
    			ext = tmp.indexOf('.', 1);
    			keys.push( tmp.substring(1, !!~o ? o : !!~ext ? ext : tmp.length) );
    			pattern += !!~o && !~ext ? '(?:/([^/]+?))?' : '/([^/]+?)';
    			if (!!~ext) pattern += (!!~o ? '?' : '') + '\\' + tmp.substring(ext);
    		} else {
    			pattern += '/' + tmp;
    		}
    	}

    	return {
    		keys: keys,
    		pattern: new RegExp('^' + pattern + (loose ? '(?=$|\/)' : '\/?$'), 'i')
    	};
    }

    /* node_modules/svelte-spa-router/Router.svelte generated by Svelte v3.49.0 */

    function create_else_block$1(ctx) {
    	let switch_instance;
    	let switch_instance_anchor;
    	let current;
    	const switch_instance_spread_levels = [/*props*/ ctx[2]];
    	var switch_value = /*component*/ ctx[0];

    	function switch_props(ctx) {
    		let switch_instance_props = {};

    		for (let i = 0; i < switch_instance_spread_levels.length; i += 1) {
    			switch_instance_props = assign(switch_instance_props, switch_instance_spread_levels[i]);
    		}

    		return { props: switch_instance_props };
    	}

    	if (switch_value) {
    		switch_instance = new switch_value(switch_props());
    		switch_instance.$on("routeEvent", /*routeEvent_handler_1*/ ctx[7]);
    	}

    	return {
    		c() {
    			if (switch_instance) create_component(switch_instance.$$.fragment);
    			switch_instance_anchor = empty();
    		},
    		m(target, anchor) {
    			if (switch_instance) {
    				mount_component(switch_instance, target, anchor);
    			}

    			insert(target, switch_instance_anchor, anchor);
    			current = true;
    		},
    		p(ctx, dirty) {
    			const switch_instance_changes = (dirty & /*props*/ 4)
    			? get_spread_update(switch_instance_spread_levels, [get_spread_object(/*props*/ ctx[2])])
    			: {};

    			if (switch_value !== (switch_value = /*component*/ ctx[0])) {
    				if (switch_instance) {
    					group_outros();
    					const old_component = switch_instance;

    					transition_out(old_component.$$.fragment, 1, 0, () => {
    						destroy_component(old_component, 1);
    					});

    					check_outros();
    				}

    				if (switch_value) {
    					switch_instance = new switch_value(switch_props());
    					switch_instance.$on("routeEvent", /*routeEvent_handler_1*/ ctx[7]);
    					create_component(switch_instance.$$.fragment);
    					transition_in(switch_instance.$$.fragment, 1);
    					mount_component(switch_instance, switch_instance_anchor.parentNode, switch_instance_anchor);
    				} else {
    					switch_instance = null;
    				}
    			} else if (switch_value) {
    				switch_instance.$set(switch_instance_changes);
    			}
    		},
    		i(local) {
    			if (current) return;
    			if (switch_instance) transition_in(switch_instance.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			if (switch_instance) transition_out(switch_instance.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(switch_instance_anchor);
    			if (switch_instance) destroy_component(switch_instance, detaching);
    		}
    	};
    }

    // (244:0) {#if componentParams}
    function create_if_block$1(ctx) {
    	let switch_instance;
    	let switch_instance_anchor;
    	let current;
    	const switch_instance_spread_levels = [{ params: /*componentParams*/ ctx[1] }, /*props*/ ctx[2]];
    	var switch_value = /*component*/ ctx[0];

    	function switch_props(ctx) {
    		let switch_instance_props = {};

    		for (let i = 0; i < switch_instance_spread_levels.length; i += 1) {
    			switch_instance_props = assign(switch_instance_props, switch_instance_spread_levels[i]);
    		}

    		return { props: switch_instance_props };
    	}

    	if (switch_value) {
    		switch_instance = new switch_value(switch_props());
    		switch_instance.$on("routeEvent", /*routeEvent_handler*/ ctx[6]);
    	}

    	return {
    		c() {
    			if (switch_instance) create_component(switch_instance.$$.fragment);
    			switch_instance_anchor = empty();
    		},
    		m(target, anchor) {
    			if (switch_instance) {
    				mount_component(switch_instance, target, anchor);
    			}

    			insert(target, switch_instance_anchor, anchor);
    			current = true;
    		},
    		p(ctx, dirty) {
    			const switch_instance_changes = (dirty & /*componentParams, props*/ 6)
    			? get_spread_update(switch_instance_spread_levels, [
    					dirty & /*componentParams*/ 2 && { params: /*componentParams*/ ctx[1] },
    					dirty & /*props*/ 4 && get_spread_object(/*props*/ ctx[2])
    				])
    			: {};

    			if (switch_value !== (switch_value = /*component*/ ctx[0])) {
    				if (switch_instance) {
    					group_outros();
    					const old_component = switch_instance;

    					transition_out(old_component.$$.fragment, 1, 0, () => {
    						destroy_component(old_component, 1);
    					});

    					check_outros();
    				}

    				if (switch_value) {
    					switch_instance = new switch_value(switch_props());
    					switch_instance.$on("routeEvent", /*routeEvent_handler*/ ctx[6]);
    					create_component(switch_instance.$$.fragment);
    					transition_in(switch_instance.$$.fragment, 1);
    					mount_component(switch_instance, switch_instance_anchor.parentNode, switch_instance_anchor);
    				} else {
    					switch_instance = null;
    				}
    			} else if (switch_value) {
    				switch_instance.$set(switch_instance_changes);
    			}
    		},
    		i(local) {
    			if (current) return;
    			if (switch_instance) transition_in(switch_instance.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			if (switch_instance) transition_out(switch_instance.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(switch_instance_anchor);
    			if (switch_instance) destroy_component(switch_instance, detaching);
    		}
    	};
    }

    function create_fragment$k(ctx) {
    	let current_block_type_index;
    	let if_block;
    	let if_block_anchor;
    	let current;
    	const if_block_creators = [create_if_block$1, create_else_block$1];
    	const if_blocks = [];

    	function select_block_type(ctx, dirty) {
    		if (/*componentParams*/ ctx[1]) return 0;
    		return 1;
    	}

    	current_block_type_index = select_block_type(ctx);
    	if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

    	return {
    		c() {
    			if_block.c();
    			if_block_anchor = empty();
    		},
    		m(target, anchor) {
    			if_blocks[current_block_type_index].m(target, anchor);
    			insert(target, if_block_anchor, anchor);
    			current = true;
    		},
    		p(ctx, [dirty]) {
    			let previous_block_index = current_block_type_index;
    			current_block_type_index = select_block_type(ctx);

    			if (current_block_type_index === previous_block_index) {
    				if_blocks[current_block_type_index].p(ctx, dirty);
    			} else {
    				group_outros();

    				transition_out(if_blocks[previous_block_index], 1, 1, () => {
    					if_blocks[previous_block_index] = null;
    				});

    				check_outros();
    				if_block = if_blocks[current_block_type_index];

    				if (!if_block) {
    					if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
    					if_block.c();
    				} else {
    					if_block.p(ctx, dirty);
    				}

    				transition_in(if_block, 1);
    				if_block.m(if_block_anchor.parentNode, if_block_anchor);
    			}
    		},
    		i(local) {
    			if (current) return;
    			transition_in(if_block);
    			current = true;
    		},
    		o(local) {
    			transition_out(if_block);
    			current = false;
    		},
    		d(detaching) {
    			if_blocks[current_block_type_index].d(detaching);
    			if (detaching) detach(if_block_anchor);
    		}
    	};
    }

    /**
     * @typedef {Object} Location
     * @property {string} location - Location (page/view), for example `/book`
     * @property {string} [querystring] - Querystring from the hash, as a string not parsed
     */
    /**
     * Returns the current location from the hash.
     *
     * @returns {Location} Location object
     * @private
     */
    function getLocation() {
    	const hashPosition = window.location.href.indexOf('#/');

    	let location = hashPosition > -1
    	? window.location.href.substr(hashPosition + 1)
    	: '/';

    	// Check if there's a querystring
    	const qsPosition = location.indexOf('?');

    	let querystring = '';

    	if (qsPosition > -1) {
    		querystring = location.substr(qsPosition + 1);
    		location = location.substr(0, qsPosition);
    	}

    	return { location, querystring };
    }

    const loc = readable(null, // eslint-disable-next-line prefer-arrow-callback
    function start(set) {
    	set(getLocation());

    	const update = () => {
    		set(getLocation());
    	};

    	window.addEventListener('hashchange', update, false);

    	return function stop() {
    		window.removeEventListener('hashchange', update, false);
    	};
    });

    derived(loc, $loc => $loc.location);
    derived(loc, $loc => $loc.querystring);
    const params = writable(undefined);

    function instance$5($$self, $$props, $$invalidate) {
    	let { routes = {} } = $$props;
    	let { prefix = '' } = $$props;
    	let { restoreScrollState = false } = $$props;

    	/**
     * Container for a route: path, component
     */
    	class RouteItem {
    		/**
     * Initializes the object and creates a regular expression from the path, using regexparam.
     *
     * @param {string} path - Path to the route (must start with '/' or '*')
     * @param {SvelteComponent|WrappedComponent} component - Svelte component for the route, optionally wrapped
     */
    		constructor(path, component) {
    			if (!component || typeof component != 'function' && (typeof component != 'object' || component._sveltesparouter !== true)) {
    				throw Error('Invalid component object');
    			}

    			// Path must be a regular or expression, or a string starting with '/' or '*'
    			if (!path || typeof path == 'string' && (path.length < 1 || path.charAt(0) != '/' && path.charAt(0) != '*') || typeof path == 'object' && !(path instanceof RegExp)) {
    				throw Error('Invalid value for "path" argument - strings must start with / or *');
    			}

    			const { pattern, keys } = parse(path);
    			this.path = path;

    			// Check if the component is wrapped and we have conditions
    			if (typeof component == 'object' && component._sveltesparouter === true) {
    				this.component = component.component;
    				this.conditions = component.conditions || [];
    				this.userData = component.userData;
    				this.props = component.props || {};
    			} else {
    				// Convert the component to a function that returns a Promise, to normalize it
    				this.component = () => Promise.resolve(component);

    				this.conditions = [];
    				this.props = {};
    			}

    			this._pattern = pattern;
    			this._keys = keys;
    		}

    		/**
     * Checks if `path` matches the current route.
     * If there's a match, will return the list of parameters from the URL (if any).
     * In case of no match, the method will return `null`.
     *
     * @param {string} path - Path to test
     * @returns {null|Object.<string, string>} List of paramters from the URL if there's a match, or `null` otherwise.
     */
    		match(path) {
    			// If there's a prefix, check if it matches the start of the path.
    			// If not, bail early, else remove it before we run the matching.
    			if (prefix) {
    				if (typeof prefix == 'string') {
    					if (path.startsWith(prefix)) {
    						path = path.substr(prefix.length) || '/';
    					} else {
    						return null;
    					}
    				} else if (prefix instanceof RegExp) {
    					const match = path.match(prefix);

    					if (match && match[0]) {
    						path = path.substr(match[0].length) || '/';
    					} else {
    						return null;
    					}
    				}
    			}

    			// Check if the pattern matches
    			const matches = this._pattern.exec(path);

    			if (matches === null) {
    				return null;
    			}

    			// If the input was a regular expression, this._keys would be false, so return matches as is
    			if (this._keys === false) {
    				return matches;
    			}

    			const out = {};
    			let i = 0;

    			while (i < this._keys.length) {
    				// In the match parameters, URL-decode all values
    				try {
    					out[this._keys[i]] = decodeURIComponent(matches[i + 1] || '') || null;
    				} catch(e) {
    					out[this._keys[i]] = null;
    				}

    				i++;
    			}

    			return out;
    		}

    		/**
     * Dictionary with route details passed to the pre-conditions functions, as well as the `routeLoading`, `routeLoaded` and `conditionsFailed` events
     * @typedef {Object} RouteDetail
     * @property {string|RegExp} route - Route matched as defined in the route definition (could be a string or a reguar expression object)
     * @property {string} location - Location path
     * @property {string} querystring - Querystring from the hash
     * @property {object} [userData] - Custom data passed by the user
     * @property {SvelteComponent} [component] - Svelte component (only in `routeLoaded` events)
     * @property {string} [name] - Name of the Svelte component (only in `routeLoaded` events)
     */
    		/**
     * Executes all conditions (if any) to control whether the route can be shown. Conditions are executed in the order they are defined, and if a condition fails, the following ones aren't executed.
     * 
     * @param {RouteDetail} detail - Route detail
     * @returns {boolean} Returns true if all the conditions succeeded
     */
    		async checkConditions(detail) {
    			for (let i = 0; i < this.conditions.length; i++) {
    				if (!await this.conditions[i](detail)) {
    					return false;
    				}
    			}

    			return true;
    		}
    	}

    	// Set up all routes
    	const routesList = [];

    	if (routes instanceof Map) {
    		// If it's a map, iterate on it right away
    		routes.forEach((route, path) => {
    			routesList.push(new RouteItem(path, route));
    		});
    	} else {
    		// We have an object, so iterate on its own properties
    		Object.keys(routes).forEach(path => {
    			routesList.push(new RouteItem(path, routes[path]));
    		});
    	}

    	// Props for the component to render
    	let component = null;

    	let componentParams = null;
    	let props = {};

    	// Event dispatcher from Svelte
    	const dispatch = createEventDispatcher();

    	// Just like dispatch, but executes on the next iteration of the event loop
    	async function dispatchNextTick(name, detail) {
    		// Execute this code when the current call stack is complete
    		await tick();

    		dispatch(name, detail);
    	}

    	// If this is set, then that means we have popped into this var the state of our last scroll position
    	let previousScrollState = null;

    	let popStateChanged = null;

    	if (restoreScrollState) {
    		popStateChanged = event => {
    			// If this event was from our history.replaceState, event.state will contain
    			// our scroll history. Otherwise, event.state will be null (like on forward
    			// navigation)
    			if (event.state && event.state.__svelte_spa_router_scrollY) {
    				previousScrollState = event.state;
    			} else {
    				previousScrollState = null;
    			}
    		};

    		// This is removed in the destroy() invocation below
    		window.addEventListener('popstate', popStateChanged);

    		afterUpdate(() => {
    			// If this exists, then this is a back navigation: restore the scroll position
    			if (previousScrollState) {
    				window.scrollTo(previousScrollState.__svelte_spa_router_scrollX, previousScrollState.__svelte_spa_router_scrollY);
    			} else {
    				// Otherwise this is a forward navigation: scroll to top
    				window.scrollTo(0, 0);
    			}
    		});
    	}

    	// Always have the latest value of loc
    	let lastLoc = null;

    	// Current object of the component loaded
    	let componentObj = null;

    	// Handle hash change events
    	// Listen to changes in the $loc store and update the page
    	// Do not use the $: syntax because it gets triggered by too many things
    	const unsubscribeLoc = loc.subscribe(async newLoc => {
    		lastLoc = newLoc;

    		// Find a route matching the location
    		let i = 0;

    		while (i < routesList.length) {
    			const match = routesList[i].match(newLoc.location);

    			if (!match) {
    				i++;
    				continue;
    			}

    			const detail = {
    				route: routesList[i].path,
    				location: newLoc.location,
    				querystring: newLoc.querystring,
    				userData: routesList[i].userData,
    				params: match && typeof match == 'object' && Object.keys(match).length
    				? match
    				: null
    			};

    			// Check if the route can be loaded - if all conditions succeed
    			if (!await routesList[i].checkConditions(detail)) {
    				// Don't display anything
    				$$invalidate(0, component = null);

    				componentObj = null;

    				// Trigger an event to notify the user, then exit
    				dispatchNextTick('conditionsFailed', detail);

    				return;
    			}

    			// Trigger an event to alert that we're loading the route
    			// We need to clone the object on every event invocation so we don't risk the object to be modified in the next tick
    			dispatchNextTick('routeLoading', Object.assign({}, detail));

    			// If there's a component to show while we're loading the route, display it
    			const obj = routesList[i].component;

    			// Do not replace the component if we're loading the same one as before, to avoid the route being unmounted and re-mounted
    			if (componentObj != obj) {
    				if (obj.loading) {
    					$$invalidate(0, component = obj.loading);
    					componentObj = obj;
    					$$invalidate(1, componentParams = obj.loadingParams);
    					$$invalidate(2, props = {});

    					// Trigger the routeLoaded event for the loading component
    					// Create a copy of detail so we don't modify the object for the dynamic route (and the dynamic route doesn't modify our object too)
    					dispatchNextTick('routeLoaded', Object.assign({}, detail, {
    						component,
    						name: component.name,
    						params: componentParams
    					}));
    				} else {
    					$$invalidate(0, component = null);
    					componentObj = null;
    				}

    				// Invoke the Promise
    				const loaded = await obj();

    				// Now that we're here, after the promise resolved, check if we still want this component, as the user might have navigated to another page in the meanwhile
    				if (newLoc != lastLoc) {
    					// Don't update the component, just exit
    					return;
    				}

    				// If there is a "default" property, which is used by async routes, then pick that
    				$$invalidate(0, component = loaded && loaded.default || loaded);

    				componentObj = obj;
    			}

    			// Set componentParams only if we have a match, to avoid a warning similar to `<Component> was created with unknown prop 'params'`
    			// Of course, this assumes that developers always add a "params" prop when they are expecting parameters
    			if (match && typeof match == 'object' && Object.keys(match).length) {
    				$$invalidate(1, componentParams = match);
    			} else {
    				$$invalidate(1, componentParams = null);
    			}

    			// Set static props, if any
    			$$invalidate(2, props = routesList[i].props);

    			// Dispatch the routeLoaded event then exit
    			// We need to clone the object on every event invocation so we don't risk the object to be modified in the next tick
    			dispatchNextTick('routeLoaded', Object.assign({}, detail, {
    				component,
    				name: component.name,
    				params: componentParams
    			})).then(() => {
    				params.set(componentParams);
    			});

    			return;
    		}

    		// If we're still here, there was no match, so show the empty component
    		$$invalidate(0, component = null);

    		componentObj = null;
    		params.set(undefined);
    	});

    	onDestroy(() => {
    		unsubscribeLoc();
    		popStateChanged && window.removeEventListener('popstate', popStateChanged);
    	});

    	function routeEvent_handler(event) {
    		bubble.call(this, $$self, event);
    	}

    	function routeEvent_handler_1(event) {
    		bubble.call(this, $$self, event);
    	}

    	$$self.$$set = $$props => {
    		if ('routes' in $$props) $$invalidate(3, routes = $$props.routes);
    		if ('prefix' in $$props) $$invalidate(4, prefix = $$props.prefix);
    		if ('restoreScrollState' in $$props) $$invalidate(5, restoreScrollState = $$props.restoreScrollState);
    	};

    	$$self.$$.update = () => {
    		if ($$self.$$.dirty & /*restoreScrollState*/ 32) {
    			// Update history.scrollRestoration depending on restoreScrollState
    			history.scrollRestoration = restoreScrollState ? 'manual' : 'auto';
    		}
    	};

    	return [
    		component,
    		componentParams,
    		props,
    		routes,
    		prefix,
    		restoreScrollState,
    		routeEvent_handler,
    		routeEvent_handler_1
    	];
    }

    class Router extends SvelteComponent {
    	constructor(options) {
    		super();

    		init(this, options, instance$5, create_fragment$k, safe_not_equal, {
    			routes: 3,
    			prefix: 4,
    			restoreScrollState: 5
    		});
    	}
    }

    /* src/lib/components/Banner.svelte generated by Svelte v3.49.0 */

    function create_fragment$j(ctx) {
    	let div;

    	return {
    		c() {
    			div = element("div");
    			div.innerHTML = `<h1 class="font-bold md:text-6xl sm:text-3xl text-white">Download BudgetMe Today!</h1>`;
    			attr(div, "class", "bg-gradient-to-b from-primary-500 to-primary-600 w-screen left-1/2 right-1/2 -mr-[50vw] -ml-[50vw] relative flex py-20 items-center justify-center");
    		},
    		m(target, anchor) {
    			insert(target, div, anchor);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(div);
    		}
    	};
    }

    class Banner extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$j, safe_not_equal, {});
    	}
    }

    /* src/lib/components/AppStoreDownloadButton.svelte generated by Svelte v3.49.0 */

    function create_fragment$i(ctx) {
    	let a;

    	return {
    		c() {
    			a = element("a");
    			a.innerHTML = `<img src="../src/assets/images/app_store_download_button.png" alt="" width="175"/>`;
    			attr(a, "href", "/");
    			attr(a, "class", "px-2");
    		},
    		m(target, anchor) {
    			insert(target, a, anchor);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a);
    		}
    	};
    }

    class AppStoreDownloadButton extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$i, safe_not_equal, {});
    	}
    }

    /* src/lib/components/GooglePlayDownloadButton.svelte generated by Svelte v3.49.0 */

    function create_fragment$h(ctx) {
    	let a;

    	return {
    		c() {
    			a = element("a");
    			a.innerHTML = `<img src="../src/assets/images/google_play_download_button.png" alt="" width="175"/>`;
    			attr(a, "href", "/");
    			attr(a, "class", "px-2");
    		},
    		m(target, anchor) {
    			insert(target, a, anchor);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a);
    		}
    	};
    }

    class GooglePlayDownloadButton extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$h, safe_not_equal, {});
    	}
    }

    /* src/lib/components/Logo.svelte generated by Svelte v3.49.0 */

    function create_fragment$g(ctx) {
    	let div;

    	return {
    		c() {
    			div = element("div");

    			div.innerHTML = `<img src="../src/assets/images/icon.png" alt="" width="30" height="auto"/> 
  <h1 class="px-2 font-semibold text-xl">BudgetMe</h1>`;

    			attr(div, "class", "flex items-center");
    		},
    		m(target, anchor) {
    			insert(target, div, anchor);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(div);
    		}
    	};
    }

    class Logo extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$g, safe_not_equal, {});
    	}
    }

    /* src/lib/components/Footer.svelte generated by Svelte v3.49.0 */

    function create_fragment$f(ctx) {
    	let footer;
    	let div8;
    	let div3;
    	let a0;
    	let logo;
    	let t0;
    	let div2;
    	let t8;
    	let div7;
    	let div4;
    	let t16;
    	let div5;
    	let t22;
    	let div6;
    	let h22;
    	let t24;
    	let ul2;
    	let li5;
    	let a10;
    	let appstoredownloadbutton;
    	let t25;
    	let li6;
    	let a11;
    	let googleplaydownloadbutton;
    	let t26;
    	let div9;
    	let current;
    	logo = new Logo({});
    	appstoredownloadbutton = new AppStoreDownloadButton({});
    	googleplaydownloadbutton = new GooglePlayDownloadButton({});

    	return {
    		c() {
    			footer = element("footer");
    			div8 = element("div");
    			div3 = element("div");
    			a0 = element("a");
    			create_component(logo.$$.fragment);
    			t0 = space();
    			div2 = element("div");

    			div2.innerHTML = `<p class="mt-5 sm:mt-10 lg:w-10/12 text-gray-600 text-lg">Save money this summer for the more
          <span class="italic">meaningful</span>
          things.</p> 
        <div class="social-buttons sm:flex sm:items-center sm:justify-between"><div class="flex mt-4 py-4 space-x-6 sm:justify-center sm:mt-0"><a href="https://www.linkedin.com/in/carlton-aikins-a34a14226/" target="_blank" class="social-btn svelte-1siz518"><svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" clip-rule="evenodd" d="M5.26433 21.3846H0.95842V7.51803H5.26433V21.3846ZM3.10906 5.62651C1.73217 5.62651 0.615356 4.48603 0.615356 3.10911C0.615356 2.44773 0.878085 1.81343 1.34574 1.34576C1.8134 0.878091 2.44769 0.615356 3.10906 0.615356C3.77042 0.615356 4.40471 0.878091 4.87237 1.34576C5.34003 1.81343 5.60275 2.44773 5.60275 3.10911C5.60275 4.48603 4.48548 5.62651 3.10906 5.62651ZM21.38 21.3846H17.0833V14.6344C17.0833 13.0257 17.0509 10.9627 14.8446 10.9627C12.6059 10.9627 12.2628 12.7105 12.2628 14.5185V21.3846H7.96154V7.51803H12.0913V9.40956H12.1516C12.7264 8.32008 14.1307 7.17033 16.2257 7.17033C20.5835 7.17033 21.3846 10.0401 21.3846 13.7675V21.3846H21.38Z"></path></svg></a> 
            <a href="https://github.com/31carlton7/budgetme" target="_blank" class="social-btn svelte-1siz518"><svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd"></path></svg></a> 
            <a href="https://www.twitter.com/31carlton7" target="_blank" class="social-btn svelte-1siz518"><svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"></path></svg></a> 
            <a href="https://www.instagram.com/31carlton7" target="_blank" class="social-btn svelte-1siz518"><svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd"></path></svg></a></div></div>`;

    			t8 = space();
    			div7 = element("div");
    			div4 = element("div");

    			div4.innerHTML = `<h2 class="mb-6 text-lg font-semibold text-gray-600">BudgetMe</h2> 
        <ul class="text-gray-600 "><li class="mb-4"><a href="/" class="hover:text-gray-500">Website</a></li> 
          <li class="mb-4"><a href="#/about" class="hover:text-gray-500">About</a></li> 
          <li class="mb-4"><a href="#/privacypolicy" class="hover:text-gray-500">Privacy Policy</a></li></ul>`;

    			t16 = space();
    			div5 = element("div");

    			div5.innerHTML = `<h2 class="mb-6 text-lg font-semibold text-gray-600 ">Contact</h2> 
        <ul class="text-gray-600 "><li class="mb-4"><a href="mailto:carltonaikins7@gmail.com" class="hover:text-gray-500 ">Email</a></li> 
          <li><a href="#/support" class="hover:text-gray-500">Support</a></li></ul>`;

    			t22 = space();
    			div6 = element("div");
    			h22 = element("h2");
    			h22.textContent = "Download";
    			t24 = space();
    			ul2 = element("ul");
    			li5 = element("li");
    			a10 = element("a");
    			create_component(appstoredownloadbutton.$$.fragment);
    			t25 = space();
    			li6 = element("li");
    			a11 = element("a");
    			create_component(googleplaydownloadbutton.$$.fragment);
    			t26 = space();
    			div9 = element("div");

    			div9.innerHTML = `<span class="text-sm text-gray-600 sm:text-center">Copyright © 2022 <a href="/" class="hover:text-gray-500">BudgetMe</a></span> 
    <span class="text-sm text-gray-600 sm:text-center">Created by Carlton Aikins</span>`;

    			attr(a0, "href", "/");
    			attr(a0, "class", "flex items-center");
    			attr(div2, "class", "w-80");
    			attr(div3, "class", "mb-4 md:mb-0");
    			attr(h22, "class", "text-lg font-semibold text-gray-600 ");
    			attr(a10, "href", "/");
    			attr(a10, "class", "hover:text-gray-500 ");
    			attr(li5, "class", "-mb-6");
    			attr(a11, "href", "/");
    			attr(a11, "class", "hover:text-gray-500");
    			attr(ul2, "class", "text-gray-600 ");
    			attr(div7, "class", "grid grid-cols-2 gap-8 sm:gap-6 sm:grid-cols-3");
    			attr(div8, "class", "lg:flex lg:justify-between lg:items-center md:px-48 sm:px-24");
    			attr(div9, "class", "my-32 flex-row flex justify-between space-x-16 px-48");
    			attr(footer, "class", "py-12 overflow-hidden bg-gray-100 px-12 w-screen left-1/2 right-1/2 -mr-[50vw] -ml-[50vw] relative");
    		},
    		m(target, anchor) {
    			insert(target, footer, anchor);
    			append(footer, div8);
    			append(div8, div3);
    			append(div3, a0);
    			mount_component(logo, a0, null);
    			append(div3, t0);
    			append(div3, div2);
    			append(div8, t8);
    			append(div8, div7);
    			append(div7, div4);
    			append(div7, t16);
    			append(div7, div5);
    			append(div7, t22);
    			append(div7, div6);
    			append(div6, h22);
    			append(div6, t24);
    			append(div6, ul2);
    			append(ul2, li5);
    			append(li5, a10);
    			mount_component(appstoredownloadbutton, a10, null);
    			append(ul2, t25);
    			append(ul2, li6);
    			append(li6, a11);
    			mount_component(googleplaydownloadbutton, a11, null);
    			append(footer, t26);
    			append(footer, div9);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(logo.$$.fragment, local);
    			transition_in(appstoredownloadbutton.$$.fragment, local);
    			transition_in(googleplaydownloadbutton.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(logo.$$.fragment, local);
    			transition_out(appstoredownloadbutton.$$.fragment, local);
    			transition_out(googleplaydownloadbutton.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(footer);
    			destroy_component(logo);
    			destroy_component(appstoredownloadbutton);
    			destroy_component(googleplaydownloadbutton);
    		}
    	};
    }

    class Footer extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$f, safe_not_equal, {});
    	}
    }

    /* src/lib/components/HomePage/HeroSection.svelte generated by Svelte v3.49.0 */

    function create_fragment$e(ctx) {
    	let div3;
    	let div2;
    	let div0;
    	let t7;
    	let div1;
    	let appstoredownloadbutton;
    	let t8;
    	let googleplaydownloadbutton;
    	let current;
    	appstoredownloadbutton = new AppStoreDownloadButton({});
    	googleplaydownloadbutton = new GooglePlayDownloadButton({});

    	return {
    		c() {
    			div3 = element("div");
    			div2 = element("div");
    			div0 = element("div");

    			div0.innerHTML = `<h6 class="font-semibold text-primary-500 pb-4 flex items-center justify-center">A Budgeting &amp; Savings App</h6> 
      <h1 class="text-3xl sm:text-3xl md:text-4xl lg:text-5xl xl:text-6xl text-center text-gray-900 font-bold leading-7 md:leading-10">Save money and achieve your goal</h1> 
      <p class="mt-5 sm:mt-10 lg:w-10/12 text-gray-600 font-medium text-center text-sm sm:text-lg">Save money this summer for the more
        <span class="italic">meaningful</span>
        things.</p>`;

    			t7 = space();
    			div1 = element("div");
    			create_component(appstoredownloadbutton.$$.fragment);
    			t8 = space();
    			create_component(googleplaydownloadbutton.$$.fragment);
    			attr(div0, "class", "w-11/12 sm:w-2/3 lg:flex justify-center items-center flex-col mb-5 sm:mb-10");
    			attr(div1, "class", "flex justify-center items-center");
    			attr(div2, "class", "container mx-auto flex flex-col items-center py-12 sm:py-24");
    			attr(div3, "class", "hero-section");
    		},
    		m(target, anchor) {
    			insert(target, div3, anchor);
    			append(div3, div2);
    			append(div2, div0);
    			append(div2, t7);
    			append(div2, div1);
    			mount_component(appstoredownloadbutton, div1, null);
    			append(div1, t8);
    			mount_component(googleplaydownloadbutton, div1, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(appstoredownloadbutton.$$.fragment, local);
    			transition_in(googleplaydownloadbutton.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(appstoredownloadbutton.$$.fragment, local);
    			transition_out(googleplaydownloadbutton.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div3);
    			destroy_component(appstoredownloadbutton);
    			destroy_component(googleplaydownloadbutton);
    		}
    	};
    }

    class HeroSection extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$e, safe_not_equal, {});
    	}
    }

    /* src/lib/components/Navbar.svelte generated by Svelte v3.49.0 */

    function create_fragment$d(ctx) {
    	let div10;
    	let div0;
    	let a0;
    	let switch_instance;
    	let t0;
    	let div1;
    	let t3;
    	let nav0;
    	let t9;
    	let div2;
    	let t11;
    	let div9;
    	let div8;
    	let div7;
    	let div5;
    	let div3;
    	let logo;
    	let t12;
    	let div4;
    	let t15;
    	let div6;
    	let div9_class_value;
    	let current;
    	let mounted;
    	let dispose;
    	var switch_value = Logo;

    	function switch_props(ctx) {
    		return {};
    	}

    	if (switch_value) {
    		switch_instance = new switch_value(switch_props());
    	}

    	logo = new Logo({});

    	return {
    		c() {
    			div10 = element("div");
    			div0 = element("div");
    			a0 = element("a");
    			if (switch_instance) create_component(switch_instance.$$.fragment);
    			t0 = space();
    			div1 = element("div");

    			div1.innerHTML = `<button type="button" class="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500" aria-expanded="false"><span class="sr-only">Open menu</span> 
      
      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16"></path></svg></button>`;

    			t3 = space();
    			nav0 = element("nav");

    			nav0.innerHTML = `<a href="#/about" class="text-base font-semibold text-gray-900">About</a> 
    <a href="#/support" class="text-base font-semibold text-gray-900">Support</a> 
    <a href="#/privacypolicy" class="text-base font-semibold text-gray-900">Privacy Policy</a>`;

    			t9 = space();
    			div2 = element("div");
    			div2.innerHTML = `<a href="/" class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-6 py-2.5 border-transparent rounded-full text-base font-medium text-white bg-gradient-to-b from-primary-500 to-primary-600">Download</a>`;
    			t11 = space();
    			div9 = element("div");
    			div8 = element("div");
    			div7 = element("div");
    			div5 = element("div");
    			div3 = element("div");
    			create_component(logo.$$.fragment);
    			t12 = space();
    			div4 = element("div");

    			div4.innerHTML = `<button type="button" class="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"><span class="sr-only">Close menu</span> 
              
              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path></svg></button>`;

    			t15 = space();
    			div6 = element("div");

    			div6.innerHTML = `<nav class="grid gap-y-8"><a href="#/about" class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"><span class="ml-3 text-base font-medium text-gray-900">About</span></a> 

            <a href="/support" class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"><span class="ml-3 text-base font-medium text-gray-900">Support</span></a> 

            <a href="/privacypolicy" class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"><span class="ml-3 text-base font-medium text-gray-900">Privacy Policy</span></a></nav>`;

    			attr(a0, "href", "/");
    			attr(a0, "class", "cursor-pointer select-none");
    			attr(div0, "class", "flex justify-start lg:w-0 lg:flex-1");
    			attr(div1, "class", "-mr-2 -my-2 md:hidden");
    			attr(nav0, "class", "hidden md:flex space-x-10");
    			attr(div2, "class", "hidden md:flex items-center justify-end md:flex-1 lg:w-0");
    			attr(div4, "class", "-mr-2");
    			attr(div5, "class", "flex items-center justify-between");
    			attr(div6, "class", "mt-6");
    			attr(div7, "class", "pt-5 pb-6 px-5");
    			attr(div8, "class", "rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 bg-white divide-y-2 divide-gray-50");
    			attr(div9, "class", div9_class_value = "absolute top-0 inset-x-0 p-2 transition transform origin-top-right md:hidden bm-navbar " + (/*menuIsOpen*/ ctx[0] ? 'bm-open' : 'hidden') + " svelte-kf622r");
    			attr(div10, "class", "flex justify-between items-center py-4 md:justify-center md:space-x-10");
    		},
    		m(target, anchor) {
    			insert(target, div10, anchor);
    			append(div10, div0);
    			append(div0, a0);

    			if (switch_instance) {
    				mount_component(switch_instance, a0, null);
    			}

    			append(div10, t0);
    			append(div10, div1);
    			append(div10, t3);
    			append(div10, nav0);
    			append(div10, t9);
    			append(div10, div2);
    			append(div10, t11);
    			append(div10, div9);
    			append(div9, div8);
    			append(div8, div7);
    			append(div7, div5);
    			append(div5, div3);
    			mount_component(logo, div3, null);
    			append(div5, t12);
    			append(div5, div4);
    			append(div7, t15);
    			append(div7, div6);
    			current = true;

    			if (!mounted) {
    				dispose = [
    					listen(div1, "click", /*handleMenu*/ ctx[1]),
    					listen(div4, "click", /*handleMenu*/ ctx[1])
    				];

    				mounted = true;
    			}
    		},
    		p(ctx, [dirty]) {
    			if (switch_value !== (switch_value = Logo)) {
    				if (switch_instance) {
    					group_outros();
    					const old_component = switch_instance;

    					transition_out(old_component.$$.fragment, 1, 0, () => {
    						destroy_component(old_component, 1);
    					});

    					check_outros();
    				}

    				if (switch_value) {
    					switch_instance = new switch_value(switch_props());
    					create_component(switch_instance.$$.fragment);
    					transition_in(switch_instance.$$.fragment, 1);
    					mount_component(switch_instance, a0, null);
    				} else {
    					switch_instance = null;
    				}
    			}

    			if (!current || dirty & /*menuIsOpen*/ 1 && div9_class_value !== (div9_class_value = "absolute top-0 inset-x-0 p-2 transition transform origin-top-right md:hidden bm-navbar " + (/*menuIsOpen*/ ctx[0] ? 'bm-open' : 'hidden') + " svelte-kf622r")) {
    				attr(div9, "class", div9_class_value);
    			}
    		},
    		i(local) {
    			if (current) return;
    			if (switch_instance) transition_in(switch_instance.$$.fragment, local);
    			transition_in(logo.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			if (switch_instance) transition_out(switch_instance.$$.fragment, local);
    			transition_out(logo.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div10);
    			if (switch_instance) destroy_component(switch_instance);
    			destroy_component(logo);
    			mounted = false;
    			run_all(dispose);
    		}
    	};
    }

    function instance$4($$self, $$props, $$invalidate) {
    	let menuIsOpen = false;

    	function handleMenu() {
    		$$invalidate(0, menuIsOpen = !menuIsOpen);
    	}

    	return [menuIsOpen, handleMenu];
    }

    class Navbar extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, instance$4, create_fragment$d, safe_not_equal, {});
    	}
    }

    /* src/routes/Home.svelte generated by Svelte v3.49.0 */

    function create_fragment$c(ctx) {
    	let div2;
    	let div1;
    	let navbar;
    	let t0;
    	let herosection;
    	let t1;
    	let div0;
    	let t2;
    	let banner;
    	let t3;
    	let footer;
    	let current;
    	navbar = new Navbar({});
    	herosection = new HeroSection({});
    	banner = new Banner({});
    	footer = new Footer({});

    	return {
    		c() {
    			div2 = element("div");
    			div1 = element("div");
    			create_component(navbar.$$.fragment);
    			t0 = space();
    			create_component(herosection.$$.fragment);
    			t1 = space();
    			div0 = element("div");
    			div0.innerHTML = `<img src="../src/assets/images/mockup_home.png" alt="" width="650"/>`;
    			t2 = space();
    			create_component(banner.$$.fragment);
    			t3 = space();
    			create_component(footer.$$.fragment);
    			attr(div0, "class", "py-14 flex items-center justify-center");
    			attr(div1, "class", "max-w-7xl mx-auto px-4 sm:px-6 justify-center");
    			attr(div2, "class", "relative bg-gradient-to-b from-white to-gray-200");
    		},
    		m(target, anchor) {
    			insert(target, div2, anchor);
    			append(div2, div1);
    			mount_component(navbar, div1, null);
    			append(div1, t0);
    			mount_component(herosection, div1, null);
    			append(div1, t1);
    			append(div1, div0);
    			append(div1, t2);
    			mount_component(banner, div1, null);
    			append(div1, t3);
    			mount_component(footer, div1, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(navbar.$$.fragment, local);
    			transition_in(herosection.$$.fragment, local);
    			transition_in(banner.$$.fragment, local);
    			transition_in(footer.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(navbar.$$.fragment, local);
    			transition_out(herosection.$$.fragment, local);
    			transition_out(banner.$$.fragment, local);
    			transition_out(footer.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div2);
    			destroy_component(navbar);
    			destroy_component(herosection);
    			destroy_component(banner);
    			destroy_component(footer);
    		}
    	};
    }

    class Home extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$c, safe_not_equal, {});
    	}
    }

    /* src/lib/components/AboutPage/AboutMockupSection.svelte generated by Svelte v3.49.0 */

    function create_fragment$b(ctx) {
    	let div1;
    	let img;
    	let img_src_value;
    	let t0;
    	let div0;
    	let h3;
    	let t1;
    	let h3_class_value;
    	let t2;
    	let h6;
    	let t3;
    	let h6_class_value;
    	let div1_class_value;

    	return {
    		c() {
    			div1 = element("div");
    			img = element("img");
    			t0 = space();
    			div0 = element("div");
    			h3 = element("h3");
    			t1 = text(/*title*/ ctx[0]);
    			t2 = space();
    			h6 = element("h6");
    			t3 = text(/*content*/ ctx[1]);
    			if (!src_url_equal(img.src, img_src_value = /*mockupImage*/ ctx[2])) attr(img, "src", img_src_value);
    			attr(img, "alt", "");
    			attr(img, "width", "180");
    			attr(h3, "class", h3_class_value = "font-semibold text-2xl " + (/*alignmentRight*/ ctx[3] ? 'text-right' : 'text-left') + " mx-8");
    			attr(h6, "class", h6_class_value = "font-normal text-2xl " + (/*alignmentRight*/ ctx[3] ? 'text-right' : 'text-left') + " mx-8");
    			attr(div0, "class", "flex-col w-[22rem] ");
    			attr(div1, "class", div1_class_value = "flex py-24 items-center justify-center " + (/*alignmentRight*/ ctx[3] ? '' : 'flex-row-reverse'));
    		},
    		m(target, anchor) {
    			insert(target, div1, anchor);
    			append(div1, img);
    			append(div1, t0);
    			append(div1, div0);
    			append(div0, h3);
    			append(h3, t1);
    			append(div0, t2);
    			append(div0, h6);
    			append(h6, t3);
    		},
    		p(ctx, [dirty]) {
    			if (dirty & /*mockupImage*/ 4 && !src_url_equal(img.src, img_src_value = /*mockupImage*/ ctx[2])) {
    				attr(img, "src", img_src_value);
    			}

    			if (dirty & /*title*/ 1) set_data(t1, /*title*/ ctx[0]);

    			if (dirty & /*alignmentRight*/ 8 && h3_class_value !== (h3_class_value = "font-semibold text-2xl " + (/*alignmentRight*/ ctx[3] ? 'text-right' : 'text-left') + " mx-8")) {
    				attr(h3, "class", h3_class_value);
    			}

    			if (dirty & /*content*/ 2) set_data(t3, /*content*/ ctx[1]);

    			if (dirty & /*alignmentRight*/ 8 && h6_class_value !== (h6_class_value = "font-normal text-2xl " + (/*alignmentRight*/ ctx[3] ? 'text-right' : 'text-left') + " mx-8")) {
    				attr(h6, "class", h6_class_value);
    			}

    			if (dirty & /*alignmentRight*/ 8 && div1_class_value !== (div1_class_value = "flex py-24 items-center justify-center " + (/*alignmentRight*/ ctx[3] ? '' : 'flex-row-reverse'))) {
    				attr(div1, "class", div1_class_value);
    			}
    		},
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(div1);
    		}
    	};
    }

    function instance$3($$self, $$props, $$invalidate) {
    	let { title } = $$props;
    	let { content } = $$props;
    	let { mockupImage } = $$props;
    	let { alignmentRight } = $$props;

    	$$self.$$set = $$props => {
    		if ('title' in $$props) $$invalidate(0, title = $$props.title);
    		if ('content' in $$props) $$invalidate(1, content = $$props.content);
    		if ('mockupImage' in $$props) $$invalidate(2, mockupImage = $$props.mockupImage);
    		if ('alignmentRight' in $$props) $$invalidate(3, alignmentRight = $$props.alignmentRight);
    	};

    	return [title, content, mockupImage, alignmentRight];
    }

    class AboutMockupSection extends SvelteComponent {
    	constructor(options) {
    		super();

    		init(this, options, instance$3, create_fragment$b, safe_not_equal, {
    			title: 0,
    			content: 1,
    			mockupImage: 2,
    			alignmentRight: 3
    		});
    	}
    }

    /* src/lib/components/SecondaryLogo.svelte generated by Svelte v3.49.0 */

    function create_fragment$a(ctx) {
    	let div;

    	return {
    		c() {
    			div = element("div");
    			div.innerHTML = `<img src="../src/assets/images/store_icon_a.png" alt="" width="120" height="auto"/>`;
    		},
    		m(target, anchor) {
    			insert(target, div, anchor);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(div);
    		}
    	};
    }

    class SecondaryLogo extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$a, safe_not_equal, {});
    	}
    }

    /* src/lib/components/Header.svelte generated by Svelte v3.49.0 */

    function create_fragment$9(ctx) {
    	let div1;
    	let div0;
    	let secondarylogo;
    	let t0;
    	let h1;
    	let t1;
    	let current;
    	secondarylogo = new SecondaryLogo({});

    	return {
    		c() {
    			div1 = element("div");
    			div0 = element("div");
    			create_component(secondarylogo.$$.fragment);
    			t0 = space();
    			h1 = element("h1");
    			t1 = text(/*text*/ ctx[0]);
    			attr(h1, "class", "text-3xl sm:text-3xl md:text-4xl xl:text-5xl py-6 text-start text-gray-900 font-bold leading-7 md:leading-10");
    			attr(div0, "class", "flex-col items-center justify-center py-12");
    			attr(div1, "class", "flex items-center justify-center");
    		},
    		m(target, anchor) {
    			insert(target, div1, anchor);
    			append(div1, div0);
    			mount_component(secondarylogo, div0, null);
    			append(div0, t0);
    			append(div0, h1);
    			append(h1, t1);
    			current = true;
    		},
    		p(ctx, [dirty]) {
    			if (!current || dirty & /*text*/ 1) set_data(t1, /*text*/ ctx[0]);
    		},
    		i(local) {
    			if (current) return;
    			transition_in(secondarylogo.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(secondarylogo.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div1);
    			destroy_component(secondarylogo);
    		}
    	};
    }

    function instance$2($$self, $$props, $$invalidate) {
    	let { text } = $$props;

    	$$self.$$set = $$props => {
    		if ('text' in $$props) $$invalidate(0, text = $$props.text);
    	};

    	return [text];
    }

    class Header extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, instance$2, create_fragment$9, safe_not_equal, { text: 0 });
    	}
    }

    /* src/routes/About.svelte generated by Svelte v3.49.0 */

    function create_fragment$8(ctx) {
    	let div1;
    	let div0;
    	let navbar;
    	let t0;
    	let header;
    	let t1;
    	let aboutmockupsection0;
    	let t2;
    	let aboutmockupsection1;
    	let t3;
    	let aboutmockupsection2;
    	let t4;
    	let aboutmockupsection3;
    	let t5;
    	let footer;
    	let current;
    	navbar = new Navbar({});
    	header = new Header({ props: { text: "Welcome to BudgetMe" } });

    	aboutmockupsection0 = new AboutMockupSection({
    			props: {
    				title: "Intuitive & Simple",
    				content: "Create Goals in a simple and easy manner. No unnecessary features.",
    				mockupImage: "../src/assets/images/mockup_about_1.png",
    				alignmentRight: true
    			}
    		});

    	aboutmockupsection1 = new AboutMockupSection({
    			props: {
    				title: "Modern User Interface",
    				content: "A 21st century feeling interface that makes the app more visually appealing and fun to use.",
    				mockupImage: "../src/assets/images/mockup_about_2.png",
    				alignmentRight: false
    			}
    		});

    	aboutmockupsection2 = new AboutMockupSection({
    			props: {
    				title: "Informative",
    				content: "View transaction history to keep track of spending and saving habits.",
    				mockupImage: "../src/assets/images/mockup_about_3.png",
    				alignmentRight: true
    			}
    		});

    	aboutmockupsection3 = new AboutMockupSection({
    			props: {
    				title: "Available in 12 languages and all currencies",
    				content: "No matter where you’re saving from, you can feel right at home with your native currency.",
    				mockupImage: "../src/assets/images/mockup_about_4.png",
    				alignmentRight: false
    			}
    		});

    	footer = new Footer({});

    	return {
    		c() {
    			div1 = element("div");
    			div0 = element("div");
    			create_component(navbar.$$.fragment);
    			t0 = space();
    			create_component(header.$$.fragment);
    			t1 = space();
    			create_component(aboutmockupsection0.$$.fragment);
    			t2 = space();
    			create_component(aboutmockupsection1.$$.fragment);
    			t3 = space();
    			create_component(aboutmockupsection2.$$.fragment);
    			t4 = space();
    			create_component(aboutmockupsection3.$$.fragment);
    			t5 = space();
    			create_component(footer.$$.fragment);
    			attr(div0, "class", "max-w-7xl mx-auto px-4 sm:px-6");
    			attr(div1, "class", "relative bg-white");
    		},
    		m(target, anchor) {
    			insert(target, div1, anchor);
    			append(div1, div0);
    			mount_component(navbar, div0, null);
    			append(div0, t0);
    			mount_component(header, div0, null);
    			append(div0, t1);
    			mount_component(aboutmockupsection0, div0, null);
    			append(div0, t2);
    			mount_component(aboutmockupsection1, div0, null);
    			append(div0, t3);
    			mount_component(aboutmockupsection2, div0, null);
    			append(div0, t4);
    			mount_component(aboutmockupsection3, div0, null);
    			append(div0, t5);
    			mount_component(footer, div0, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(navbar.$$.fragment, local);
    			transition_in(header.$$.fragment, local);
    			transition_in(aboutmockupsection0.$$.fragment, local);
    			transition_in(aboutmockupsection1.$$.fragment, local);
    			transition_in(aboutmockupsection2.$$.fragment, local);
    			transition_in(aboutmockupsection3.$$.fragment, local);
    			transition_in(footer.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(navbar.$$.fragment, local);
    			transition_out(header.$$.fragment, local);
    			transition_out(aboutmockupsection0.$$.fragment, local);
    			transition_out(aboutmockupsection1.$$.fragment, local);
    			transition_out(aboutmockupsection2.$$.fragment, local);
    			transition_out(aboutmockupsection3.$$.fragment, local);
    			transition_out(footer.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div1);
    			destroy_component(navbar);
    			destroy_component(header);
    			destroy_component(aboutmockupsection0);
    			destroy_component(aboutmockupsection1);
    			destroy_component(aboutmockupsection2);
    			destroy_component(aboutmockupsection3);
    			destroy_component(footer);
    		}
    	};
    }

    class About extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$8, safe_not_equal, {});
    	}
    }

    /* src/lib/components/SupportPage/EmailCard.svelte generated by Svelte v3.49.0 */

    function create_fragment$7(ctx) {
    	let a1;
    	let div;
    	let a0;
    	let svg;
    	let path0;
    	let path1;
    	let t0;
    	let p0;
    	let t2;
    	let p1;

    	return {
    		c() {
    			a1 = element("a");
    			div = element("div");
    			a0 = element("a");
    			svg = svg_element("svg");
    			path0 = svg_element("path");
    			path1 = svg_element("path");
    			t0 = space();
    			p0 = element("p");
    			p0.textContent = `${platform$3}`;
    			t2 = space();
    			p1 = element("p");
    			p1.textContent = `${tag$3}`;
    			attr(path0, "d", "M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z");
    			attr(path1, "d", "M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z");
    			attr(svg, "xmlns", "http://www.w3.org/2000/svg");
    			attr(svg, "class", "h-5 w-5");
    			attr(svg, "viewBox", "0 0 20 20");
    			attr(svg, "fill", "currentColor");
    			attr(a0, "href", link$3);
    			attr(a0, "target", "_blank");
    			attr(a0, "class", "p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-red-600 group-hover:text-gray-100");
    			attr(p0, "class", "group-hover:text-gray-100");
    			attr(div, "class", "flex items-center justify-center");
    			attr(p1, "class", "group-hover:text-gray-100");
    			attr(a1, "href", link$3);
    			attr(a1, "target", "_blank");
    			attr(a1, "class", "group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-red-500 lg:max-w-full lg:flex");
    		},
    		m(target, anchor) {
    			insert(target, a1, anchor);
    			append(a1, div);
    			append(div, a0);
    			append(a0, svg);
    			append(svg, path0);
    			append(svg, path1);
    			append(div, t0);
    			append(div, p0);
    			append(a1, t2);
    			append(a1, p1);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a1);
    		}
    	};
    }

    let link$3 = 'mailto:carltonaikins7@gmail.com';
    let platform$3 = 'Email';
    let tag$3 = 'carltonaikins7@gmail.com';

    class EmailCard extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$7, safe_not_equal, {});
    	}
    }

    /* src/lib/components/SupportPage/InstagramCard.svelte generated by Svelte v3.49.0 */

    function create_fragment$6(ctx) {
    	let a1;
    	let div;
    	let a0;
    	let svg;
    	let path;
    	let t0;
    	let p0;
    	let t2;
    	let p1;

    	return {
    		c() {
    			a1 = element("a");
    			div = element("div");
    			a0 = element("a");
    			svg = svg_element("svg");
    			path = svg_element("path");
    			t0 = space();
    			p0 = element("p");
    			p0.textContent = `${platform$2}`;
    			t2 = space();
    			p1 = element("p");
    			p1.textContent = `${tag$2}`;
    			attr(path, "fill-rule", "evenodd");
    			attr(path, "clip-rule", "evenodd");
    			attr(path, "d", instagramSvgPath);
    			attr(svg, "xmlns", "http://www.w3.org/2000/svg");
    			attr(svg, "class", "w-5 h-5");
    			attr(svg, "fill", "currentColor");
    			attr(svg, "viewBox", "0 0 24 24");
    			attr(a0, "href", link$2);
    			attr(a0, "target", "_blank");
    			attr(a0, "class", "p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-purple-600 group-hover:text-gray-100");
    			attr(p0, "class", "group-hover:text-gray-100");
    			attr(div, "class", "flex items-center justify-center");
    			attr(p1, "class", "group-hover:text-gray-100");
    			attr(a1, "href", link$2);
    			attr(a1, "target", "_blank");
    			attr(a1, "class", "group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-purple-500 lg:max-w-full lg:flex");
    		},
    		m(target, anchor) {
    			insert(target, a1, anchor);
    			append(a1, div);
    			append(div, a0);
    			append(a0, svg);
    			append(svg, path);
    			append(div, t0);
    			append(div, p0);
    			append(a1, t2);
    			append(a1, p1);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a1);
    		}
    	};
    }

    const instagramSvgPath = 'M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z';
    let link$2 = 'https://www.instagram.com/31carlton7/';
    let platform$2 = 'Instagram';
    let tag$2 = '@31Carlton7';

    class InstagramCard extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$6, safe_not_equal, {});
    	}
    }

    /* src/lib/components/SupportPage/LinkedInCard.svelte generated by Svelte v3.49.0 */

    function create_fragment$5(ctx) {
    	let a1;
    	let div;
    	let a0;
    	let svg;
    	let path;
    	let t0;
    	let p0;
    	let t2;
    	let p1;

    	return {
    		c() {
    			a1 = element("a");
    			div = element("div");
    			a0 = element("a");
    			svg = svg_element("svg");
    			path = svg_element("path");
    			t0 = space();
    			p0 = element("p");
    			p0.textContent = `${platform$1}`;
    			t2 = space();
    			p1 = element("p");
    			p1.textContent = `${tag$1}`;
    			attr(path, "fill-rule", "evenodd");
    			attr(path, "clip-rule", "evenodd");
    			attr(path, "d", linkedInSvgPath);
    			attr(svg, "xmlns", "http://www.w3.org/2000/svg");
    			attr(svg, "class", "w-5 h-5");
    			attr(svg, "fill", "currentColor");
    			attr(svg, "viewBox", "0 0 24 24");
    			attr(a0, "href", link$1);
    			attr(a0, "target", "_blank");
    			attr(a0, "class", "p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-linkedin-200 group-hover:text-gray-100");
    			attr(p0, "class", "group-hover:text-gray-100");
    			attr(div, "class", "flex items-center justify-center");
    			attr(p1, "class", "group-hover:text-gray-100");
    			attr(a1, "href", link$1);
    			attr(a1, "target", "_blank");
    			attr(a1, "class", "group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-linkedin-100 lg:max-w-full lg:flex");
    		},
    		m(target, anchor) {
    			insert(target, a1, anchor);
    			append(a1, div);
    			append(div, a0);
    			append(a0, svg);
    			append(svg, path);
    			append(div, t0);
    			append(div, p0);
    			append(a1, t2);
    			append(a1, p1);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a1);
    		}
    	};
    }

    const linkedInSvgPath = 'M5.26433 21.3846H0.95842V7.51803H5.26433V21.3846ZM3.10906 5.62651C1.73217 5.62651 0.615356 4.48603 0.615356 3.10911C0.615356 2.44773 0.878085 1.81343 1.34574 1.34576C1.8134 0.878091 2.44769 0.615356 3.10906 0.615356C3.77042 0.615356 4.40471 0.878091 4.87237 1.34576C5.34003 1.81343 5.60275 2.44773 5.60275 3.10911C5.60275 4.48603 4.48548 5.62651 3.10906 5.62651ZM21.38 21.3846H17.0833V14.6344C17.0833 13.0257 17.0509 10.9627 14.8446 10.9627C12.6059 10.9627 12.2628 12.7105 12.2628 14.5185V21.3846H7.96154V7.51803H12.0913V9.40956H12.1516C12.7264 8.32008 14.1307 7.17033 16.2257 7.17033C20.5835 7.17033 21.3846 10.0401 21.3846 13.7675V21.3846H21.38Z';
    let link$1 = 'https://www.linkedin.com/in/carlton-aikins-a34a14226/';
    let platform$1 = 'LinkedIn';
    let tag$1 = '@Carlton Aikins';

    class LinkedInCard extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$5, safe_not_equal, {});
    	}
    }

    /* src/lib/components/SupportPage/TwitterCard.svelte generated by Svelte v3.49.0 */

    function create_fragment$4(ctx) {
    	let a1;
    	let div;
    	let a0;
    	let svg;
    	let path;
    	let t0;
    	let p0;
    	let t2;
    	let p1;

    	return {
    		c() {
    			a1 = element("a");
    			div = element("div");
    			a0 = element("a");
    			svg = svg_element("svg");
    			path = svg_element("path");
    			t0 = space();
    			p0 = element("p");
    			p0.textContent = `${platform}`;
    			t2 = space();
    			p1 = element("p");
    			p1.textContent = `${tag}`;
    			attr(path, "fill-rule", "evenodd");
    			attr(path, "clip-rule", "evenodd");
    			attr(path, "d", twitterSvgPath);
    			attr(svg, "xmlns", "http://www.w3.org/2000/svg");
    			attr(svg, "class", "w-5 h-5");
    			attr(svg, "fill", "currentColor");
    			attr(svg, "viewBox", "0 0 24 24");
    			attr(a0, "href", link);
    			attr(a0, "target", "_blank");
    			attr(a0, "class", "p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-twitter-200 group-hover:text-gray-100");
    			attr(p0, "class", "group-hover:text-gray-100");
    			attr(div, "class", "flex items-center justify-center");
    			attr(p1, "class", "group-hover:text-gray-100");
    			attr(a1, "href", link);
    			attr(a1, "target", "_blank");
    			attr(a1, "class", "group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-twitter-100 lg:max-w-full lg:flex");
    		},
    		m(target, anchor) {
    			insert(target, a1, anchor);
    			append(a1, div);
    			append(div, a0);
    			append(a0, svg);
    			append(svg, path);
    			append(div, t0);
    			append(div, p0);
    			append(a1, t2);
    			append(a1, p1);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(a1);
    		}
    	};
    }

    const twitterSvgPath = 'M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84';
    let link = 'https://www.twitter.com/31carlton7';
    let platform = 'Twitter';
    let tag = '@31Carlton7';

    class TwitterCard extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$4, safe_not_equal, {});
    	}
    }

    /* src/routes/Support.svelte generated by Svelte v3.49.0 */

    function create_fragment$3(ctx) {
    	let div3;
    	let div2;
    	let navbar;
    	let t0;
    	let header;
    	let t1;
    	let div1;
    	let div0;
    	let h2;
    	let t3;
    	let emailcard;
    	let t4;
    	let linkedincard;
    	let t5;
    	let twittercard;
    	let t6;
    	let instagramcard;
    	let t7;
    	let footer;
    	let current;
    	navbar = new Navbar({});
    	header = new Header({ props: { text: "BudgetMe Support" } });
    	emailcard = new EmailCard({});
    	linkedincard = new LinkedInCard({});
    	twittercard = new TwitterCard({});
    	instagramcard = new InstagramCard({});
    	footer = new Footer({});

    	return {
    		c() {
    			div3 = element("div");
    			div2 = element("div");
    			create_component(navbar.$$.fragment);
    			t0 = space();
    			create_component(header.$$.fragment);
    			t1 = space();
    			div1 = element("div");
    			div0 = element("div");
    			h2 = element("h2");
    			h2.textContent = "If you would to contact us, you can do so via the following links.";
    			t3 = space();
    			create_component(emailcard.$$.fragment);
    			t4 = space();
    			create_component(linkedincard.$$.fragment);
    			t5 = space();
    			create_component(twittercard.$$.fragment);
    			t6 = space();
    			create_component(instagramcard.$$.fragment);
    			t7 = space();
    			create_component(footer.$$.fragment);
    			attr(h2, "class", "text-2xl");
    			attr(div0, "class", "flex-col items-center justify-center mb-16");
    			attr(div1, "class", "flex items-center justify-center");
    			attr(div2, "class", "max-w-7xl mx-auto px-4 sm:px-6");
    			attr(div3, "class", "relative bg-white");
    		},
    		m(target, anchor) {
    			insert(target, div3, anchor);
    			append(div3, div2);
    			mount_component(navbar, div2, null);
    			append(div2, t0);
    			mount_component(header, div2, null);
    			append(div2, t1);
    			append(div2, div1);
    			append(div1, div0);
    			append(div0, h2);
    			append(div0, t3);
    			mount_component(emailcard, div0, null);
    			append(div0, t4);
    			mount_component(linkedincard, div0, null);
    			append(div0, t5);
    			mount_component(twittercard, div0, null);
    			append(div0, t6);
    			mount_component(instagramcard, div0, null);
    			append(div2, t7);
    			mount_component(footer, div2, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(navbar.$$.fragment, local);
    			transition_in(header.$$.fragment, local);
    			transition_in(emailcard.$$.fragment, local);
    			transition_in(linkedincard.$$.fragment, local);
    			transition_in(twittercard.$$.fragment, local);
    			transition_in(instagramcard.$$.fragment, local);
    			transition_in(footer.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(navbar.$$.fragment, local);
    			transition_out(header.$$.fragment, local);
    			transition_out(emailcard.$$.fragment, local);
    			transition_out(linkedincard.$$.fragment, local);
    			transition_out(twittercard.$$.fragment, local);
    			transition_out(instagramcard.$$.fragment, local);
    			transition_out(footer.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div3);
    			destroy_component(navbar);
    			destroy_component(header);
    			destroy_component(emailcard);
    			destroy_component(linkedincard);
    			destroy_component(twittercard);
    			destroy_component(instagramcard);
    			destroy_component(footer);
    		}
    	};
    }

    class Support extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$3, safe_not_equal, {});
    	}
    }

    /* src/lib/components/PrivacyPolicyPage/PrivacyPolicySection.svelte generated by Svelte v3.49.0 */

    function get_each_context(ctx, list, i) {
    	const child_ctx = ctx.slice();
    	child_ctx[2] = list[i];
    	child_ctx[4] = i;
    	return child_ctx;
    }

    // (21:6) {:else}
    function create_else_block(ctx) {
    	let h6;
    	let t0_value = /*element*/ ctx[2] + "";
    	let t0;
    	let t1;
    	let br0;
    	let t2;
    	let br1;

    	return {
    		c() {
    			h6 = element("h6");
    			t0 = text(t0_value);
    			t1 = space();
    			br0 = element("br");
    			t2 = space();
    			br1 = element("br");
    			attr(h6, "class", "svelte-1sdwahn");
    		},
    		m(target, anchor) {
    			insert(target, h6, anchor);
    			append(h6, t0);
    			append(h6, t1);
    			append(h6, br0);
    			append(h6, t2);
    			append(h6, br1);
    		},
    		p(ctx, dirty) {
    			if (dirty & /*content*/ 2 && t0_value !== (t0_value = /*element*/ ctx[2] + "")) set_data(t0, t0_value);
    		},
    		d(detaching) {
    			if (detaching) detach(h6);
    		}
    	};
    }

    // (19:39) 
    function create_if_block_2(ctx) {
    	let h6;
    	let t0_value = /*element*/ ctx[2] + "";
    	let t0;
    	let t1;
    	let br0;
    	let t2;
    	let br1;

    	return {
    		c() {
    			h6 = element("h6");
    			t0 = text(t0_value);
    			t1 = space();
    			br0 = element("br");
    			t2 = space();
    			br1 = element("br");
    			attr(h6, "class", "bld svelte-1sdwahn");
    		},
    		m(target, anchor) {
    			insert(target, h6, anchor);
    			append(h6, t0);
    			append(h6, t1);
    			append(h6, br0);
    			append(h6, t2);
    			append(h6, br1);
    		},
    		p(ctx, dirty) {
    			if (dirty & /*content*/ 2 && t0_value !== (t0_value = /*element*/ ctx[2] + "")) set_data(t0, t0_value);
    		},
    		d(detaching) {
    			if (detaching) detach(h6);
    		}
    	};
    }

    // (16:39) 
    function create_if_block_1(ctx) {
    	let br0;
    	let t0;
    	let h6;
    	let t1_value = /*element*/ ctx[2] + "";
    	let t1;
    	let t2;
    	let br1;
    	let t3;
    	let br2;

    	return {
    		c() {
    			br0 = element("br");
    			t0 = space();
    			h6 = element("h6");
    			t1 = text(t1_value);
    			t2 = space();
    			br1 = element("br");
    			t3 = space();
    			br2 = element("br");
    			attr(h6, "class", "svelte-1sdwahn");
    		},
    		m(target, anchor) {
    			insert(target, br0, anchor);
    			insert(target, t0, anchor);
    			insert(target, h6, anchor);
    			append(h6, t1);
    			append(h6, t2);
    			append(h6, br1);
    			append(h6, t3);
    			append(h6, br2);
    		},
    		p(ctx, dirty) {
    			if (dirty & /*content*/ 2 && t1_value !== (t1_value = /*element*/ ctx[2] + "")) set_data(t1, t1_value);
    		},
    		d(detaching) {
    			if (detaching) detach(br0);
    			if (detaching) detach(t0);
    			if (detaching) detach(h6);
    		}
    	};
    }

    // (12:6) {#if element.includes('\n')}
    function create_if_block(ctx) {
    	let span;
    	let h6;
    	let t0_value = /*element*/ ctx[2] + "";
    	let t0;
    	let t1;
    	let br;
    	let t2;

    	return {
    		c() {
    			span = element("span");
    			h6 = element("h6");
    			t0 = text(t0_value);
    			t1 = space();
    			br = element("br");
    			t2 = space();
    			attr(h6, "class", "svelte-1sdwahn");
    		},
    		m(target, anchor) {
    			insert(target, span, anchor);
    			append(span, h6);
    			append(h6, t0);
    			append(h6, t1);
    			append(h6, br);
    			append(span, t2);
    		},
    		p(ctx, dirty) {
    			if (dirty & /*content*/ 2 && t0_value !== (t0_value = /*element*/ ctx[2] + "")) set_data(t0, t0_value);
    		},
    		d(detaching) {
    			if (detaching) detach(span);
    		}
    	};
    }

    // (11:4) {#each content as element, i}
    function create_each_block(ctx) {
    	let show_if;
    	let show_if_1;
    	let show_if_2;
    	let if_block_anchor;

    	function select_block_type(ctx, dirty) {
    		if (dirty & /*content*/ 2) show_if = null;
    		if (dirty & /*content*/ 2) show_if_1 = null;
    		if (dirty & /*content*/ 2) show_if_2 = null;
    		if (show_if == null) show_if = !!/*element*/ ctx[2].includes('\n');
    		if (show_if) return create_if_block;
    		if (show_if_1 == null) show_if_1 = !!/*element*/ ctx[2].includes('\t');
    		if (show_if_1) return create_if_block_1;
    		if (show_if_2 == null) show_if_2 = !!/*element*/ ctx[2].includes('\b');
    		if (show_if_2) return create_if_block_2;
    		return create_else_block;
    	}

    	let current_block_type = select_block_type(ctx, -1);
    	let if_block = current_block_type(ctx);

    	return {
    		c() {
    			if_block.c();
    			if_block_anchor = empty();
    		},
    		m(target, anchor) {
    			if_block.m(target, anchor);
    			insert(target, if_block_anchor, anchor);
    		},
    		p(ctx, dirty) {
    			if (current_block_type === (current_block_type = select_block_type(ctx, dirty)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(if_block_anchor.parentNode, if_block_anchor);
    				}
    			}
    		},
    		d(detaching) {
    			if_block.d(detaching);
    			if (detaching) detach(if_block_anchor);
    		}
    	};
    }

    function create_fragment$2(ctx) {
    	let div1;
    	let div0;
    	let h3;
    	let t0;
    	let t1;
    	let each_value = /*content*/ ctx[1];
    	let each_blocks = [];

    	for (let i = 0; i < each_value.length; i += 1) {
    		each_blocks[i] = create_each_block(get_each_context(ctx, each_value, i));
    	}

    	return {
    		c() {
    			div1 = element("div");
    			div0 = element("div");
    			h3 = element("h3");
    			t0 = text(/*title*/ ctx[0]);
    			t1 = space();

    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].c();
    			}

    			attr(h3, "class", "font-semibold text-2xl py-4");
    			attr(div0, "class", "flex-col lg:mx-36 md:mx-20 sm:mx-18");
    			attr(div1, "class", "py-4");
    		},
    		m(target, anchor) {
    			insert(target, div1, anchor);
    			append(div1, div0);
    			append(div0, h3);
    			append(h3, t0);
    			append(div0, t1);

    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].m(div0, null);
    			}
    		},
    		p(ctx, [dirty]) {
    			if (dirty & /*title*/ 1) set_data(t0, /*title*/ ctx[0]);

    			if (dirty & /*content*/ 2) {
    				each_value = /*content*/ ctx[1];
    				let i;

    				for (i = 0; i < each_value.length; i += 1) {
    					const child_ctx = get_each_context(ctx, each_value, i);

    					if (each_blocks[i]) {
    						each_blocks[i].p(child_ctx, dirty);
    					} else {
    						each_blocks[i] = create_each_block(child_ctx);
    						each_blocks[i].c();
    						each_blocks[i].m(div0, null);
    					}
    				}

    				for (; i < each_blocks.length; i += 1) {
    					each_blocks[i].d(1);
    				}

    				each_blocks.length = each_value.length;
    			}
    		},
    		i: noop,
    		o: noop,
    		d(detaching) {
    			if (detaching) detach(div1);
    			destroy_each(each_blocks, detaching);
    		}
    	};
    }

    function instance$1($$self, $$props, $$invalidate) {
    	let { title } = $$props;
    	let { content } = $$props;

    	$$self.$$set = $$props => {
    		if ('title' in $$props) $$invalidate(0, title = $$props.title);
    		if ('content' in $$props) $$invalidate(1, content = $$props.content);
    	};

    	return [title, content];
    }

    class PrivacyPolicySection extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, instance$1, create_fragment$2, safe_not_equal, { title: 0, content: 1 });
    	}
    }

    /* src/routes/PrivacyPolicy.svelte generated by Svelte v3.49.0 */

    function create_fragment$1(ctx) {
    	let div1;
    	let div0;
    	let navbar;
    	let t0;
    	let header;
    	let t1;
    	let privacypolicysection0;
    	let t2;
    	let privacypolicysection1;
    	let t3;
    	let privacypolicysection2;
    	let t4;
    	let privacypolicysection3;
    	let t5;
    	let privacypolicysection4;
    	let t6;
    	let privacypolicysection5;
    	let t7;
    	let privacypolicysection6;
    	let t8;
    	let privacypolicysection7;
    	let t9;
    	let privacypolicysection8;
    	let t10;
    	let privacypolicysection9;
    	let t11;
    	let privacypolicysection10;
    	let t12;
    	let footer;
    	let current;
    	navbar = new Navbar({});

    	header = new Header({
    			props: { text: "BudgetMe Privacy Policy" }
    		});

    	privacypolicysection0 = new PrivacyPolicySection({
    			props: {
    				title: "Privacy Policy",
    				content: [
    					'Carlton Aikins built the BudgetMe app as an Ad Supported app. This SERVICE is provided by Carlton Aikins at no cost and is intended for use as is.',
    					'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.',
    					'If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.',
    					'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at BudgetMe unless otherwise defined in this Privacy Policy.'
    				]
    			}
    		});

    	privacypolicysection1 = new PrivacyPolicySection({
    			props: {
    				title: "Information Collection and Use",
    				content: [
    					'For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Carlton Aikins. The information that I request will be retained on your device and is not collected by me in any way.',
    					'The app does use third-party services that may collect information used to identify you.',
    					'Link to the privacy policy of third-party service providers used by the app',
    					'Google Play Services \n',
    					'AdMob \n',
    					'Google Analytics for Firebase \n',
    					'Firebase Crashlytics \n',
    					'Log Data \n',
    					'I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics. \t'
    				]
    			}
    		});

    	privacypolicysection2 = new PrivacyPolicySection({
    			props: {
    				title: "Cookies",
    				content: [
    					"Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.",
    					'This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.'
    				]
    			}
    		});

    	privacypolicysection3 = new PrivacyPolicySection({
    			props: {
    				title: "Service Providers",
    				content: [
    					'I may employ third-party companies and individuals due to the following reasons:',
    					'To provide the Service on our behalf; \n',
    					'To perform Service-related services; or \n',
    					'To assist us in analyzing how our Service is used.',
    					'I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'
    				]
    			}
    		});

    	privacypolicysection4 = new PrivacyPolicySection({
    			props: {
    				title: "Privacy Policy",
    				content: [
    					'Carlton Aikins built the BudgetMe app as an Ad Supported app. This SERVICE is provided by Carlton Aikins at no cost and is intended for use as is.',
    					'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.',
    					'If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.',
    					'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at BudgetMe unless otherwise defined in this Privacy Policy.'
    				]
    			}
    		});

    	privacypolicysection5 = new PrivacyPolicySection({
    			props: {
    				title: "Privacy Policy",
    				content: [
    					'Carlton Aikins built the BudgetMe app as an Ad Supported app. This SERVICE is provided by Carlton Aikins at no cost and is intended for use as is.',
    					'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.',
    					'If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.',
    					'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at BudgetMe unless otherwise defined in this Privacy Policy.'
    				]
    			}
    		});

    	privacypolicysection6 = new PrivacyPolicySection({
    			props: {
    				title: "Security",
    				content: [
    					'I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.'
    				]
    			}
    		});

    	privacypolicysection7 = new PrivacyPolicySection({
    			props: {
    				title: "Links to Other Sites",
    				content: [
    					'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'
    				]
    			}
    		});

    	privacypolicysection8 = new PrivacyPolicySection({
    			props: {
    				title: "Children's Privacy",
    				content: [
    					'These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.'
    				]
    			}
    		});

    	privacypolicysection9 = new PrivacyPolicySection({
    			props: {
    				title: "Changes to This Privacy Policy",
    				content: [
    					'I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.',
    					'This policy is effective as of 2022-07-03 \b'
    				]
    			}
    		});

    	privacypolicysection10 = new PrivacyPolicySection({
    			props: {
    				title: "Contact Us",
    				content: [
    					'If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at carltonaikins7@gmail.com.'
    				]
    			}
    		});

    	footer = new Footer({});

    	return {
    		c() {
    			div1 = element("div");
    			div0 = element("div");
    			create_component(navbar.$$.fragment);
    			t0 = space();
    			create_component(header.$$.fragment);
    			t1 = space();
    			create_component(privacypolicysection0.$$.fragment);
    			t2 = space();
    			create_component(privacypolicysection1.$$.fragment);
    			t3 = space();
    			create_component(privacypolicysection2.$$.fragment);
    			t4 = space();
    			create_component(privacypolicysection3.$$.fragment);
    			t5 = space();
    			create_component(privacypolicysection4.$$.fragment);
    			t6 = space();
    			create_component(privacypolicysection5.$$.fragment);
    			t7 = space();
    			create_component(privacypolicysection6.$$.fragment);
    			t8 = space();
    			create_component(privacypolicysection7.$$.fragment);
    			t9 = space();
    			create_component(privacypolicysection8.$$.fragment);
    			t10 = space();
    			create_component(privacypolicysection9.$$.fragment);
    			t11 = space();
    			create_component(privacypolicysection10.$$.fragment);
    			t12 = space();
    			create_component(footer.$$.fragment);
    			attr(div0, "class", "max-w-7xl mx-auto px-4 sm:px-6");
    			attr(div1, "class", "relative bg-white");
    		},
    		m(target, anchor) {
    			insert(target, div1, anchor);
    			append(div1, div0);
    			mount_component(navbar, div0, null);
    			append(div0, t0);
    			mount_component(header, div0, null);
    			append(div0, t1);
    			mount_component(privacypolicysection0, div0, null);
    			append(div0, t2);
    			mount_component(privacypolicysection1, div0, null);
    			append(div0, t3);
    			mount_component(privacypolicysection2, div0, null);
    			append(div0, t4);
    			mount_component(privacypolicysection3, div0, null);
    			append(div0, t5);
    			mount_component(privacypolicysection4, div0, null);
    			append(div0, t6);
    			mount_component(privacypolicysection5, div0, null);
    			append(div0, t7);
    			mount_component(privacypolicysection6, div0, null);
    			append(div0, t8);
    			mount_component(privacypolicysection7, div0, null);
    			append(div0, t9);
    			mount_component(privacypolicysection8, div0, null);
    			append(div0, t10);
    			mount_component(privacypolicysection9, div0, null);
    			append(div0, t11);
    			mount_component(privacypolicysection10, div0, null);
    			append(div0, t12);
    			mount_component(footer, div0, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(navbar.$$.fragment, local);
    			transition_in(header.$$.fragment, local);
    			transition_in(privacypolicysection0.$$.fragment, local);
    			transition_in(privacypolicysection1.$$.fragment, local);
    			transition_in(privacypolicysection2.$$.fragment, local);
    			transition_in(privacypolicysection3.$$.fragment, local);
    			transition_in(privacypolicysection4.$$.fragment, local);
    			transition_in(privacypolicysection5.$$.fragment, local);
    			transition_in(privacypolicysection6.$$.fragment, local);
    			transition_in(privacypolicysection7.$$.fragment, local);
    			transition_in(privacypolicysection8.$$.fragment, local);
    			transition_in(privacypolicysection9.$$.fragment, local);
    			transition_in(privacypolicysection10.$$.fragment, local);
    			transition_in(footer.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(navbar.$$.fragment, local);
    			transition_out(header.$$.fragment, local);
    			transition_out(privacypolicysection0.$$.fragment, local);
    			transition_out(privacypolicysection1.$$.fragment, local);
    			transition_out(privacypolicysection2.$$.fragment, local);
    			transition_out(privacypolicysection3.$$.fragment, local);
    			transition_out(privacypolicysection4.$$.fragment, local);
    			transition_out(privacypolicysection5.$$.fragment, local);
    			transition_out(privacypolicysection6.$$.fragment, local);
    			transition_out(privacypolicysection7.$$.fragment, local);
    			transition_out(privacypolicysection8.$$.fragment, local);
    			transition_out(privacypolicysection9.$$.fragment, local);
    			transition_out(privacypolicysection10.$$.fragment, local);
    			transition_out(footer.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(div1);
    			destroy_component(navbar);
    			destroy_component(header);
    			destroy_component(privacypolicysection0);
    			destroy_component(privacypolicysection1);
    			destroy_component(privacypolicysection2);
    			destroy_component(privacypolicysection3);
    			destroy_component(privacypolicysection4);
    			destroy_component(privacypolicysection5);
    			destroy_component(privacypolicysection6);
    			destroy_component(privacypolicysection7);
    			destroy_component(privacypolicysection8);
    			destroy_component(privacypolicysection9);
    			destroy_component(privacypolicysection10);
    			destroy_component(footer);
    		}
    	};
    }

    class PrivacyPolicy extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, null, create_fragment$1, safe_not_equal, {});
    	}
    }

    /* src/App.svelte generated by Svelte v3.49.0 */

    function create_fragment(ctx) {
    	let main;
    	let router;
    	let current;
    	router = new Router({ props: { routes: /*routes*/ ctx[0] } });

    	return {
    		c() {
    			main = element("main");
    			create_component(router.$$.fragment);
    		},
    		m(target, anchor) {
    			insert(target, main, anchor);
    			mount_component(router, main, null);
    			current = true;
    		},
    		p: noop,
    		i(local) {
    			if (current) return;
    			transition_in(router.$$.fragment, local);
    			current = true;
    		},
    		o(local) {
    			transition_out(router.$$.fragment, local);
    			current = false;
    		},
    		d(detaching) {
    			if (detaching) detach(main);
    			destroy_component(router);
    		}
    	};
    }

    function instance($$self) {
    	let routes = {
    		'/': Home,
    		'/about': About,
    		'/support': Support,
    		'/privacypolicy': PrivacyPolicy
    	};

    	return [routes];
    }

    class App extends SvelteComponent {
    	constructor(options) {
    		super();
    		init(this, options, instance, create_fragment, safe_not_equal, {});
    	}
    }

    const app = new App({
        target: document.getElementById('app')
    });

    return app;

})();
