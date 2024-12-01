<template>
	<div>
		<p>Counter: {{ count }}</p>
		<button @click="increment">Increment</button>
	</div>
</template>

<script setup lang="ts">

import { ref } from 'vue';

const count = ref(0);

const increment = () => {
	count.value++;
}

console.log('Counter component loaded');

</script>
