<script lang="ts">
  import './app.css';
  import router from 'page';
  import Home from './lib/components/Home.svelte';
  import About from './lib/components/About.svelte';
  import Support from './lib/components/Support.svelte';
  import PrivacyPolicy from './lib/components/PrivacyPolicy.svelte';

  let page: any;

  router('/', () => (page = Home));
  router('/about', () => (page = About));
  router('/support', () => (page = Support));
  router('/privacypolicy', () => (page = PrivacyPolicy));

  router.start();
</script>

<main>
  <svelte:component this={page} />
</main>
