<script lang="ts">
  import Banner from '../lib/components/Banner.svelte';
  import Footer from '../lib/components/Footer.svelte';
  import Header from '../lib/components/Header.svelte';
  import Navbar from '../lib/components/Navbar.svelte';
  import EmailCard from '../lib/components/SupportPage/EmailCard.svelte';
  import InstagramCard from '../lib/components/SupportPage/InstagramCard.svelte';
  import LinkedInCard from '../lib/components/SupportPage/LinkedInCard.svelte';
  import SupportCard from '../lib/components/SupportPage/LinkedInCard.svelte';
  import TwitterCard from '../lib/components/SupportPage/TwitterCard.svelte';
</script>

<div class="relative bg-white">
  <div class="max-w-7xl mx-auto px-4 sm:px-6">
    <Navbar />
    <Header text="BudgetMe Support" />
    <div class="flex items-center justify-center">
      <div class="flex-col items-center justify-center mb-16">
        <h2 class="text-2xl">
          If you would to contact us, you can do so via the following links.
        </h2>
        <EmailCard />
        <LinkedInCard />
        <TwitterCard />
        <InstagramCard />
      </div>
    </div>
    <Banner />
    <Footer />
  </div>
</div>
