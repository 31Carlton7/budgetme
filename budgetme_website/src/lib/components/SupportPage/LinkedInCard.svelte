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
  const linkedInSvgPath: string =
    'M5.26433 21.3846H0.95842V7.51803H5.26433V21.3846ZM3.10906 5.62651C1.73217 5.62651 0.615356 4.48603 0.615356 3.10911C0.615356 2.44773 0.878085 1.81343 1.34574 1.34576C1.8134 0.878091 2.44769 0.615356 3.10906 0.615356C3.77042 0.615356 4.40471 0.878091 4.87237 1.34576C5.34003 1.81343 5.60275 2.44773 5.60275 3.10911C5.60275 4.48603 4.48548 5.62651 3.10906 5.62651ZM21.38 21.3846H17.0833V14.6344C17.0833 13.0257 17.0509 10.9627 14.8446 10.9627C12.6059 10.9627 12.2628 12.7105 12.2628 14.5185V21.3846H7.96154V7.51803H12.0913V9.40956H12.1516C12.7264 8.32008 14.1307 7.17033 16.2257 7.17033C20.5835 7.17033 21.3846 10.0401 21.3846 13.7675V21.3846H21.38Z';

  let link: string = 'https://www.linkedin.com/in/carlton-aikins-a34a14226/';
  let platform: string = 'LinkedIn';
  let tag: string = '@Carlton Aikins';
</script>

<a
  href={link}
  target="_blank"
  class="group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-linkedin-100 lg:max-w-full lg:flex"
>
  <div class="flex items-center justify-center">
    <a
      href={link}
      target="_blank"
      class="p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-linkedin-200 group-hover:text-gray-100"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="w-5 h-5"
        fill="currentColor"
        viewBox="0 0 24 24"
        ><path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d={linkedInSvgPath}
        /></svg
      >
    </a>
    <p class="group-hover:text-gray-100">{platform}</p>
  </div>
  <p class="group-hover:text-gray-100">{tag}</p>
</a>
