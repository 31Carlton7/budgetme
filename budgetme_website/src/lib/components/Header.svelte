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
