<script>
  import AppStoreDownloadButton from './AppStoreDownloadButton.svelte';
  import GooglePlayDownloadButton from './GooglePlayDownloadButton.svelte';

  import Logo from './Logo.svelte';
</script>

<footer
  class="py-4 bg-gray-100 p-12 w-screen left-1/2 right-1/2 -mr-[50vw] -ml-[50vw] relative"
>
  <div class="md:flex md:justify-between md:px-36 sm:px-24">
    <div class="mb-4 md:mb-0">
      <a href="/" class="flex items-center">
        <Logo />
      </a>
      <div class="w-80">
        <p class="mt-5 sm:mt-10 lg:w-10/12 text-gray-600 text-lg">
          Save money this summer for the more
          <span class="italic">meaningful</span>
          things.
        </p>
        <div class="social-buttons sm:flex sm:items-center sm:justify-between">
          <div class="flex mt-4 py-4 space-x-6 sm:justify-center sm:mt-0">
            <a
              href="https://www.linkedin.com/in/carlton-aikins-a34a14226/"
              target="_blank"
              class="social-btn hover:text-gray-900"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-5 h-5"
                fill="currentColor"
                viewBox="0 0 24 24"
                ><path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M 100.3 448 H 7.4 V 148.9 h 92.9 V 448 Z M 53.8 108.1 C 24.1 108.1 0 83.5 0 53.8 S 24.1 0 53.8 0 s 53.8 24.1 53.8 53.8 s -24.1 54.3 -53.8 54.3 Z M 448 448 h -92.7 V 302.4 c 0 -34.7 -0.7 -79.2 -48.3 -79.2 c -48.3 0 -55.7 37.7 -55.7 76.7 V 448 h -92.8 V 148.9 h 89.1 v 40.8 h 1.3 c 12.4 -23.5 42.7 -48.3 87.9 -48.3 c 94 0 111.3 61.9 111.3 142.3 V 448 h -0.1 Z"
                /></svg
              >
            </a>
            <a
              href="https://github.com/31carlton7/budgetme"
              target="_blank"
              class="social-btn hover:text-gray-900"
            >
              <svg
                class="w-5 h-5"
                fill="currentColor"
                viewBox="0 0 24 24"
                aria-hidden="true"
                ><path
                  fill-rule="evenodd"
                  d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                  clip-rule="evenodd"
                /></svg
              >
            </a>
            <a
              href="https://www.twitter.com/31carlton7"
              target="_blank"
              class="social-btn hover:text-gray-900"
            >
              <svg
                class="w-5 h-5"
                fill="currentColor"
                viewBox="0 0 24 24"
                aria-hidden="true"
                ><path
                  d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"
                /></svg
              >
            </a>
            <a
              href="https://www.instagram.com/31carlton7"
              target="_blank"
              class="social-btn hover:text-gray-900"
            >
              <svg
                class="w-5 h-5"
                fill="currentColor"
                viewBox="0 0 24 24"
                aria-hidden="true"
                ><path
                  fill-rule="evenodd"
                  d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z"
                  clip-rule="evenodd"
                /></svg
              >
            </a>
          </div>
        </div>
      </div>
    </div>
    <div class="grid grid-cols-2 gap-8 sm:gap-6 sm:grid-cols-3">
      <div>
        <h2 class="mb-6 text-lg font-semibold text-gray-600">BudgetMe</h2>
        <ul class="text-gray-600 ">
          <li class="mb-4">
            <a href="/" class="hover:text-gray-500">Website</a>
          </li>
          <li class="mb-4">
            <a href="/about" class="hover:text-gray-500">About</a>
          </li>
          <li class="mb-4">
            <a href="/privacypolicy" class="hover:text-gray-500"
              >Privacy Policy</a
            >
          </li>
        </ul>
      </div>
      <div>
        <h2 class="mb-6 text-lg font-semibold text-gray-600 ">Contact</h2>
        <ul class="text-gray-600 ">
          <li class="mb-4">
            <a
              href="mailto:carltonaikins7@gmail.com"
              class="hover:text-gray-500 ">Email</a
            >
          </li>
          <li>
            <a href="/support" class="hover:text-gray-500">Support</a>
          </li>
        </ul>
      </div>
      <div>
        <h2 class="text-lg font-semibold text-gray-600 ">Download</h2>
        <ul class="text-gray-600 ">
          <li class="-mb-6">
            <a href="/" class="hover:text-gray-500 ">
              <AppStoreDownloadButton />
            </a>
          </li>
          <li>
            <a href="/" class="hover:text-gray-500">
              <GooglePlayDownloadButton />
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <div class="my-32 flex-row flex justify-between space-x-16 px-36">
    <span class="text-sm text-gray-600 sm:text-center"
      >Copyright © 2022 <a href="/" class="hover:text-gray-500">BudgetMe</a>
    </span>
    <span class="text-sm text-gray-600 sm:text-center"
      >Created by Carlton Aikins
    </span>
  </div>
</footer>

<style>
  .social-btn {
    @apply p-2 rounded-lg bg-gray-200 text-gray-600;
  }
</style>
