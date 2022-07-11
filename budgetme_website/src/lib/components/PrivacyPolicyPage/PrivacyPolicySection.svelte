<script lang="ts">
  import { element } from 'svelte/internal';

  export let title: string;
  export let content: string[];
</script>

<div class="py-4">
  <div class="flex-col lg:mx-36 md:mx-20 sm:mx-18">
    <h3 class="font-semibold text-2xl py-4">
      {title}
    </h3>
    {#each content as element, i}
      {#if element.includes('\n')}
        <span>
          <h6>{element} <br /></h6>
        </span>
      {:else if element.includes('\t')}
        <br />
        <h6>{element} <br /> <br /></h6>
      {:else if element.includes('\b')}
        <h6 class="bld">{element} <br /> <br /></h6>
      {:else}
        <h6>{element} <br /> <br /></h6>
      {/if}
    {/each}
  </div>
</div>

<style>
  h6 {
    @apply font-normal text-lg;
  }
  h6.bld {
    @apply font-medium text-lg;
  }
</style>
