<script lang="ts">
  import Logo from './Logo.svelte';

  let menuIsOpen: Boolean = false;

  function handleMenu() {
    menuIsOpen = !menuIsOpen;
  }
</script>

<div
  class="flex justify-between items-center py-4 md:justify-center md:space-x-10"
>
  <div class="flex justify-start lg:w-0 lg:flex-1">
    <a href="/" class="cursor-pointer select-none">
      <svelte:component this={Logo} />
    </a>
  </div>

  <div class="-mr-2 -my-2 md:hidden" on:click={handleMenu}>
    <button
      type="button"
      class="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
      aria-expanded="false"
    >
      <span class="sr-only">Open menu</span>
      <!-- Heroicon name: outline/menu -->
      <svg
        class="h-6 w-6"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="2"
        stroke="currentColor"
        aria-hidden="true"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M4 6h16M4 12h16M4 18h16"
        />
      </svg>
    </button>
  </div>

  <nav class="hidden md:flex space-x-10">
    <a href="#/about" class="text-base font-semibold text-gray-900"> About </a>
    <a href="#/support" class="text-base font-semibold text-gray-900">
      Support
    </a>
    <a href="#/privacypolicy" class="text-base font-semibold text-gray-900">
      Privacy Policy
    </a>
  </nav>

  <div class="hidden md:flex items-center justify-end md:flex-1 lg:w-0">
    <a
      href="/"
      class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-6 py-2.5 border-transparent rounded-full text-base font-medium text-white bg-gradient-to-b from-primary-500 to-primary-600"
    >
      Download
    </a>
  </div>

  <!--Mobile Menu-->
  <div
    class="absolute top-0 inset-x-0 p-2 transition transform origin-top-right md:hidden bm-navbar  {menuIsOpen
      ? 'bm-open'
      : 'hidden'}"
  >
    <div
      class="rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 bg-white divide-y-2 divide-gray-50"
    >
      <div class="pt-5 pb-6 px-5">
        <div class="flex items-center justify-between">
          <div>
            <Logo />
          </div>
          <div class="-mr-2" on:click={handleMenu}>
            <button
              type="button"
              class="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
            >
              <span class="sr-only">Close menu</span>
              <!-- Heroicon name: outline/x -->
              <svg
                class="h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        </div>
        <div class="mt-6">
          <nav class="grid gap-y-8">
            <a
              href="#/about"
              class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"
            >
              <span class="ml-3 text-base font-medium text-gray-900">
                About
              </span>
            </a>

            <a
              href="/support"
              class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"
            >
              <span class="ml-3 text-base font-medium text-gray-900">
                Support
              </span>
            </a>

            <a
              href="/privacypolicy"
              class="-m-3 p-3 flex items-center rounded-md hover:bg-gray-50"
            >
              <span class="ml-3 text-base font-medium text-gray-900">
                Privacy Policy
              </span>
            </a>
          </nav>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .bm-navbar {
    width: 0;
  }

  .bm-open {
    width: 100%;
  }
</style>
