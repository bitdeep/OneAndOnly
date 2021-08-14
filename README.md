## `registry('word')`
Hash of owners by word. 
Use like `registry('word')` to return address ie 0x0

## `idByWords('word')`
Hash of token id by word.
Use like `idByWords('word')` to return 1

## `wordById('1')`
Hash of word id by tokenId.
Use like `wordById('1')` to return word

## `validProps('backgroundColor')`
Query properties values by propery key.
Use like `validProps('backgroundColor')` to return #ffffff

## `getFeatureOf('word')`
Map of features index by word, this is the features that owner set.
Features will only be set according to validProps
Call `getFeatureOf('word')` to get a list of 2 arrays:

```
['backgroundColor','font']
['#ffffff','Arial']
```

## `setFeature('word', 'backgroundColor', 'red')`
Allow user to set a feature paying a small fee

## `adminFeaturePrice('100000000000000000')`
Set feature feature price of 0.1 ether

## `adminTokenPrice('200000000000000000')`
Set token mint price of 0.2 ether

## `getBaseURIPrefix()`
Return the base url, like https://localhost/wrods


