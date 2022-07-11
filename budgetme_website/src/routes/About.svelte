<script lang="ts">
  import AboutMockupSection from '../lib/components/AboutPage/AboutMockupSection.svelte';

  import Footer from '../lib/components/Footer.svelte';
  import Header from '../lib/components/Header.svelte';
  import Navbar from '../lib/components/Navbar.svelte';
</script>

<div class="relative bg-white">
  <div class="max-w-7xl mx-auto px-4 sm:px-6">
    <Navbar />
    <Header text="Welcome to BudgetMe" />
    <AboutMockupSection
      title="Intuitive & Simple"
      content="Create Goals in a simple and easy manner. No unnecessary features."
      mockupImage="images/mockup_about_1.png"
      alignmentRight={true}
    />
    <AboutMockupSection
      title="Modern User Interface"
      content="A 21st century feeling interface that makes the app more visually appealing and fun to use."
      mockupImage="images/mockup_about_2.png"
      alignmentRight={false}
    />
    <AboutMockupSection
      title="Informative"
      content="View transaction history to keep track of spending and saving habits."
      mockupImage="images/mockup_about_3.png"
      alignmentRight={true}
    />
    <AboutMockupSection
      title="Available in 12 languages and all currencies"
      content="No matter where you’re saving from, you can feel right at home with your native currency."
      mockupImage="images/mockup_about_4.png"
      alignmentRight={false}
    />
    <Footer />
  </div>
</div>
