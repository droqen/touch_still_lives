Cat = (function () {
	const statusOverlay = document.getElementById('status');
	const statusProgress = document.getElementById('status-progress');
	const statusNotice = document.getElementById('status-notice');

	let initializing = true;
	let statusMode = '';

	function setStatusMode(mode) {
		if (statusMode === mode || !initializing) {
			return;
		}
		if (mode === 'hidden') {
			statusOverlay.remove();
			initializing = false;
			return;
		}
		statusOverlay.style.visibility = 'visible';
		statusProgress.style.display = mode === 'progress' ? 'block' : 'none';
		statusNotice.style.display = mode === 'notice' ? 'block' : 'none';
		statusMode = mode;
	}

	function setStatusNotice(text) {
		while (statusNotice.lastChild) {
			statusNotice.removeChild(statusNotice.lastChild);
		}
		const lines = text.split('\n');
		lines.forEach((line) => {
			statusNotice.appendChild(document.createTextNode(line));
			statusNotice.appendChild(document.createElement('br'));
		});
	}

	function displayFailureNotice(err) {
		const msg = err.message || err;
		console.error(msg);
		setStatusNotice(msg);
		setStatusMode('notice');
		initializing = false;
	}

	const missing = Engine.getMissingFeatures({
		threads: GODOT_THREADS_ENABLED,
	});

	if (missing.length !== 0) {
		if (GODOT_CONFIG['serviceWorker'] && GODOT_CONFIG['ensureCrossOriginIsolationHeaders'] && 'serviceWorker' in navigator) {
			// There's a chance that installing the service worker would fix the issue
			Promise.race([
				navigator.serviceWorker.getRegistration().then((registration) => {
					if (registration != null) {
						return Promise.reject(new Error('Service worker already exists.'));
					}
					return registration;
				}).then(() => engine.installServiceWorker()),
				// For some reason, `getRegistration()` can stall
				new Promise((resolve) => {
					setTimeout(() => resolve(), 2000);
				}),
			]).catch((err) => {
				console.error('Error while registering service worker:', err);
			}).then(() => {
				window.location.reload();
			});
		} else {
			// Display the message as usual
			const missingMsg = 'Error\nThe following features required to run Godot projects on the Web are missing:\n';
			displayFailureNotice(missingMsg + missing.join('\n'));
		}
	} else {
		setStatusMode('progress');
		engine.startGame({
			'onProgress': function (current, total) {
				if (current > 0 && total > 0) {
					statusProgress.value = current;
					statusProgress.max = total;
				} else {
					statusProgress.removeAttribute('value');
					statusProgress.removeAttribute('max');
				}
			},
		}).then(() => {
			setStatusMode('hidden');
			let event = new Event('canvasGameLoaded', {});
			window.dispatchEvent(event);
		}, displayFailureNotice);
	}

	var set_game_size = function(w,h) {
		let setGameSizeEvent = new Event("setGameSize", {});
		setGameSizeEvent['w'] = w;
		setGameSizeEvent['h'] = h;
		
		window.dispatchEvent(setGameSizeEvent);
	}

	return {
		set_game_size : set_game_size,
	}
}());

if (typeof window !== 'undefined') {
	window['Cat'] = Cat;
	console.log("it must be done. is Cat in window?")
	console.log(window['Cat'])
} else {
	console.log("window not found, could not put Cat in window :(");
}