<!--
BudgetMe iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->

<script lang="ts">
  import AboutMockupSection from '../lib/components/AboutPage/AboutMockupSection.svelte';

  import Banner from '../lib/components/Banner.svelte';
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
    <Banner />
    <Footer />
  </div>
</div>
