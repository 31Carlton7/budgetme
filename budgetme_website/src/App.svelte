<script lang="ts">
  import './app.css';
  import Router from 'svelte-spa-router';

  import Home from './routes/Home.svelte';
  import About from './routes/About.svelte';
  import Support from './routes/Support.svelte';
  import PrivacyPolicy from './routes/PrivacyPolicy.svelte';

  let routes = {
    '/': Home,
    '/about': About,
    '/support': Support,
    '/privacypolicy': PrivacyPolicy,
  };
</script>

<main>
  <Router {routes} />
</main>
