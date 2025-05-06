<cfoutput>
<!doctype html>
<html lang="en">
<head>
	<!--- Metatags --->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="ColdBox Application Template">
    <meta name="author" content="Ortus Solutions, Corp">

	<!---Base URL --->
	<base href="#event.getHTMLBaseURL()#" />

	<!---
		CSS
		- Bootstrap
		- Alpine.js
	--->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	<style>
		.text-blue { color:##379BC1; }
		/* Example: Full-screen background */
		.fullscreen-bg {
			background-image: url('/includes/images/background.png');
			background-size: cover;
			background-position: center;
			background-repeat: no-repeat;
			width: 100%;
			height: 100vh; /* Full viewport height */
		}

	</style>

	<!--- Title --->
	<title>#event.getCurrentEvent()# | DEMO</title>
</head>
<body
	data-spy="scroll"
	data-target=".navbar"
	data-offset="50"
	style="padding-top: 56px"
	class="d-flex flex-column h-100"
>
	<!---Top NavBar --->
	<header class="">
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
			<div class="container-fluid">
				<!---Brand --->
				<a class="navbar-brand" href="#event.buildLink( 'main' )#">
					<strong>SQL JSON DEMO</strong>
				</a>

				<!--- Mobile Toggler --->
				<button
					class="navbar-toggler"
					type="button"
					data-bs-toggle="collapse"
					data-bs-target="##navbarSupportedContent"
					aria-controls="navbarSupportedContent"
					aria-expanded="false"
					aria-label="Toggle navigation"
				>
					<span class="navbar-toggler-icon"></span>
				</button>

				<div class="collapse navbar-collapse" id="navbarSupportedContent">

					<ul class="navbar-nav ms-5 mb-2 mb-lg-0">
						<li class="nav-item">
							<a class="nav-link" href="/demo/">Home</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/demo/output/">Output</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/demo/classic/">Classic</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/demo/json/">JSON</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/demo/qb/">QB</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="/demo/cache/">Cache</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
	</header>

	<!---Container And Views --->
	<main class="flex-shrink-0 fullscreen-bg">
		#view()#
	</main>

	<!--- Footer --->
	<footer class="w-100 bottom-0 position-fixed border-top py-3 mt-5 bg-light">
		<div class="container">

		</div>
	</footer>

	<!---
		JavaScript
		- Bootstrap
		- Popper
		- Alpine.js
	--->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js" integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V" crossorigin="anonymous"></script>
	<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
</body>
</html>
</cfoutput>
