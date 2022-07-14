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
  import HeroSection from '../lib/components/HomePage/HeroSection.svelte';
  import Navbar from '../lib/components/Navbar.svelte';
</script>

<div class="relative bg-gradient-to-b from-white to-gray-200 overflow-x-hidden">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 justify-center">
    <Navbar />
    <HeroSection />
    <div class="py-14 flex items-center justify-center">
      <img src="images/mockup_home.png" alt="" width="650" />
    </div>
    <Banner />
    <Footer />
  </div>
</div>
