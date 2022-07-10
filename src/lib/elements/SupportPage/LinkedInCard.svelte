<script lang="ts">
  import { linkedInSvgPath } from '../../Constants';

  let link: string = 'https://www.linkedin.com/in/carlton-aikins-a34a14226/';
  let platform: string = 'LinkedIn';
  let tag: string = '@Carlton Aikins';
</script>

<a
  href={link}
  target="_blank"
  class="group p-2 my-4 rounded-md max-w-sm w-full justify-between items-center transition-colors bg-gray-200 hover:bg-linkedin-100 lg:max-w-full lg:flex"
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
