<script>
  import AppStoreDownloadButton from '../AppStoreDownloadButton.svelte';
  import GooglePlayDownloadButton from '../GooglePlayDownloadButton.svelte';
</script>

<div class="hero-section">
  <div class="container mx-auto flex flex-col items-center py-12 sm:py-24">
    <div
      class="w-11/12 sm:w-2/3 lg:flex justify-center items-center flex-col mb-5 sm:mb-10"
    >
      <h6
        class="font-semibold text-primary-500 pb-4 flex items-center justify-center"
      >
        A Budgeting & Savings App
      </h6>
      <h1
        class="text-3xl sm:text-3xl md:text-4xl lg:text-5xl xl:text-6xl text-center text-gray-900 font-bold leading-7 md:leading-10"
      >
        Save money and achieve your goal
      </h1>
      <p
        class="mt-5 sm:mt-10 lg:w-10/12 text-gray-600 font-medium text-center text-sm sm:text-lg"
      >
        Save money this summer for the more
        <span class="italic">meaningful</span>
        things.
      </p>
    </div>
    <div class="flex justify-center items-center">
      <AppStoreDownloadButton />
      <GooglePlayDownloadButton />
    </div>
  </div>
</div>
