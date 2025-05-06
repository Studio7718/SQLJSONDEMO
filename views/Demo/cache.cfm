<div class="container">
	<h1 class="text-white">Cache</h1>
	<!---  style="backdrop-filter: blur(16px);" --->
	<ul class="list-group opacity-75">
		<li class="list-group-item"><a href="/api/v1/show/cache/buildCache/">Build Full Cache</a> <a href="/api/v1/show/cache/buildCache/?debug=1"><i class="bi bi-bug-fill"></i></a> <span class="badge bg-light text-dark">(~80 sec)</span></li>
		<li class="list-group-item"><a href="/api/v1/show/cache/70104894/">Get Cached (1)</a> <a href="/api/v1/show/cache/70104894/?debug=1"><i class="bi bi-bug-fill"></i></a></li>
		<li class="list-group-item"><a href="/api/v1/show/cache/70104894/?cached=1">Get Query Cached (1)</a> <a href="/api/v1/show/cache/70104894/?debug=1&cached=1"><i class="bi bi-bug-fill"></i></a></li>
		<li class="list-group-item"><a href="/api/v1/show/cache/getShowsCache/">Get Full Cache</a> <a href="/api/v1/show/cache/getShowsCache/?debug=1"><i class="bi bi-bug-fill"></i></a></li>
		<li class="list-group-item"><a href="/api/v1/show/cache/getShowsCached/">Get Full Query Cached</a> <a href="/api/v1/show/cache/getShowsCached/?debug=1"><i class="bi bi-bug-fill"></i></a></li>
		<li class="list-group-item list-group-item-danger mt-4"><a href="/api/v1/show/cache/clearShowsCached/">Clear Query Cache</a> <a href="/api/v1/show/cache/clearShowsCached/?debug=1"><i class="bi bi-bug-fill"></i></a></li>
	</ul>
</div>