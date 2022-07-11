<script>
  import Banner from '../lib/components/Banner.svelte';
  import Footer from '../lib/components/Footer.svelte';
  import HeroSection from '../lib/components/HomePage/HeroSection.svelte';
  import Navbar from '../lib/components/Navbar.svelte';
</script>

<div class="relative bg-gradient-to-b from-white to-gray-200">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 justify-center">
    <Navbar />
    <HeroSection />
    <div class="py-14 flex items-center justify-center">
      <img src="../src/assets/images/mockup_home.png" alt="" width="650" />
    </div>
    <Banner />
    <Footer />
  </div>
</div>
