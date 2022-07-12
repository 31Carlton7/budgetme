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
  import SecondaryLogo from './SecondaryLogo.svelte';
  export let text: string;
</script>

<div class="flex items-center justify-center">
  <div class="flex-col items-center justify-center py-12">
    <SecondaryLogo />
    <h1
      class="text-3xl sm:text-3xl md:text-4xl xl:text-5xl py-6 text-start text-gray-900 font-bold leading-7 md:leading-10"
    >
      {text}
    </h1>
  </div>
</div>
