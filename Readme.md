# Mean Template
## Red Rabbit Development

This template uses the great gulp task manager to manage its tasks. The tasks are very simple:

```
cult help - display list of commands
cult build - build all necessary files
cult test - run tests
cult serve - start serving files
cult tdd - run tests in watch mode
cult compile - compile production-ready assets (not done yet)
```

To use as your own project:

```
git clone git@github.com:RedRabbitDevelopment/mean-template.git
rm -rf mean-template/.git
mv mean-template <project-name>
cd <project-name>
npm install
bower install
cult serve
```

To use repeatedly:

```
git clone git@github.com:RedRabbitDevelopment/mean-template.git
rm -rf mean-template/.git
cp -r mean-template <project1>
cp -r mean-template <project2>
cp -r mean-template <project3>
# for each project
cd project1
npm install
bower install
cult serve
```
