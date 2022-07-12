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
