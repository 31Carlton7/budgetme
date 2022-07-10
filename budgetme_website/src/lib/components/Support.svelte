<script>
  import Footer from '../elements/Footer.svelte';
  import Header from '../elements/Header.svelte';
  import Navbar from '../elements/Navbar.svelte';
  import EmailCard from '../elements/SupportPage/EmailCard.svelte';
  import InstagramCard from '../elements/SupportPage/InstagramCard.svelte';
  import LinkedInCard from '../elements/SupportPage/LinkedInCard.svelte';
  import SupportCard from '../elements/SupportPage/LinkedInCard.svelte';
  import TwitterCard from '../elements/SupportPage/TwitterCard.svelte';
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
    <Footer />
  </div>
</div>
