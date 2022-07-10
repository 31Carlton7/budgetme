import { publish } from 'gh-pages';

publish(
  'public',
  {
    branch: 'gh-pages',
    silent: true,
    repo:
      'https://' +
      process.env.GITHUB_TOKEN +
      '@github.com/31carlton7/budgetme.git',
    user: {
      name: 'Carlton Aikins',
      email: 'carltonaikins7@gmail.com',
    },
  },
  () => {
    console.log('Deploy Complete!');
  }
);
