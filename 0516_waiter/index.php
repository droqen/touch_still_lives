<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0">
		<title>web sample test</title>
		<style>
html, body, #canvas {
	margin: 0;
	padding: 0;
	border: 0;
}

body {
	color: white;
	background-color: black;
	overflow: hidden;
	touch-action: none;
}

#canvas {
	display: block;
}

#canvas:focus {
	outline: none;
}

#status, #status-splash, #status-progress {
	position: absolute;
	left: 0;
	right: 0;
}

#status, #status-splash {
	top: 0;
	bottom: 0;
}

#status {
	background-color: #242424;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	visibility: hidden;
}

#status-splash {
	max-height: 100%;
	max-width: 100%;
	margin: auto;
}

#status-progress, #status-notice {
	display: none;
}

#status-progress {
	bottom: 10%;
	width: 50%;
	margin: 0 auto;
}

#status-notice {
	background-color: #5b3943;
	border-radius: 0.5rem;
	border: 1px solid #9b3943;
	color: #e0e0e0;
	font-family: 'Noto Sans', 'Droid Sans', Arial, sans-serif;
	line-height: 1.3;
	margin: 0 2rem;
	overflow: hidden;
	padding: 1rem;
	text-align: center;
	z-index: 1;
}
		</style>
		<style>
body {
	min-height: 100vh;
}
#canvas {
	/* pico-8 pixel perfect */
	image-rendering: optimizeSpeed;
	image-rendering: -moz-crisp-edges;
	image-rendering: -webkit-optimize-contrast;
	image-rendering: optimize-contrast;
	image-rendering: pixelated;
	-ms-interpolation-mode: nearest-neighbor;
	border: 0;
	border-image-width: 0;
	outline: none;
}
		</style>
		<!-- <link id="-gd-engine-icon" rel="icon" type="image/png" href="index.icon.png" />
<link rel="apple-touch-icon" href="index.apple-touch-icon.png"/> -->

	</head>
	<body>
		<canvas id="canvas">
			Your browser does not support the canvas tag.
		</canvas>

		<noscript>
			Your browser does not support JavaScript.
		</noscript>

		<div id="status">
			<img id="status-splash" src="splash.png" alt="">
			<progress id="status-progress"></progress>
			<div id="status-notice"></div>
		</div>

		<script src="engine/godot.js"></script>
		<script src="engine/cat.js" defer></script>
		<script>
			const canvasEl = document.getElementById("canvas")
			const canvasParent = canvasEl.parentElement;

			function isArrayOrTypedArray(x) {
				return Boolean(
					x && (typeof x === 'object') && (Array.isArray(x) || (ArrayBuffer.isView(x) && !(x instanceof DataView)))
				);
			}

			window.addEventListener('canvasGameLoaded', (_ev)=>{
				console.log(`game loaded`);
				resizeCanvas();
			});

			let gameWidth = 200;
			let gameHeight = 200;

			window.addEventListener('setGameSize', (size)=>{
				gameWidth = Number(size['w']);
				gameHeight = Number(size['h']);
				console.log(`setGameSize(${gameWidth}, ${gameHeight})`);
				resizeCanvas();
			})
			window.addEventListener('resize', (_ev)=>{ resizeCanvas(); }, true);

			function resizeCanvas() {
				let pw = canvasParent.clientWidth;	
				let ph = canvasParent.clientHeight;
				let bw = gameWidth;
				let bh = gameHeight;
				let scale = Math.floor(Math.min(pw/bw, ph/bh));
				if (scale < 1) { scale = 1; }
				let sw = bw * scale;
				let sh = bh * scale;
				canvasEl.style.position = "absolute";
				canvasEl.style.left = `${Math.floor((pw-sw)/2)}px`;
				canvasEl.style.top = `${Math.floor((ph-sh)/2)}px`;
				canvasEl.width = sw;
				canvasEl.height = sh;
			}
		</script>
		<script>
			// setTimeout(()=>{
			// 	if (!Cat.try_start_game('game/default2.zip', <?php echo filesize('game/default2.zip'); ?>)) {
			// 		console.log("failed Cat.try_start_game");
			// 	}
			// }, 3000);
		</script>
	</body>
</html>

