
describe 'index page works', ->
  it 'should hit the index page', ->
    browser.get '/'

    element(by.model('yourName')).sendKeys('Julie')

    greeting = element by.binding 'yourName'

    expect(greeting.getText()).toEqual 'Hello Julie!'

