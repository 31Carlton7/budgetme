<script lang="ts">
  const twitterSvgPath: string =
    'M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84';

  let link: string = 'https://www.twitter.com/31carlton7';
  let platform: string = 'Twitter';
  let tag: string = '@31Carlton7';
</script>

<a
  href={link}
  target="_blank"
  class="group p-2 my-4 rounded-md max-w-sm w-full flex flex-1 justify-between items-center transition-colors bg-gray-200 hover:bg-twitter-100 lg:max-w-full lg:flex"
>
  <div class="flex items-center justify-center">
    <a
      href={link}
      target="_blank"
      class="p-2 mr-4 rounded-md bg-gray-300 text-gray-600 transition-colors group-hover:bg-twitter-200 group-hover:text-gray-100"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="w-5 h-5"
        fill="currentColor"
        viewBox="0 0 24 24"
        ><path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d={twitterSvgPath}
        /></svg
      >
    </a>
    <p class="group-hover:text-gray-100">{platform}</p>
  </div>
  <p class="group-hover:text-gray-100">{tag}</p>
</a>
