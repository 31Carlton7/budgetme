<script>
  import AppStoreDownloadButton from '../elements/AppStoreDownloadButton.svelte';
  import Banner from '../elements/Banner.svelte';
  import Footer from '../elements/Footer.svelte';
  import GooglePlayDownloadButton from '../elements/GooglePlayDownloadButton.svelte';
  import HeroSection from '../elements/HeroSection.svelte';
  import Logo from '../elements/Logo.svelte';
  import Navbar from '../elements/Navbar.svelte';
</script>

<div class="relative bg-gradient-to-b from-white to-gray-200">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 justify-center">
    <Navbar />
    <HeroSection />
    <div class="mockup py-14 flex items-center justify-center">
      <img src="static/images/mockup_home.png" alt="" width="650" />
    </div>
    <Banner />
    <Footer />
  </div>
</div>
