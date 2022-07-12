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
  export let title: string;
  export let content: string;
  export let mockupImage: string;
  export let alignmentRight: boolean;
</script>

<div
  class="flex py-24 items-center justify-center {alignmentRight
    ? ''
    : 'flex-row-reverse'}"
>
  <img src={mockupImage} alt="" width="165" />
  <div class="flex-col w-[22rem] ">
    <h3
      class="font-semibold lg:text-2xl text-lg {alignmentRight
        ? 'text-right'
        : 'text-left'} mx-8"
    >
      {title}
    </h3>
    <h6
      class="font-normal lg:text-2xl text-lg {alignmentRight
        ? 'text-right'
        : 'text-left'} mx-8"
    >
      {content}
    </h6>
  </div>
</div>
