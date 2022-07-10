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
  <img src={mockupImage} alt="" width="180" />
  <div class="flex-col w-[22rem] mx-36">
    <h3
      class="font-semibold text-2xl {alignmentRight
        ? 'text-right'
        : 'text-left'}"
    >
      {title}
    </h3>
    <h6
      class="font-normal text-2xl {alignmentRight ? 'text-right' : 'text-left'}"
    >
      {content}
    </h6>
  </div>
</div>
