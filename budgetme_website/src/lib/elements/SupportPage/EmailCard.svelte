<script lang="ts">
  import { emailSvgPath } from '../../Constants';

  let link: string = 'mailto:carltonaikins7@gmail.com';
  let platform: string = 'Email';
  let tag: string = 'carltonaikins7@gmail.com';
</script>

<a
  href={link}
  target="_blank"
  class="group p-2 my-4 rounded-md max-w-sm w-full justify-between items-center transition-colors bg-gray-200 hover:bg-red-500 lg:max-w-full lg:flex"
>
  <div class="flex items-center justify-center">
    <a
      href={link}
      target="_blank"
      class="p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-red-600 group-hover:text-gray-100"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-5 w-5"
        viewBox="0 0 20 20"
        fill="currentColor"
      >
        <path
          d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"
        />
        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
      </svg>
    </a>
    <p class="group-hover:text-gray-100">{platform}</p>
  </div>
  <p class="group-hover:text-gray-100">{tag}</p>
</a>
