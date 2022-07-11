import svelte from 'rollup-plugin-svelte';
import commonjs from '@rollup/plugin-commonjs';
import resolve from '@rollup/plugin-node-resolve';
import sveltePreprocess from 'svelte-preprocess';
import typescript from '@rollup/plugin-typescript';
import postcss from 'rollup-plugin-postcss';

export default {
  input: './src/main.ts',
  output: {
    format: 'iife',
    file: './public/build/bundle.js',
  },
  plugins: [
    svelte({
      preprocess: sveltePreprocess(),
    }),
    resolve({ browser: true }),
    commonjs(),
    typescript(),
    postcss({
      minimize: true,
      modules: true,
      use: {
        sass: null,
        stylus: null,
        less: { javascriptEnabled: true },
      },
      extract: true,
    }),
  ],
};
